//
//  Value_Key_W.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Key_Value_W;

@interface Value_Key_W : NSManagedObject

@property (nonatomic, retain) NSString * f_key;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSSet *key;
@end

@interface Value_Key_W (CoreDataGeneratedAccessors)

- (void)addKeyObject:(Key_Value_W *)value;
- (void)removeKeyObject:(Key_Value_W *)value;
- (void)addKey:(NSSet *)values;
- (void)removeKey:(NSSet *)values;

@end
