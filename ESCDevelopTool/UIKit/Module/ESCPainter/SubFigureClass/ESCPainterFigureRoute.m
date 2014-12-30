//
//  ESCpainterFigureRoute.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "ESCPainterFigureRoute.h"

@implementation ESCPainterFigureRoute

- (id)init
{
    if (self = [super init]) {
        self.color = [UIColor colorWithRed:0.30 green:0.55 blue:0.25 alpha:1.00];
        self.width = 3.0;
        self.points = [NSMutableArray new];
    }
    return self;
}

- (void)beganWithTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    [self recieveTouches:touches inCanvas:canvas];
}

- (void)recieveTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas;
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:canvas];
    // 如果与之前两点在同一条直线上，则删除上前一个点
    if (self.points.count > 1) {
        CGPoint pPoint = CGPointFromString([self.points lastObject]);
        CGPoint ppPoint = CGPointFromString([self.points objectAtIndex:self.points.count - 2]);
        if ((point.x-pPoint.x)/(point.y-pPoint.y) == (pPoint.x-ppPoint.x)/(ppPoint.y-ppPoint.y))
            [self.points removeLastObject];
    }
    [self.points addObject:NSStringFromCGPoint(point)];
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextBeginPath(context);
    CGPoint startPoint = CGPointFromString([_points firstObject]);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    
    for (NSString *pointStr in _points) {
        CGPoint point = CGPointFromString(pointStr);
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    
    CGContextSetStrokeColorWithColor(context, [_color CGColor]);
    CGContextSetLineWidth(context, _width);
    CGContextStrokePath(context);
}

@end
