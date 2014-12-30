//
//  ESCAnimation+Private.h
//  ESCDevelopTool
//
//  Created by Cheng WeiWei on 12/22/14.
//
//

#ifndef ESCDevelopTool_ESCAnimation_Private_h
#define ESCDevelopTool_ESCAnimation_Private_h

#import "ESCAnimation.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ESCAnimation ()

- (void)prepareAnimationData;

@property (nonatomic, weak) UIView *view;

@property (nonatomic, strong) CAAnimation *animation;

@property (nonatomic, strong) ESCAnimationCompletionHandler completionhandler;

@end

@interface ESCAnimationJump ()
{
    NSInteger _No;
}

@property (nonatomic, strong) CAKeyframeAnimation *animation;

@property (nonatomic) CGPoint startPoint;

/**
 *  初始跳越高度
 */
@property (nonatomic) CGFloat height;

/**
 *  起跳方向与 x 方向的 角度。0 < angle < pi。默认为 pi/2，即原地跳动
 */
@property (nonatomic) CGFloat angle;

/**
 *  重力加速度
 */
@property (nonatomic) CGFloat gravity;

/**
 *  阻尼系数，0.0〜1.0,默认 1.0,即不衰减
 *  @discusstion 没次跳越高度会衰减
 */
@property (nonatomic) CGFloat damp;

@end

@interface ESCAnimationVibrate ()

/**
 *  频率
 */
@property (nonatomic) CGFloat frequency;

/**
 *  振幅
 */
@property (nonatomic) CGFloat amplitude;

/**
 *  原点
 */
@property (nonatomic) CGPoint basePoint;

/**
 *  方向，如果 basePoint 不是 view.center,则不需要指定方向
 *  @discussion 方向，定义为振动方向与 x 正方向的夹角
 */
@property (nonatomic) CGFloat direction;

@property (nonatomic) CGFloat damp;

@end

#endif
