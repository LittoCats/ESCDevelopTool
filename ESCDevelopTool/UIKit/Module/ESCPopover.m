//
//  ESCPopover.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import <UIKit/UIKit.h>
#import "ESCPopover.h"

const CGFloat kArrowSize = 12.f;

const CGFloat kCornerRadius = 8.0f;
const CGFloat kArrowSizeRate = 1;

const NSString *ESCPopoverTintcolorKey = @"tintcolor";

typedef enum {
    
    ESCPopoverArrowDirectionNone,
    ESCPopoverArrowDirectionUp,
    ESCPopoverArrowDirectionDown,
    ESCPopoverArrowDirectionLeft,
    ESCPopoverArrowDirectionRight,
    
} ESCPopoverArrowDirection;

@interface ESCPopoverView : UIView

@property (nonatomic) CGPoint *points;

@end

@interface ESCPopover ()
{
    ESCPopoverArrowDirection    _arrowDirection;
    CGFloat                     _arrowPosition;
    UIScrollView                *_scrollView;
    ESCPopoverView              *_popoverView;
}

@property (nonatomic, copy) UIColor *tintColor;

@property (nonatomic) CGRect locateRect;

@property (nonatomic) BOOL  animated;

@end

@implementation ESCPopover

- (void)presentFromRect:(CGRect)rect
                 inView:(UIView *)view
                options:(NSDictionary *)options
{
    self.locateRect = rect;
    self.frame = view.bounds;
    
    UIColor *tintColor = [options objectForKey:ESCPopoverTintcolorKey];
    self.tintColor = tintColor ? tintColor : [UIColor blackColor];
    [view addSubview:self];
    
    [self setupFrameInView:view fromRect:rect];
    
    CGRect frame = _popoverView.frame;
    CGRect sFrame = _scrollView.frame;
    _popoverView.frame = (CGRect){[_popoverView convertPoint:_popoverView.points[0] toView:self],CGSizeZero};
    _scrollView.frame = CGRectZero;
    [UIView animateWithDuration:0.3 animations:^{
        _popoverView.frame = frame;
        _scrollView.frame = sFrame;
    }];
}

#pragma mark- init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.alpha = 1;
        
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.layer.cornerRadius = kCornerRadius;
        
        _popoverView = [[ESCPopoverView alloc] initWithFrame:CGRectZero];
        _popoverView.clipsToBounds = YES;
        _popoverView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_popoverView];
        [_popoverView addSubview:_scrollView];
        
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    _scrollView.backgroundColor = tintColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        _popoverView.frame = (CGRect){[self convertPoint:_popoverView.points[0] fromView:_popoverView],CGSizeZero};
        _scrollView.frame = CGRectZero;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
#ifndef ESCDevelopTool_UIView_ESC
- (void)superviewFrameDidChanged
{
    self.frame = self.superview.bounds;
    [self layoutSubviews];
}
#endif

#pragma mark- 设置 contentView

- (void)setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [_scrollView addSubview:contentView];
    _scrollView.frame = contentView.bounds;
}

#pragma mark- 确定要显示的位置

- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect
{
    CGSize contentSize = _contentView.frame.size;
    contentSize.width = MIN(contentSize.width, self.frame.size.width - kArrowSize);
    contentSize.height = MIN(contentSize.height, self.frame.size.height - kArrowSize);
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    CGPoint point = CGPointZero;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = ESCPopoverArrowDirectionUp;
        point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _popoverView.frame = (CGRect){point.x, point.y, contentSize.width, contentSize.height+kArrowSize};
        _scrollView.frame = (CGRect){0.0,kArrowSize,contentSize};
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = ESCPopoverArrowDirectionDown;
        point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _popoverView.frame = (CGRect){point, contentSize.width, contentSize.height+kArrowSize};
        _scrollView.frame = (CGRect){CGPointZero,contentSize};
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = ESCPopoverArrowDirectionLeft;
        point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _popoverView.frame = (CGRect){point.x, point.y, contentSize.width+kArrowSize, contentSize.height};
        _scrollView.frame = (CGRect){kArrowSize,0.0,contentSize};
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = ESCPopoverArrowDirectionRight;
        point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _popoverView.frame = (CGRect){point, contentSize.width+kArrowSize, contentSize.height};
        _scrollView.frame = (CGRect){CGPointZero,contentSize};
        
    } else {
        point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _arrowDirection = ESCPopoverArrowDirectionNone;
        _popoverView.frame = (CGRect){CGPointZero, contentSize};
        _popoverView.center = point;
        _scrollView.frame = (CGRect){CGPointZero,contentSize};
    }
    CGFloat w = _scrollView.frame.size.width;
    CGFloat h = _scrollView.frame.size.height;
    
    w = MAX(w, _contentView.frame.size.width);
    h = MAX(h, _contentView.frame.size.height);
    
    [_scrollView setContentSize:CGSizeMake(w, h)];
    
    [self setUpArrowPoint];
}

