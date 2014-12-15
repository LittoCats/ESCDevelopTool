//
//  UIImage+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/8/14.
//	Copyright (c) 12/8/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_UIImage_ESC
#define ESCDevelopTool_UIImage_ESC

#import <UIKit/UIKit.h>

@interface UIImage (ESC)

+ (UIImage *)imageWithSingleColor:(UIColor *)color;

/**
 *  生成颜色渐变的图像
 *  @colors
 *  @vector 渐变方向 {0,0} -> vector
 */
+ (UIImage *)imageWithSize:(CGSize)size colors:(NSArray *)colors gradientDirection:(CGFloat)direction;

@end

#endif