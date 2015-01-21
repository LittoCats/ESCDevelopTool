//
//  Key_Value_W.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Key_Value_W : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSSet *value;
@end

@interface Key_Value_W (CoreDataGeneratedAccessors)

- (void)addValueObject:(NSManagedObject *)value;
- (void)removeValueObject:(NSManagedObject *)value;
- (void)addValue:(NSSet *)values;
- (void)removeValue:(NSSet *)values;

@end
