//
//  ESCPersistenceCache.m
//  ESCDevelopKit
//
//  Created by 程巍巍 on 14-10-16.
//  Copyright (c) 2014年 Littocats. All rights reserved.
//

#import "ESCPersistenceCache.h"
#include "ESCCrypt.h"

#import <sqlite3.h>
#import <objc/runtime.h>
#import <objc/message.h>

#define kDBNAME                         @"org.littocats.toolset.persistencecache.persistence"
#define kDBTABLECACHEDOBJECTINFO        @"CACHEDOBJECTINFO"
#define kPERSISTENCEROOTPATH            @"org.littocats.toolset.persistencecache"

#define kPERSISTENCEPATH(cacheName,identifier) [[[NSTemporaryDirectory() stringByAppendingPathComponent:kPERSISTENCEROOTPATH] stringByAppendingPathComponent:cacheName] stringByAppendingPathComponent:identifier]

#define kIDENTIFIER      @"identifier"
#define kINVALIDDATE     @"invalid_at"          //失效期
#define kCREATEDATE      @"create_at"           //加入缓存的时间
#define kCACHENAME       @"cache_name"          //可能存在多个 cache 实例
#define kOBJECTTYPE      @"objc_type"

//#define kENCODESEL       @"escPersistenceData"
//#define kDECODESEL       @"escInstanceWithPersistenceData:"


/**
 *  object info
 */
static const char kESCPersistenceCachedObjectInfoKey;

static NSString *MD5(NSString *str);

@interface ESCPersistenceCacheManager : NSObject

+ (instancetype)manager;

+ (void)addPersistenceCache:(ESCPersistenceCache *)cache;

+ (void)removeCachedObject:(NSDictionary *)info;

+ (void)persistCachedObject:(id)info :(BOOL)flag;
+ (id)persistedObjectWithInfo:(NSDictionary *)info;
@end

@interface ESCPersistenceCache ()

@end

@implementation ESCPersistenceCache

+ (instancetype)persistenceCacheWithName:(NSString *)name
{
    ESCPersistenceCache *cache = nil;
    @synchronized(self){
        static NSMapTable *cacheList = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cacheList = [NSMapTable strongToWeakObjectsMapTable];
        });
        cache = [cacheList objectForKey:name];
        if (!cache) {
            cache = [ESCPersistenceCache alloc];
            struct objc_super super_instance = {
                .receiver       = cache,
                .super_class    = class_getSuperclass([ESCPersistenceCache class])
            };
            cache = ((id (*)(struct objc_super *, SEL))objc_msgSendSuper)(&super_instance,@selector(init));
            cache.name = name;
            
            //加入 cache instance 的管理
            [ESCPersistenceCacheManager addPersistenceCache:cache];
        }
    }
    return cache;
}

- (id)init
{
    [NSException raise:NSStringFromClass(self.class) format:@"\n ESCPersistenceCache do not support this initialise method .\n Please use [ESCPersistenceCache persistenceCacheWithIdentifier:identifier] ."];
    return nil;
}

#pragma mark- 存取方法
- (void)cacheObject:(id)obj
     withIdentifier:(NSString *)identifier
          validTime:(NSTimeInterval)validTime
{
    if (!obj) return;
    validTime = validTime <= 0 ? NSIntegerMax : validTime;
    
    NSDictionary *info = @{kIDENTIFIER  :identifier,
                           kCREATEDATE  :@([NSDate timeIntervalSinceReferenceDate]),
                           kINVALIDDATE :@(validTime + [NSDate timeIntervalSinceReferenceDate]),
                           kCACHENAME   :self.name,
                           kOBJECTTYPE  :NSStringFromClass([obj class])};
    [self cacheObject:obj withInfo:info :NO];
}

