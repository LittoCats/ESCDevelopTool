//
//  ECSCoreData.m
//  ECS Develop
//
//  Created by 程巍巍 on 10/9/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//


#import "ESCCoreData+Private.h"

#pragma mark-
#pragma mark-

@implementation ESCCoreData

+ (instancetype)contextNamed:(NSString *)name
{
    NSThread *currentThread = [NSThread currentThread];
    if ([currentThread isMainThread]) {
        return [ESCCoreDataMain contextNamed:name];
    }else{
        static NSMapTable *subContextTable = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            subContextTable = [NSMapTable strongToWeakObjectsMapTable];
        });
        @synchronized(subContextTable){
            NSString *pname = kCUMOC_NAME(name, currentThread);
            ESCCoreData *context = [subContextTable objectForKey:pname];
            if (!context) {
                context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                context.parentContext = [ESCCoreData contextNamed:name];
                [subContextTable setObject:context forKey:pname];
            }
            return context;
        }
    }
}

- (NSManagedObject *)insertObjectToEntity:(NSString *)entityName
{
    NSError *error;
    NSEntityDescription *entity = [[[[self persistentStoreCoordinator] managedObjectModel] entitiesByName] objectForKey:entityName];
    if (!entity) error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"ESCCoreData entity with name < %@ > is not found",entityName] code:9 userInfo:nil];
    
#ifdef DEBUG
    NSLog(@"ESCCoreData %@",error);
#endif
    
    __block NSManagedObject *mobj;
    if (!error) {
        [self excuteBlock:^{
            mobj = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self];
        }];
    }
    
    return mobj;
}

- (NSArray *)fetchObjectInEntity:(NSString *)entityName
                       withLimit:(NSInteger)limit
                          offset:(NSInteger)offset
                            sort:(NSArray *(^)())sortDescriptors
                       predicate:(NSPredicate *(^)(NSDictionary *))predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.predicate = predicate ? predicate([[[[[self persistentStoreCoordinator] managedObjectModel] entitiesByName] objectForKey:entityName] propertiesByName]) : nil;
    request.fetchLimit = limit;
    request.fetchOffset = offset;
    request.sortDescriptors = sortDescriptors ? sortDescriptors() : nil;
    
    request.shouldRefreshRefetchedObjects = NO;
    
    __block NSError *error;
    __block NSArray *mos;
    [self excuteBlock:^{
        mos = [self executeFetchRequest:request error:&error];
    }];
    return mos;
}

-(BOOL)save:(NSError *__autoreleasing *)error
{
    __block BOOL success;
    [self excuteBlock:^{
        success = [super save:error];
    }];
    
    if (success && !error) {
        success = [self.parentContext save:error];
    }
    return success;
}
@end

