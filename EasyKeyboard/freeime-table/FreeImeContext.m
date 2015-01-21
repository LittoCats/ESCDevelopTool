//
//  FreeImeContext.m
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import "FreeImeContext.h"
#import "Key_Value_W.h"
#import "Value_Key_W.h"

@interface FreeImeContext ()

@property (nonatomic, strong) NSEntityDescription *key_value_w;
@property (nonatomic, strong) NSEntityDescription *value_key_w;

@end

@implementation FreeImeContext

+ (instancetype)main
{
    static FreeImeContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[FreeImeContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        context.name = @"FreeImeDB";
//        context.persistentStoreCoordinator = [context kPersistentStoreCoordinator];
    });
    return context;
}

- (Key_Value_W *)wKey:(NSString *)key
{
    if (key.length == 0) {
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.key_value_w.name];
    request.predicate = [NSPredicate predicateWithFormat:@"key == %@" argumentArray:@[key]];
    NSError *error;
    Key_Value_W *kv = [[self executeFetchRequest:request error:&error] firstObject];
    if (!kv) {
        kv = [[Key_Value_W alloc] initWithEntity:self.key_value_w insertIntoManagedObjectContext:self];
        kv.key = key;
    }
    return kv;
}

- (Value_Key_W *)wValue:(NSString *)value key:(NSString *)key
{
    if (value.length == 0 || key.length == 0) {
        return nil;
    }
    value = [value hasPrefix:@"~"] ? [value substringFromIndex:1] : value;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.value_key_w.name];
    request.predicate = [NSPredicate predicateWithFormat:@"value == %@" argumentArray:@[value]];
    NSError *error;
    Value_Key_W *vk = [[self executeFetchRequest:request error:&error] firstObject];
    if (!vk) {
        vk = [[Value_Key_W alloc] initWithEntity:self.value_key_w insertIntoManagedObjectContext:self];
        vk.value = value;
        if (vk.f_key.length == 0 || key.length < vk.f_key.length) vk.f_key = key;
    }
    return vk;
}

- (NSPersistentStoreCoordinator *)kPersistentStoreCoordinator:(NSURL *)momdURL
{
    //获取 model 实例
//    NSURL *momdURL = [[NSBundle mainBundle] URLForResource:self.name withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
    NSDictionary *entities = [model entitiesByName];
    self.key_value_w = entities[NSStringFromClass(Key_Value_W.class)];
    self.value_key_w = entities[NSStringFromClass(Value_Key_W.class)];
    if (!model) return nil;
    //建立 NSPersistentStoreCoordinator 实例
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //设置持久化对像(sqlite)
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"ESCCoreData.persistentStore"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[storeURL path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSError *error;
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[storeURL URLByAppendingPathComponent:self.name] URLByAppendingPathExtension:@"sqlite"] options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return storeCoordinator;
}

@end
