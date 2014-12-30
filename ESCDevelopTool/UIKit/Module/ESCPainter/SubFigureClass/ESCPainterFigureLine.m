//
//  ESCPainterFigureLine.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "ESCPainterFigureLine.h"

@implementation ESCPainterFigureLine

- (id)init
{
    if (self = [super init]) {
        self.color = [UIColor colorWithRed:0.30 green:0.55 blue:0.25 alpha:1.00];
        self.width = 3.0;
    }
    return self;
}

- (void)beganWithTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    UITouch *touch = [touches anyObject];
    self.startPoint = NSStringFromCGPoint([touch locationInView:canvas]);
}

- (void)recieveTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    UITouch *touch = [touches anyObject];
    self.endPoint = NSStringFromCGPoint([touch locationInView:canvas]);
}

- (BOOL)isValid
{
    return _startPoint && _endPoint;
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextBeginPath(context);
    CGPoint startPoint = CGPointFromString(_startPoint);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGPoint endPoint = CGPointFromString(_endPoint);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGContextSetStrokeColorWithColor(context, [_color CGColor]);
    CGContextSetLineWidth(context, _width);
    CGContextStrokePath(context);
}


@end