- (void)cacheObject:(id)obj withInfo:(NSDictionary *)info :(BOOL)hadRecord
{
    struct objc_super super_instance = {self,self.superclass};
    ((void (*)(struct objc_super *,SEL,id,id))objc_msgSendSuper)(&super_instance,@selector(setObject:forKey:),obj,info[kIDENTIFIER]);
    objc_setAssociatedObject(obj, &kESCPersistenceCachedObjectInfoKey, info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [ESCPersistenceCacheManager persistCachedObject:info :hadRecord];
}

- (id)objectWithIdentifier:(NSString *)identifier
{
    struct objc_super super_instance = {self,self.superclass};
    id obj = ((id (*)(struct objc_super *,SEL,id))objc_msgSendSuper)(&super_instance,@selector(objectForKey:),identifier);
    
    if (obj) {
        //判断有效期
        NSDictionary *info = objc_getAssociatedObject(obj, &kESCPersistenceCachedObjectInfoKey);
        if ([[info objectForKey:kINVALIDDATE] doubleValue] < [NSDate timeIntervalSinceReferenceDate]) {
            [self removeObjectForKey:identifier];
            [ESCPersistenceCacheManager removeCachedObject:info];
            obj = nil;
        }
    }else{
        obj = [ESCPersistenceCacheManager persistedObjectWithInfo:@{kCACHENAME:self.name,
                                                                    kIDENTIFIER:identifier
                                                                    }];
    }
    return obj;
}
#pragma mark- 重载存取方法
- (void)setObject:(id)obj forKey:(id)key
{
    [self cacheObject:obj withIdentifier:key validTime:NSIntegerMax];
}
- (id)objectForKey:(id)key
{
    return [self objectWithIdentifier:key];
}

#pragma mark-
- (NSDate *)expirationTimeWithCachedIdentifier:(NSString *)identifier
{
    return [NSDate date];
}

#pragma mark-
- (NSData *)escPersistenceData
{
    return nil;
}

+ (instancetype)escInstanceWithPersistenceData:(NSData *)data
{
    return nil;
}
@end

/************************************ ESCPersistenceCacheManager *************************************/

@interface ESCPersistenceCacheManager ()
{
    sqlite3 *_db;
}

@property (nonatomic, strong) NSMapTable *cacheTable;

@property (nonatomic) BOOL persistence;

@end

@implementation ESCPersistenceCacheManager

+ (instancetype)manager
{
    static ESCPersistenceCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ESCPersistenceCacheManager alloc] init];
    });
    return manager;
}

+ (void)addPersistenceCache:(ESCPersistenceCache *)cache
{
    [[self manager] addPersistenceCache:cache];
}

+ (ESCPersistenceCache *)persistenceCacheWithName:(NSString *)name
{
    return [[[self manager] cacheTable] objectForKey:name];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.cacheTable = [NSMapTable strongToStrongObjectsMapTable];
        
        //检查数据库文件是否存在，如果不存在，则需要创建并建立表
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:kDBNAME];
        
        if (sqlite3_open([database_path UTF8String], &_db) != SQLITE_OK) {
            sqlite3_close(_db);
            self.persistence = NO;
        }else{
            self.persistence = YES;
            NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ INTEGER, %@ TEXT)",kDBTABLECACHEDOBJECTINFO,kCACHENAME,kIDENTIFIER,kCREATEDATE,kINVALIDDATE,kOBJECTTYPE];
            [self execSql:sqlCreateTable];
        }
    }
    return self;
}

- (void)dealloc
{
    sqlite3_close(_db);
}

#pragma mark- manage ESCPersistenceCache
- (void)addPersistenceCache:(ESCPersistenceCache *)cache
{
    [self.cacheTable setObject:cache forKey:cache.name];
    
    NSString *cachePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:kPERSISTENCEROOTPATH] stringByAppendingPathComponent:cache.name];
    [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
}

#pragma mark-
+ (void)persistCachedObject:(id)info :(BOOL)flag
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        id obj = [[[[self manager] cacheTable] objectForKey:[info objectForKey:kCACHENAME]] objectWithIdentifier:[info objectForKey:kIDENTIFIER]];
        if (!obj) return;
        
        if ([obj respondsToSelector:@selector(escPersistenceData)]) {
            NSData *data = ((NSData *(*)(id,SEL))objc_msgSend)(obj,@selector(escPersistenceData));
            [data writeToFile:kPERSISTENCEPATH(info[kCACHENAME], MD5(info[kIDENTIFIER])) atomically:YES];
            
            //数据库中记录
            if (flag) return;
            NSArray *result = [[self manager] queryWithCache:info[kCACHENAME]
                                                  identifier:info[kIDENTIFIER]];
            if ([result count]) {
                [[self manager] updateWithCacheInfo:info];
            }else{
                [[self manager] insertWithCacheInfo:info];
            }
        }
    });
    
}
+ (id)persistedObjectWithInfo:(NSDictionary *)info
{
    ESCPersistenceCache *cache = [self persistenceCacheWithName:info[kCACHENAME]];
    info = [[[self manager] queryWithCache:cache.name identifier:info[kIDENTIFIER]] firstObject];
    
    if (!info) return nil;
    
    Class class = NSClassFromString(info[kOBJECTTYPE]);
    if (![class respondsToSelector:@selector(escInstanceWithPersistenceData:)]) return nil;
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:kPERSISTENCEPATH(info[kCACHENAME], MD5(info[kIDENTIFIER]))
                                          options:NSDataReadingMappedIfSafe
                                            error:&error];
    if (error) return nil;
    id instance = ((id (*)(Class,SEL,NSData *))objc_msgSend)(class,@selector(escInstanceWithPersistenceData:), data);
    
    [cache cacheObject:instance withInfo:(NSDictionary *)info :YES];
    return instance;
}
+ (void)removeCachedObject:(NSDictionary *)info
{
    
}
#pragma mark- 发出错误通知

