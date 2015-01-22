//
//  FreePinYin.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/22/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hans;

@interface FreePinYin : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSSet *value;
@end

@interface FreePinYin (CoreDataGeneratedAccessors)

- (void)addValueObject:(Hans *)value;
- (void)removeValueObject:(Hans *)value;
- (void)addValue:(NSSet *)values;
- (void)removeValue:(NSSet *)values;

@end
