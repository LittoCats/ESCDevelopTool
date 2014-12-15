//
//  UIControl+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/1/14.
//	Copyright (c) 12/1/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_UIControl_ESC
#define ESCDevelopTool_UIControl_ESC

#import <UIKit/UIKit.h>

@interface UIControl (ESC)

/**
 *  为 events 添加 block 事件
 *  block 将被 copy
 *  @discussion if block is nil , events handler will be removed if exist
 */
- (void)handleControlEvents:(UIControlEvents)events withBlock:(void(^)(id sender/* UIControl or subClass*/, UIControlEvents event))block;

@end

#endif