#pragma mark- 数据库操作
-(void)execSql:(NSString *)sql
{
    if (!self.persistence) return;
    
    @synchronized(self){
        char *err;
        if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        }
    }
}
- (void)deleteWithCache:(NSString *)cache
             identifier:(NSString *)identifier
{

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@' AND %@ = '%@'",
                     kDBTABLECACHEDOBJECTINFO,
                     kCACHENAME,cache,
                     kIDENTIFIER,identifier];
    [self execSql:sql];
    //删除文件
    [[NSFileManager defaultManager] removeItemAtPath:kPERSISTENCEPATH(cache, MD5(identifier)) error:nil];
}
- (void)updateWithCacheInfo:(NSDictionary *)info
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE '%@' SET %@ = %@ AND %@ = %@ AND %@ = '%@' WHERE %@ = '%@' AND %@ = '%@'",
                     kDBTABLECACHEDOBJECTINFO,
                     kCREATEDATE,info[kCREATEDATE],
                     kINVALIDDATE,info[kINVALIDDATE],
                     kOBJECTTYPE,info[kOBJECTTYPE],
                     kCACHENAME,info[kCACHENAME],
                     kIDENTIFIER,info[kIDENTIFIER]];
    [self execSql:sql];
}

- (void)insertWithCacheInfo:(NSDictionary *)info
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@' , '%@' , '%@') VALUES ('%@' , '%@' , %@ , %@ , '%@')",
                     kDBTABLECACHEDOBJECTINFO,
                     kCACHENAME,kIDENTIFIER,kCREATEDATE,kINVALIDDATE,kOBJECTTYPE,
                     info[kCACHENAME],info[kIDENTIFIER],info[kCREATEDATE],info[kINVALIDDATE],info[kOBJECTTYPE]];
    [self execSql:sql];
}

- (id)queryWithCache:(NSString *)cache
          identifier:(NSString *)identifier
{
    @synchronized(self){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'",
                         kDBTABLECACHEDOBJECTINFO,
                         kCACHENAME,cache,
                         kIDENTIFIER,identifier];
        
        sqlite3_stmt *stmt;
        
        NSMutableArray *result = [NSMutableArray new];
        if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK){
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char    *cache         = (char*)sqlite3_column_text(stmt, 1);
                char    *identifier    = (char*)sqlite3_column_text(stmt, 2);
                float   create_at     = sqlite3_column_double(stmt, 3);
                float   invalid_date  = sqlite3_column_double(stmt, 4);
                char    *objc_type     = (char*)sqlite3_column_text(stmt, 5);
                
                [result addObject:@{kCACHENAME:[NSString stringWithFormat:@"%s",cache],
                                    kIDENTIFIER:[NSString stringWithFormat:@"%s",identifier],
                                    kCREATEDATE:@(create_at),
                                    kINVALIDDATE:@(invalid_date),
                                    kOBJECTTYPE:[NSString stringWithFormat:@"%s",objc_type]}];
            }
        }else{
            NSLog(@" sql : %@ < empty >",sql);
        }
        return result;
    }
}

@end

static NSString *MD5(NSString *str)
{
    const char *cString = [str UTF8String];
    return [ESCCrypt MD5Encrypt:[NSData dataWithBytes:cString length:strlen(cString)]];
}

/************************************************************************************************************************************/

@implementation NSString (ESCPersistenceCache)

- (NSData *)escPersistenceData
{
    return [NSData dataWithBytes:[self UTF8String] length:self.length];
}

+ (instancetype)escInstanceWithPersistenceData:(NSData *)data
{
    return [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
}
@end

#ifdef UIKIT_EXTERN
@implementation UIImage (ESCPersistenceCache)

- (NSData *)escPersistenceData
{
    return UIImagePNGRepresentation(self);
}

+ (instancetype)escInstanceWithPersistenceData:(NSData *)data
{
    return [UIImage imageWithData:data];
}

@end
#endif

@implementation NSDictionary (ESCPersistenceCache)
- (NSData *)escPersistenceData
{
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

+ (instancetype)escInstanceWithPersistenceData:(NSData *)data
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}
@end

@implementation NSArray (ESCPersistenceCache)

- (NSData *)escPersistenceData
{
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

+ (instancetype)escInstanceWithPersistenceData:(NSData *)data
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

@end