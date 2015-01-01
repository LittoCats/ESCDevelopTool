//
//  ESCInternationalManager.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/20/14.
//  Copyright (c) 12/19/14 Littocats. All rights reserved.
//

#import "ESCInternationalManager.h"

NSString *ESCUpdateInternationalInfomationNotification = @"ESCUpdateInternationalInfomationNotification";

@implementation ESCInternationalManager

+ (NSString *)internationalString:(NSString *)international withComment:(NSString *)comment
{
    if (!international) return comment;
    
    return nil;
}

+ (void)registeDelegate:(id<ESCInternationalManagerDelegate>)delegate
{
    
}

@end
