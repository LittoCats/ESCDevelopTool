//
//  FreeWuBi.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/22/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hans;

@interface FreeWuBi : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) Hans *value;

@end
