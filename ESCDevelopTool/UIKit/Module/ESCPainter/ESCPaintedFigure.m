//
//  ESCPaintedFigure.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import "ESCPaintedFigure.h"

@implementation ESCPaintedFigure

+ (instancetype)figureWithPrevious:(ESCPaintedFigure *)previous
{
    ESCPaintedFigure *figure = [[ESCPaintedFigure alloc] init];
    
    previous.next = figure;
    figure.previous = previous;
    
    return figure;
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

- (void)recieveTouches:(NSSet *)touch inCanvas:(ESCPainterCanvas *)canvas
{
    
}

- (BOOL)isValid
{
    return YES;
}

@end
