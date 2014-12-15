//
//  NSDictionary+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#import "NSDictionary+ESC.h"

@implementation NSDictionary (ESC)

- (NSString *)toString
{
    NSError *error;
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:&error] encoding:NSUTF8StringEncoding];
}

@end
