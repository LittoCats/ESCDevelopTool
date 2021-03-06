//
//  ESCPainterCanvas.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import "ESCPainterCanvas.h"
#import "ESCPaintedFigure.h"

@interface ESCPainterCanvas ()

@property (nonatomic, strong) ESCPaintedFigure *figure;

@end

@implementation ESCPainterCanvas

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.figure = [self.delegate figureClassForCanvas:self];
    [_figure beganWithTouches:touches inCanvas:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_figure recieveTouches:touches inCanvas:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_figure endWithTouches:touches inCanvas:self];
    
    [self.delegate canvas:self DidCreateFigure:_figure];
    
    self.figure = nil;
    [self setNeedsDisplay];
}

#pragma mark- drawRect
- (void)drawRect:(CGRect)rect
{
    if (!self.figure) return;
    //获取当前上下文，
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    [_figure drawInContext:context];
}
@end
