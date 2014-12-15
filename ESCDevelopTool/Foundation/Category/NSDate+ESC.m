//
//  NSDate+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#import "NSDate+ESC.h"

@implementation NSDate (ESC)

+ (instancetype)dataWithScript:(NSString *)script format:(NSString *)dateFormat
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:dateFormat];
    
    return [formater dateFromString:script];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:dateFormat];
    
    return [formater stringFromDate:self];
}

@end
