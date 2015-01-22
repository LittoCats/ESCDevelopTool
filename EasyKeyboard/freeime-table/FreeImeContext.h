//
//  FreeImeContext.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface FreeImeContext : NSManagedObjectContext

@property (nonatomic, readonly) NSEntityDescription *freeWuBi;
@property (nonatomic, readonly) NSEntityDescription *freePinYin;
@property (nonatomic, readonly) NSEntityDescription *hans;

+(instancetype)main;
- (NSPersistentStoreCoordinator *)kPersistentStoreCoordinator:(NSURL *)momdURL;

@end
