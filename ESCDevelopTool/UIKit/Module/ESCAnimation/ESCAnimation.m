//
//  ESCAnimation.m
//  ESCDevelopTool
//
//  Created by Cheng WeiWei on 12/22/14.
//
//

#import "ESCAnimation+Private.h"
#import <objc/runtime.h>
#import <math.h>

@implementation ESCAnimationGroup

@end

@implementation ESCAnimation

- (void)commitWithView:(UIView *)view completionHandler:(ESCAnimationCompletionHandler)handler
{
    self.view = view;
    self.completionhandler = handler;
    objc_setAssociatedObject(view, (__bridge const void *)(ESCAnimation.class), self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self prepareAnimationData];
}

- (void)prepareAnimationData
{
    
}

#pragma mark- delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.repeat) {
        [self commitWithView:self.view completionHandler:self.completionhandler];
    }else{
        objc_setAssociatedObject(self.view, (__bridge const void *)(ESCAnimation.class), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (self.completionhandler) {
            self.completionhandler(self);
        }
    }
}

@end

@implementation ESCAnimationJump

+ (instancetype)jumpWithHeigh:(CGFloat)height angle:(CGFloat)angle gravity:(CGFloat)gravity damp:(CGFloat)damp
{
    ESCAnimationJump *jump = [[ESCAnimationJump alloc] init];
    jump.height = -height;
    jump.angle = angle;
    jump.gravity = gravity;
    jump.damp = damp;
    
    return jump;
}

- (id)init
{
    if (self = [super init]) {
        self.animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        self.repeat = YES;
        self.animation.delegate = self;
    }
    return self;
}

- (void)commitWithView:(UIView *)view completionHandler:(ESCAnimationCompletionHandler)handler
{
    [super commitWithView:view completionHandler:handler];
    [view.layer addAnimation:self.animation forKey:@"position"];
}

- (void)prepareAnimationData
{
    self.startPoint = self.view.center;
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform transform = self.view.transform;
    CGPathMoveToPoint(path, &transform, self.startPoint.x, self.startPoint.y);
    
    NSTimeInterval interval = sqrtf(fabsf(2*self.height/self.gravity));
    CGFloat speedX = interval*self.gravity/tanf(self.angle);
    
    CGPathAddCurveToPoint(path, &transform,
                          self.startPoint.x, self.startPoint.y + self.height,
                          self.startPoint.x + speedX * interval /2, self.startPoint.y + self.height,
                          self.startPoint.x + speedX * interval, self.startPoint.y);
    
    self.animation.duration = interval;
    CGPathRelease(self.animation.path);
    self.animation.path = path;
    
    self.height *= 1-self.damp;
    
    self.repeat = fabsf(self.height) > 2.0 && self.repeat;
    self.view.center = CGPointMake(self.startPoint.x + speedX * interval, self.startPoint.y);
}
@end

#pragma mark- vibrate

@implementation ESCAnimationVibrate

+ (instancetype)vibrateWithFrequency:(CGFloat)frequency
                            amplitude:(CGFloat)amplitude
                            basePoint:(CGPoint)basePoint
                            direction:(CGFloat)direction
                                 damp:(CGFloat)damp
{
    ESCAnimationVibrate *vibrate = [ESCAnimationVibrate new];
    vibrate.frequency = frequency;
    vibrate.amplitude = amplitude;
    vibrate.basePoint = basePoint;
    vibrate.direction = direction;
    vibrate.damp = damp;
    
    return vibrate;
}

- (id)init
{
    if (self = [super init]) {
        self.animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        self.repeat = YES;
        self.animation.delegate = self;
    }
    return self;
}

- (void)commitWithView:(UIView *)view completionHandler:(ESCAnimationCompletionHandler)handler
{
    [super commitWithView:view completionHandler:handler];
    [view.layer addAnimation:self.animation forKey:@"position"];
}

- (void)prepareAnimationData
{
    
}

@end