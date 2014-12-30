//
//  ESCAnimation.h
//  ESCDevelopTool
//
//  Created by Cheng WeiWei on 12/22/14.
//
//

#import <UIKit/UIKit.h>

@class ESCAnimation;
typedef void (^ESCAnimationCompletionHandler)(ESCAnimation *animation);

@interface ESCAnimationGroup : NSObject

@end

@interface ESCAnimation : NSObject

@property (nonatomic) BOOL repeat;

- (void)commitWithView:(UIView *)view completionHandler:(ESCAnimationCompletionHandler)handler;

@end

@interface ESCAnimationJump : ESCAnimation

/**
 *  初始跳越高度
 */
@property (nonatomic,readonly) CGFloat height;

/**
 *  起跳方向与 x 正方向的 角度。0 < angle < pi。默认为 pi/2，即原地跳动
 */
@property (nonatomic,readonly) CGFloat angle;

/**
 *  重力加速度
 */
@property (nonatomic,readonly) CGFloat gravity;

/**
 *  阻尼系数，0.0〜1.0,默认 1.0,即不衰减
 *  @discusstion 没次跳越高度会衰减
 */
@property (nonatomic,readonly) CGFloat damp;

+ (instancetype)jumpWithHeigh:(CGFloat)height angle:(CGFloat)angle gravity:(CGFloat)gravity damp:(CGFloat)damp;
@end

@interface ESCAnimationVibrate : ESCAnimation

/**
 *  弹性系数
 */
@property (nonatomic,readonly) CGFloat frequency;

/**
 *  振幅
 */
@property (nonatomic,readonly) CGFloat amplitude;

/**
 *  原点
 */
@property (nonatomic,readonly) CGPoint basePoint;

/**
 *  方向，如果 basePoint 不是 view.center,则不需要指定方向
 *  @discussion 方向，定义为振动方向与 x 正方向的夹角
 */
@property (nonatomic,readonly) CGFloat direction;

/**
 *  阻尼系数，0.0〜1.0,默认 1.0,即不衰减
 *  @discusstion 没次跳越高度会衰减
 */
@property (nonatomic,readonly) CGFloat damp;


+ (instancetype)vibrateWithFrequency:(CGFloat)frequency
                           amplitude:(CGFloat)amplitude
                           basePoint:(CGPoint)basePoint
                           direction:(CGFloat)direction
                                damp:(CGFloat)damp;
@end