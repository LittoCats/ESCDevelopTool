//
//  NSString+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#import "NSString+ESC.h"
#import "Foundation+ESC.h"

@implementation NSString (ESC)


- (BOOL)isEmpty
{
    return self.length == 0;
}

- (id)toJSON
{
    NSError *error;
    id JSON = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    return JSON;
}
@end
