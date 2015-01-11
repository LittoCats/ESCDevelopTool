//
//  ESCPaintedFigure.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import "ESCPainter+Private.h"

@implementation ESCPaintedFigure

+ (instancetype)figureWithPrevious:(ESCPaintedFigure *)previous
{
    ESCPaintedFigure *figure = [[ESCPaintedFigure alloc] init];
    
    previous.next = figure;
    figure.previous = previous;
    
    return figure;
}

- (id)init
{
    if (self = [super init]) {
        self.scale = 1.0;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    
}

- (NSData *)serializedData
{
    return nil;
}

+ (instancetype)instanceWithSerializedData:(NSData *)data
{
    return nil;
}

- (NSArray *)recordPoints
{
    return [NSArray arrayWithArray:self.points];
}

- (void)beganWithTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    CGPoint p = [[touches anyObject] locationInView:canvas];
    self.location = (ESCPaintedFigureLocation){
        p.x,p.y,p.x,p.y
    };
}

- (void)recieveTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    CGPoint p = [[touches anyObject] locationInView:canvas];
    [self updateLocation:p];
}

- (void)endWithTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    CGPoint p = [[touches anyObject] locationInView:canvas];
    [self updateLocation:p];
    self.isEnd = YES;
    
    for (int i = 0; i < self.points.count; i++) {
        CGPoint p = CGPointFromString([self.points objectAtIndex:i]);
        [self.points replaceObjectAtIndex:i withObject:NSStringFromCGPoint([self enCodePoint:p])];
    }
}

- (BOOL)isValid
{
    return YES;
}

#pragma mark- location
- (void)setLocation:(ESCPaintedFigureLocation)location
{
    _location = location;
    self.center = CGPointMake((location.sx+location.ex)/2.0, (location.sy+location.ey)/2.0);
}

- (void)updateLocation:(CGPoint)p
{
    self.location = (ESCPaintedFigureLocation){
        MIN(self.location.sx, p.x),MIN(self.location.sy, p.y),
        MAX(self.location.ex, p.x),MAX(self.location.ey, p.y)
    };
}

@end
