//
//  ESCCoreData+Private.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/14/14.
//	Copyright (c) 12/14/14 Littocats. All rights reserved.
//

#import "ESCCoreData+Private.h"

@implementation ESCCoreData (Private)

+ (instancetype)ancestContextWithName:(NSString *)name
{
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable strongToStrongObjectsMapTable];
    });
    @synchronized(table){
        NSString *pname = kMAMOC_NAME(name);
        ESCCoreData *ancestContext = [table objectForKey:pname];
        if (!ancestContext) {
            ancestContext = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            ancestContext.name = name;
            ancestContext.persistentStoreCoordinator = [ancestContext __kPersistentStoreCoordinator];
            [table setObject:ancestContext forKey:pname];
        }
        return ancestContext;
    }
}

- (void)excuteBlock:(void (^)())block
{
    [self performBlockAndWait:block];
}

#pragma mark- 私有方法，管理 NSPersistentStoreCoordinator
//程序运行过程中，一个model对应的 NSPersistentStoreCoordinator 有且仅有一个
//因为背景 context 是其它 context 的父 context 或祖先 context ,所以该方法只会被调用一次（同一个 momd）
- (NSPersistentStoreCoordinator *)__kPersistentStoreCoordinator
{
    //获取 model 实例
    NSURL *momdURL = [[NSBundle mainBundle] URLForResource:self.name withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
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
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return storeCoordinator;
}

@end

@implementation ESCCoreDataMain

+ (instancetype)contextNamed:(NSString *)name
{
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable strongToStrongObjectsMapTable];
    });
    @synchronized(table){
        NSString *pname = kMAMOC_NAME(name);
        ESCCoreDataMain *mainContext = [table objectForKey:pname];
        if (!mainContext) {
            mainContext = [[self alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
            mainContext.name = name;
            mainContext.parentContext = [self ancestContextWithName:name];
            [table setObject:mainContext forKey:pname];
        }
        return mainContext;
    }
}

- (void)excuteBlock:(void (^)())block
{
    block();
}
@end

#pragma mark-
#pragma mark-
NSPredicate *__kESCPredicateCreate(NSString *description, NSDictionary *variableBindings)
{
    if (!description || !description.length) return nil;
    NSMutableArray *arguments = [NSMutableArray new];
    
    NSRange expressionRange = [description rangeOfString:@"#\\{.*?\\}" options:NSRegularExpressionSearch range:NSMakeRange(0, description.length)];
    while (expressionRange.location != NSNotFound) {
        //获取 需要对比的值
        NSString *expression = [description substringWithRange:expressionRange];
        expression = [expression substringWithRange:NSMakeRange(2, expressionRange.length-3)];
        id value = [variableBindings valueForKeyPath:expression];
        
        // 变换 description
        description = [description stringByReplacingCharactersInRange:expressionRange withString:@"%@"];
        [arguments addObject:value];
        
        expressionRange = [description rangeOfString:@"#\\{.*?\\}" options:NSRegularExpressionSearch range:NSMakeRange(expressionRange.location, description.length-expressionRange.location)];
    }
    return [NSPredicate predicateWithFormat:description argumentArray:arguments];
}

NSDictionary *__kESCNSDictionaryOfVariableBindings(NSString *start, ...)
{
    NSArray *variableName = [start componentsSeparatedByString:@","];
    NSInteger index = 0;
    
    NSMutableDictionary *variableBindings = [NSMutableDictionary new];
    
    va_list vlist;
    va_start(vlist, start);
    id arg = va_arg(vlist, id);
    while (arg && index < [variableName count]) {
        [variableBindings setObject:arg forKey:[variableName objectAtIndex:index]];
        arg = va_arg(vlist, id);
        index ++;
    }
    return [NSDictionary dictionaryWithDictionary:variableBindings];
}

const NSString *ESCMOCSaveErrorNotification = @"ESCMOCSaveErrorNotification";