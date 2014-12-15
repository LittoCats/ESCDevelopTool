//
//  NSTimer+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_NSTimer_ESC
#define ESCDevelopTool_NSTimer_ESC

#import <Foundation/Foundation.h>

@interface NSTimer (ESC)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo
                                    handler:(void (^)(NSTimer *timer))handler;


@end

#endif