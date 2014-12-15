//
//  NSTimer+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#import "NSTimer+ESC.h"

#import <objc/runtime.h>

@implementation NSTimer (ESC)

static const char *____scheduledTimerBlockHandler;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo
                                    handler:(void (^)(NSTimer *))handler
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(____scheduledTimerBlockHandler:) userInfo:userInfo repeats:yesOrNo];
    objc_setAssociatedObject(self, &____scheduledTimerBlockHandler, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return timer;
}

+ (void)____scheduledTimerBlockHandler:(NSTimer *)timer
{
    void (^handler)(NSTimer *) = objc_getAssociatedObject(self, &____scheduledTimerBlockHandler);
    if (handler) handler(timer);
}

@end
