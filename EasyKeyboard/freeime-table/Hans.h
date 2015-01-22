//
//  Hans.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/22/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FreeWuBi;

@interface Hans : NSManagedObject

@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSSet *key_wb;
@property (nonatomic, retain) NSManagedObject *key_py;
@end

@interface Hans (CoreDataGeneratedAccessors)

- (void)addKey_wbObject:(FreeWuBi *)value;
- (void)removeKey_wbObject:(FreeWuBi *)value;
- (void)addKey_wb:(NSSet *)values;
- (void)removeKey_wb:(NSSet *)values;

@end
