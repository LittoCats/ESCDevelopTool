//
//  FreeImeContext.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Key_Value_W;
@class Value_Key_W;

@interface FreeImeContext : NSManagedObjectContext

@property (nonatomic, readonly) NSEntityDescription *key_value_w;
@property (nonatomic, readonly) NSEntityDescription *value_key_w;

+(instancetype)main;
- (NSPersistentStoreCoordinator *)kPersistentStoreCoordinator:(NSURL *)momdURL;

- (Key_Value_W *)wKey:(NSString *)key;
- (Value_Key_W *)wValue:(NSString *)value key:(NSString *)key;

@end
