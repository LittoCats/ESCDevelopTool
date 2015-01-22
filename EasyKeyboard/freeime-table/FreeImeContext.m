//
//  FreeImeContext.m
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import "FreeImeContext.h"
#import "FreeWuBi.h"
#import "FreePinYin.h"
#import "Hans.h"

@interface FreeImeContext ()

@property (nonatomic, strong) NSEntityDescription *freeWuBi;
@property (nonatomic, strong) NSEntityDescription *freePinYin;
@property (nonatomic, strong) NSEntityDescription *hans;

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



- (NSPersistentStoreCoordinator *)kPersistentStoreCoordinator:(NSURL *)momdURL
{
    //获取 model 实例
//    NSURL *momdURL = [[NSBundle mainBundle] URLForResource:self.name withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
    NSDictionary *entities = [model entitiesByName];
    self.freeWuBi = entities[@"FreeWuBi"];
    self.hans = entities[@"Hans"];
    self.freePinYin = entities[@"FreePinYin"];
    if (!model) return nil;
    //建立 NSPersistentStoreCoordinator 实例
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //设置持久化对像(sqlite)
//    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"ESCCoreData.persistentStore"];
    NSURL *storeURL = [NSURL fileURLWithPath:@"/Volumes/Littocat-GR/DB"];
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
