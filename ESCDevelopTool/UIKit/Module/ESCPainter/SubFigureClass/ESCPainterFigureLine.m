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
    
}

- (void)recieveTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas
{
    
}

- (void)drawInContext:(CGContextRef)context
{
    
}

@end
