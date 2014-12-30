//
//  UIView+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_UIView_ESC
#define ESCDevelopTool_UIView_ESC

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ESCToastPosition) {
    ESCToastPositionTop      =   0xF000,
    ESCToastPositionBottom   =   0x0F00,
    ESCToastPositionLeft     =   0x00F0,
    ESCToastPositionRight    =   0x000F
};

UIKIT_EXTERN ESCToastPosition ESCToastPositionCenter;
UIKIT_EXTERN ESCToastPosition ESCToastPositionBottomCenter;

typedef NS_ENUM(NSUInteger, ESCIndicatorStyle) {
    ESCIndicatorStyleDefault,           // indicator size {66.0, 66.0}
    ESCIndicatorStyleSmall,             // indicator size {44.0, 44.0}
    ESCIndicatorStyleSizeToFit,         // indicator size {self.width/6,self.width/6} / {self.height/6,self.height/6} ,但最不会超过 {66.0,66.0}
};

/**
 *  元向量，{0.0,0.0} -> {ver, hor}
 *  ver hor 大于 0.0，小于 1.0
 */
typedef struct {
    CGFloat ver;
    CGFloat hor;
}ESCMetaVector;

@interface UIView (ESC)

/**
 *  放弃第一响应
 *  boolean 是否为 firstResponder 的标志
 *  @return 找到 firstResponder 并 resign 成功，则返回 YES
 */
- (BOOL)resignFirstResponder:(BOOL *)isFirstResponder;

/**
 *  setFrame 
 *  @discussion 默认实现，当 x/y/width/height 的变化量均小于 0.1 时,返回 NO. 直接调用 removefromesuperview 移除
 */
- (BOOL)shoudUpdateFrameTo:(CGRect)frame;
/**
 *  默认实现调用了 [self setNeedLayout]
 */
- (void)frameDidChanged;

/**
 *  当 superview 的 frame 发生变化时。默认实现会么都没做
 */
- (void)superviewFrameDidChanged;

/**
 *  给 view 添加 overlay, overlay 永远处于 subviews 的前面（不会被遮盖），但是 overlay 之间的顺序不确定，（orign.x+orign.y 最大者在最前面）
 */
- (void)addOverlay:(UIView *)overlay;

/**
 *  makeToast
 *  如果上一条 toast 尚未消失，则覆盖上一条 toast 的 message / interval，即 toast 的内容及消失时间以最后一次调用为准,如果一条 message 中的一行太长，可能会超出 toast 的显示范围，请在适当的位置换行
 *  @discussion 建议 message 单行长度不超过 32 个英文字符，不超过 4 行
 */
- (void)makeToast:(NSString *)message
         position:(ESCToastPosition)position
         interval:(NSTimeInterval)interval;

/**
 *  在 view 上显示一个 activityIndicator
 *  @message    如果存在，将显示在 indicator 下面。多次调用时，显示最后一次的值，隐藏时，向前遍历
 *  @position   indicator 的位置 Top | Left | Right 将显示在上居中的位置，依此类推
 *  @style      indicator 的大小，多次调用时，以第一次为准
 *  @interval   持续时间，如果 <= 0.0 ，将不直显示，直到调用 hide 方法
 
 *  @discussion 当多次调用时，需调用 hide 方法的次应与  interval <= 0.0 的调用次数相同； interval > 0.0 的多次调用，hide 时间以最晚的结束时间为准，不一定是 inteval 中的最大值。连续调用，位置保持不变
 */
- (void)showIndicator:(NSString *)message
                style:(ESCIndicatorStyle)style
             interval:(NSTimeInterval)interval;

/**
 *  隐藏 indicator  
 *  @isAll 是否强制隐藏所有的 indicator
 */
- (void)hideIndicator:(BOOL)isAll;

/**
 *  设置渐变色背景
 *  @backgroundColors 颜色数组，至少包含两种以上颜色值，只有一种，则直接设为背景色
 *  @direction  渐变方向。
 */
- (void)setBackgroundColors:(NSArray *)backgroundColors withDirection:(CGFloat)direction;

+ (void)enableGradientBackgroundColor:(BOOL)enable;
+ (BOOL)isGradientBackgroundColorEnable;


- (UIImage *)snap;
@end

#endif