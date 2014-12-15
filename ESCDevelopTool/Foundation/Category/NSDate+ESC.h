//
//  NSDate+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_NSDate_ESC
#define ESCDevelopTool_NSDate_ESC

#import <Foundation/Foundation.h>

@interface NSDate (ESC)

+ (instancetype)dataWithScript:(NSString *)script format:(NSString *)dateFormat;

- (NSString *)stringWithFormat:(NSString *)dateFormat;

@end

#endif