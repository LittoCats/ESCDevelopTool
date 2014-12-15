//
//  ESCPersistenceCache.h
//  ESCDevelopKit
//
//  Created by 程巍巍 on 10/29/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ESCDevelopKit_ESCPersistenceCache_h
#define ESCDevelopKit_ESCPersistenceCache_h

/**
 *  持久化缓存策略
 *  加入 Cache 的数据，将在后台写入磁盘。过期的内容会在下次调用、缓存紧张及系统空闲等
 可能的时机被清空，以释放磁盘空间。
 缓存的根目录为 NSTempDirectory()/org.littocats.esctoolset/
 */
@interface ESCPersistenceCache : NSCache

/**
 *  持入化缓存的标识符
 */
@property (nonatomic, copy) NSString *presistenceIdentifier;

/**
 *  获取缓存实例
 创建时，已经被系统 retain，在内存紧张时，被 release （只会被release一次，如果其它地方进行了强引用，
 则实例依然存在，下次调用初始化方法时，将直接反回已存在的实例）。
 */
+ (instancetype)persistenceCacheWithName:(NSString *)name;

/**
 *  获取缓存内容的到期时间
 */
- (NSDate *)expirationTimeWithCachedIdentifier:(NSString *)indentifier;

/**
 *  数据加入缓存
 *  identifier 将被 copy
 *  [cacheInstance setObject:forKey:] [cacheInstance objectForKey:] 方法被重定向，默认 validTime
 为 CGFLOAT_MAX
 */
- (void)cacheObject:(id)obj
     withIdentifier:(NSString *)identifier
          validTime:(NSTimeInterval)validTime;

- (id)objectWithIdentifier:(NSString *)identifier;

/**
 *  错误码
 */
#define ESCPERSISTENCECACHEINITERROR    @"ESCPERSISTENCECACHEINITERROR"
#define ESCPERSISTENCECACHESTOREERROR   @"ESCPERSISTENCECACHESTOREERROR"
@end

#endif

