//
//  ESCPainterFigureLine.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "ESCPainterFigureLine.h"
#import "ESCPainter+Private.h"

@implementation ESCPainterFigureLine

- (id)init
{
    if (self = [super init]) {
        self.color = [UIColor colorWithRed:0.30 green:0.55 blue:0.25 alpha:1.00];
        self.width = 3.0;
        self.points = [NSMutableArray arrayWithObjects:NSStringFromCGPoint(CGPointZero),NSStringFromCGPoint(CGPointZero), nil];
    }
    return self;
}

- (void)setStartPoint:(NSString *)startPoint
{
    [self.points replaceObjectAtIndex:0 withObject:startPoint];
    self.isValid = NO;
}

- (void)setEndPoint:(NSString *)endPoint
{
    [self.points replaceObjectAtIndex:1 withObject:endPoint];
    self.isValid = YES;
}

- (void)beganWithTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    [super beganWithTouches:touches inCanvas:canvas];
    UITouch *touch = [touches anyObject];
    self.startPoint = NSStringFromCGPoint([touch locationInView:canvas]);
}

- (void)recieveTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    [super recieveTouches:touches inCanvas:canvas];
    UITouch *touch = [touches anyObject];
    self.endPoint = NSStringFromCGPoint([touch locationInView:canvas]);
}

- (BOOL)isValid
{
    return _isValid;
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextBeginPath(context);
    CGPoint startPoint = [self deCodePoint:CGPointFromString([self.points firstObject])];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGPoint endPoint = [self deCodePoint:CGPointFromString([self.points lastObject])];
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGContextSetStrokeColorWithColor(context, [self.color CGColor]);
    CGContextSetLineWidth(context, self.width);
    CGContextStrokePath(context);
}


@end
