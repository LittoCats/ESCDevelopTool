//
//  ESCPainter.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import "ESCPainter+Private.h"

#import "ESCPainterFigureRoute.h"

@implementation ESCPainter

- (instancetype)initWithFrame:(CGRect)frame options:(NSDictionary *)options
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self defaultInit];
        [self privateInit];
    }
    return self;
}

- (void)redo
{
    if (_lastFigure.next) self.lastFigure = _lastFigure.next;
}
- (void)undo
{
    self.lastFigure = _lastFigure.previous;
}
- (void)clear
{
    self.lastFigure = _firstFigure;
}

- (NSData *)serializedFigureData
{
    return nil;
}

- (void)loadSerializedFigrueData
{
    
}

#pragma mark- 画板更新
- (void)setLastFigure:(ESCPaintedFigure *)lastFigure
{
    _lastFigure = lastFigure;
    [self setNeedsDisplay];
}

#pragma mark- canvas delegate
- (void)canvas:(ESCPainterCanvas *)canvas DidCreateFigure:(ESCPaintedFigure *)figure
{
    if (![figure isValid]) return;
    _lastFigure.next = figure;
    figure.previous = _lastFigure;
    self.lastFigure = figure;
}

- (ESCPaintedFigure *)figureClassForCanvas:(ESCPainterCanvas *)canvas
{
    return [[NSClassFromString(self.figureClass) alloc] init];
}

#pragma mark-
- (void)defaultInit
{
    self.firstFigure = [[ESCPaintedFigure alloc] init];
    self.lastFigure = _firstFigure;
    
    self.canvas = [[ESCPainterCanvas alloc] initWithFrame:self.bounds];
    _canvas.delegate = self;
    _canvas.backgroundColor = [UIColor clearColor];
    [self addSubview:_canvas];

}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_canvas setFrame:self.bounds];
}

#pragma mark- drawRect
- (void)drawRect:(CGRect)rect
{
    ESCPaintedFigure *figure = _firstFigure.next;
    if (!figure || _lastFigure == _firstFigure) return;
    
    //获取当前上下文，
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    do {
        [figure drawInContext:context];
        
        figure = figure.next;
    } while (figure && figure != _lastFigure.next);
}

@end