- (void) setUpArrowPoint
{
    CGPoint arrorPoint;
    
    if (_arrowDirection == ESCPopoverArrowDirectionUp) {
        arrorPoint = (CGPoint){ _locateRect.origin.x+_locateRect.size.width/2, _locateRect.origin.y+_locateRect.size.height};
    } else if (_arrowDirection == ESCPopoverArrowDirectionDown) {
        arrorPoint = (CGPoint){ _locateRect.origin.x + _locateRect.size.width/2, _locateRect.origin.y };
    } else if (_arrowDirection == ESCPopoverArrowDirectionLeft) {
        arrorPoint = (CGPoint){ _locateRect.origin.x+_locateRect.size.width, _locateRect.origin.y+_locateRect.size.height/2};
    } else if (_arrowDirection == ESCPopoverArrowDirectionRight) {
        arrorPoint = (CGPoint){_locateRect.origin.x, _locateRect.origin.y+_locateRect.size.height/2};
    } else {
        arrorPoint = self.center;
    }
    
    arrorPoint.x = arrorPoint.x < 0 ? 0 : arrorPoint.x;
    arrorPoint.y = arrorPoint.y < 0 ? 0 : arrorPoint.y;
    
    CGPoint arrorPointLeft = CGPointZero;
    CGPoint arrorPointRight;
    
    CGRect frame = _popoverView.frame;
    
    if (_arrowDirection == ESCPopoverArrowDirectionLeft) {
        arrorPointLeft.x = frame.origin.x+kCornerRadius+kArrowSize;
        arrorPointRight.x = arrorPointLeft.x;
        
        arrorPointLeft.y = arrorPoint.y + kArrowSize*kArrowSizeRate;
        arrorPointRight.y = arrorPoint.y - kArrowSize*kArrowSizeRate;
        
        if (arrorPoint.y <= frame.origin.y || arrorPoint.y >= frame.origin.y+frame.size.height) {
            arrorPointLeft.y = frame.origin.y+frame.size.height;
            arrorPointRight.y = frame.origin.y;
        }
    }else if (_arrowDirection == ESCPopoverArrowDirectionRight){
        arrorPointLeft.x = frame.origin.x+frame.size.width-kCornerRadius-kArrowSize;
        arrorPointRight.x = arrorPointLeft.x;
        
        arrorPointLeft.y = arrorPoint.y + kArrowSize*kArrowSizeRate;
        arrorPointRight.y = arrorPoint.y - kArrowSize*kArrowSizeRate;
        
        if (arrorPoint.y <= frame.origin.y || arrorPoint.y >= frame.origin.y+frame.size.height) {
            arrorPointLeft.y = frame.origin.y+frame.size.height;
            arrorPointRight.y = frame.origin.y;
        }
    }else if (_arrowDirection == ESCPopoverArrowDirectionUp){
        arrorPointLeft.y = frame.origin.y+kCornerRadius+kArrowSize;
        arrorPointRight.y = arrorPointLeft.y;
        
        arrorPointLeft.x = arrorPoint.x-kArrowSize*kArrowSizeRate;
        arrorPointRight.x = arrorPoint.x + kArrowSize*kArrowSizeRate;
        
        if (arrorPoint.x <= frame.origin.x || arrorPoint.x >= frame.origin.x+frame.size.width) {
            arrorPointLeft.x = frame.origin.x;
            arrorPointRight.x = frame.origin.x+frame.size.width;
        }
        
    }else if (_arrowDirection == ESCPopoverArrowDirectionDown){
        arrorPointLeft.y = frame.origin.y-kCornerRadius+frame.size.height-kArrowSize;
        arrorPointRight.y = arrorPointLeft.y;
        
        arrorPointLeft.x = arrorPoint.x-kArrowSize*kArrowSizeRate;
        arrorPointRight.x = arrorPoint.x + kArrowSize*kArrowSizeRate;
        
        if (arrorPoint.x <= frame.origin.x || arrorPoint.x >= frame.origin.x+frame.size.width) {
            arrorPointLeft.x = frame.origin.x;
            arrorPointRight.x = frame.origin.x+frame.size.width;
        }
    }else{
        arrorPoint = CGPointMake(_popoverView.frame.size.width/2, _popoverView.frame.size.height/2);
        CGPoint points[3] = {arrorPoint,arrorPoint,arrorPoint};
        _popoverView.points = points;
        return;
    }
    
    // 修正坐标
    // x
    if (fabsf(arrorPointLeft.x - arrorPointRight.x) > kArrowSize*kArrowSizeRate*2) {
        if (fabsf(arrorPoint.x - arrorPointLeft.x) <= fabsf(arrorPoint.x - arrorPointRight.x) ) {
            arrorPointRight.x = arrorPointLeft.x+kArrowSize*kArrowSizeRate*2;
        }else{
            arrorPointLeft.x = arrorPointRight.x - kArrowSize*kArrowSizeRate*2;
        }
    }
    
    if (fabsf(arrorPointLeft.y - arrorPointRight.y) > kArrowSize*kArrowSizeRate*2) {
        if (fabsf(arrorPoint.y - arrorPointLeft.y) <= fabsf(arrorPoint.y - arrorPointRight.y)) {
            arrorPointRight.y = arrorPointLeft.y - kArrowSize*kArrowSizeRate*2;
        }else{
            arrorPointLeft.y = arrorPointRight.y + kArrowSize*kArrowSizeRate*2;
        }
    }
    
    CGPoint points[3] = {[self convertPoint:arrorPoint toView:_popoverView],
                            [self convertPoint:arrorPointLeft toView:_popoverView],
                            [self convertPoint:arrorPointRight toView:_popoverView]};
    _popoverView.points = points;
}

@end

@implementation ESCPopoverView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _points = malloc(sizeof(CGPoint)*3);
        memset(_points, 0, sizeof(CGPoint)*3);
    }
    return self;
}

- (void)dealloc
{
    if (self.points) free(_points);
}

- (void)setPoints:(CGPoint *)points
{
    _points[0] = points[0];
    _points[1] = points[1];
    _points[2] = points[2];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIGraphicsGetCurrentContext();
    // 绘制 arrow
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:_points[0]];
    [arrowPath addLineToPoint:_points[1]];
    [arrowPath addLineToPoint:_points[2]];
    [arrowPath addLineToPoint:_points[0]];
    
    [[UIColor blackColor] set];
    [arrowPath fill];
}

@end
