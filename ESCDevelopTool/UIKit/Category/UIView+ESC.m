//
//  UIView+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#import "UIView+ESC.h"
#import "UIView+ESC_Private.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImage+ESC.h"

#define kMINDIFFERENCE 0.1

@implementation UIView (ESC)

#pragma mark- activity

- (void)showIndicator:(NSString *)message
                style:(ESCIndicatorStyle)style
             interval:(NSTimeInterval)interval
{
    __ESCIndicatorView *indicator = objc_getAssociatedObject(self, &kESCViewIndicatorKey);
    if (!indicator){
        indicator = [[__ESCIndicatorView alloc] init];
        [indicator setOwner:self];
    }
    [indicator setMessage:message style:style interval:interval];
}

- (void)hideIndicator:(BOOL)isAll
{
    __ESCIndicatorView *indicator = objc_getAssociatedObject(self, &kESCViewIndicatorKey);
    [indicator hide:isAll];
}

- (void)makeToast:(NSString *)message position:(ESCToastPosition)position interval:(NSTimeInterval)interval
{
    __ESCToastView *toast = objc_getAssociatedObject(self, &kESCViewToastKey);
    if (!toast) {
        toast = [[__ESCToastView alloc] init];
        [toast setOwner:self];
    }
    toast.timeInterval = interval;
    toast.position = position ? position : ESCToastPositionBottomCenter;
    toast.text = message;
}

#pragma mark- overlay
- (void)addOverlay:(UIView *)overlay
{
    [self.overlays addPointer:(__bridge void *)(overlay)];
    [self addSubview:overlay];
}

#pragma mark- firstResponder
- (BOOL)resignFirstResponder:(BOOL *)isFirstResponder
{
    if ([self isFirstResponder]) {
        *isFirstResponder = YES;
        return [self resignFirstResponder];
    }else *isFirstResponder = NO;
    
    BOOL boolean = NO;
    BOOL isSuccess = NO;
    for (UIView *subview in self.subviews) {
        if ([subview isFirstResponder]) return [subview resignFirstResponder];
        else{
            isSuccess = [subview resignFirstResponder:&boolean];
            if (isSuccess) return YES;
            if (boolean) return NO;
        }
    }
    return NO;
}


#pragma frame
- (BOOL)shoudUpdateFrameTo:(CGRect)frame
{
    return fabsf(self.frame.origin.x-frame.origin.x) > kMINDIFFERENCE || fabsf(self.frame.origin.y-frame.origin.y) > kMINDIFFERENCE || fabsf(self.frame.size.width-frame.size.width) > kMINDIFFERENCE || fabsf(self.frame.size.height-frame.size.height) > kMINDIFFERENCE;
}

- (void)frameDidChanged
{
    if (kESCGradientBackgroundColorEnable) self.backgroundColor = self.backgroundColor;
    [self setNeedsLayout];
}

- (void)superviewFrameDidChanged
{
    
}

static const char *kESCGradientBackgroundColors;
static const char *kESCGradientBackgroundColorDirection;
static bool kESCGradientBackgroundColorEnable;
- (void)setBackgroundColors:(NSArray *)backgroundColors withDirection:(CGFloat)direction
{
    if (!kESCGradientBackgroundColorEnable || !backgroundColors || backgroundColors.count < 2) return;
    
    objc_setAssociatedObject(self, &kESCGradientBackgroundColors, backgroundColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kESCGradientBackgroundColorDirection, [NSNumber numberWithFloat:direction], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.backgroundColor = self.backgroundColor;
}

+ (void)enableGradientBackgroundColor:(BOOL)enable
{
    kESCGradientBackgroundColorEnable = enable;
}
+ (BOOL)isGradientBackgroundColorEnable
{
    return kESCGradientBackgroundColorEnable;
}
@end


@implementation UIView (ESC_Private)

@dynamic overlays;
- (NSPointerArray *)overlays
{
    NSPointerArray *table = objc_getAssociatedObject(self, &kESCViewOverlaysKey);
    if (!table){
        table = [NSPointerArray weakObjectsPointerArray];
        objc_setAssociatedObject(self, &kESCViewOverlaysKey, table, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return table;
}

#pragma mark-
+ (void)load
{
    __ESCExchangeMethodImplementation(self, @selector(setFrame:), NO, @selector(____ESCCustomSetFrame:), NO);
    __ESCExchangeMethodImplementation(self, @selector(addSubview:), NO, @selector(____ESCCustomAddSubview:), NO);
    __ESCExchangeMethodImplementation(self, @selector(subviews), NO, @selector(____ESCCustomSubviews), NO);
    __ESCExchangeMethodImplementation(self, @selector(backgroundColor), NO, @selector(____backgroundColor), NO);
    __ESCExchangeMethodImplementation(self, @selector(initWithFrame:), NO, @selector(____initWithFrame:), NO);
#ifdef DEBUG
    NSLog(@"UIView (subclass) has been changed property 'exclusiveTouch' default value to YES");
#endif
}

#pragma mark- custom's override
- (void)awakeFromNib
{
    self.exclusiveTouch = YES;
}

- (id)____initWithFrame:(CGRect)frame
{
    self = [self ____initWithFrame:frame];
    self.exclusiveTouch = YES;
    return self;
}

- (void)____ESCCustomSetFrame:(CGRect)frame
{
    if (![self shoudUpdateFrameTo:frame]){
        return;
    }
    [self ____ESCCustomSetFrame:frame];
    [self frameDidChanged];
    
    NSArray *subviews = [self ____ESCCustomSubviews];
    for (UIView *subview in subviews) {
        [subview superviewFrameDidChanged];
    }
}

- (void)____ESCCustomAddSubview:(UIView *)view
{
    [self ____ESCCustomAddSubview:view];
    [self.overlays compact];
    NSArray *overlays = [self.overlays allObjects];
    for (UIView *overlay in overlays) {
        [self bringSubviewToFront:overlay];
    }
}

- (NSArray *)____ESCCustomSubviews
{
    NSMutableArray *subviews = [[self ____ESCCustomSubviews] mutableCopy];
    NSArray *overlays = [self.overlays allObjects];
    for (UIView *overlay in overlays) {
        [subviews removeObject:overlay];
    }
    return [NSArray arrayWithArray:subviews];
}

- (UIColor *)____backgroundColor
{
    NSArray *colors = objc_getAssociatedObject(self, &kESCGradientBackgroundColors);
    if (!colors) return [self ____backgroundColor];
    CGFloat direction = [objc_getAssociatedObject(self, &kESCGradientBackgroundColorDirection) floatValue];
    return [UIColor colorWithPatternImage:[UIImage imageWithSize:self.frame.size colors:colors gradientDirection:direction]];
}

@end

//ESCToastPosition ESCToastPositionCenter = ESCActivityPositionLeft | ESCActivityPositionRight | ESCActivityPositionTop | ESCActivityPositionBottom;
ESCToastPosition ESCToastPositionCenter = 0xFFFF;

//ESCToastPosition ESCToastPositionBottomCenter = ESCActivityPositionBottom | ESCActivityPositionLeft | ESCActivityPositionRight;
ESCToastPosition ESCToastPositionBottomCenter = 0x0FFF;
