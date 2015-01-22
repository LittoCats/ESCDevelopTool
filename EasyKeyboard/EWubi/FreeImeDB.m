//
//  FreeImeDB.m
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/22/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import "FreeImeDB.h"
#import "Hans.h"
#import "FreeWuBi.h"
#import "FreePinYin.h"

@interface FreeImeDB ()

@property (nonatomic, strong) NSFetchRequest *wbRequest;

@end

@implementation FreeImeDB

+ (instancetype)db
{
    static FreeImeDB *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[FreeImeDB alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        db.persistentStoreCoordinator = [db kPersistentStoreCoordinator:nil];
        db.wbRequest = [[NSFetchRequest alloc] initWithEntityName: db.freeWuBi.name];
    });
    return db;
}

- (BOOL)save:(NSError *__autoreleasing *)error
{
    [self performBlock:^{
        NSError *error;
        [super save:&error];
        if (error) NSLog(@"save freeime db error : %@",error);
    }];
    return YES;
}

- (NSPersistentStoreCoordinator *)kPersistentStoreCoordinator:(NSURL *)momdURL
{
    //获取 model 实例
    momdURL = [[NSBundle mainBundle] URLForResource:NSStringFromClass(self.class) withExtension:@"mom"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
    if (!model) return nil;
    NSDictionary *entities = [model entitiesByName];
    self.freeWuBi = entities[@"FreeWuBi"];
    self.hans = entities[@"Hans"];
    self.freePinYin = entities[@"FreePinYin"];
    //建立 NSPersistentStoreCoordinator 实例
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 移动db 到 home dic
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[NSStringFromClass(self.class) stringByAppendingPathExtension:@"db"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *persistentStoreURL = [[NSBundle mainBundle] URLForResource:NSStringFromClass(self.class) withExtension:@"db"];
        [[NSFileManager defaultManager] copyItemAtURL:persistentStoreURL toURL:storeURL error:nil];
    }
    
    NSError *error;
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return storeCoordinator;
}

#pragma mark- db manage
- (NSArray *)hansForKey:(NSString *)key type:(FreeImeDBKeyType)type
{
    NSFetchRequest *request = type == FreeImeDBKeyTypeWubi ? self.wbRequest : nil;
    request.predicate = [NSPredicate predicateWithFormat:@"key == %@",key];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"value.frequency" ascending:NO]];
    
    return [self executeFetchRequest:request error:nil];
}
@end
