//
//  NSObject+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_NSObject_ESC
#define ESCDevelopTool_NSObject_ESC

#import <Foundation/Foundation.h>

@interface NSObject (ESC)

@property (nonatomic, readonly) NSString *uniqueId;

- (id)objectWithId:(NSString *)uniqueId;

- (BOOL)isEmpty;

+ (NSCache *)cache;

@end

#endif