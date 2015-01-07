//
//  ESCPainter+Private.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import "ESCPainter+Private.h"
#import <math.h>

@implementation ESCPainter (Private)

- (void)privateInit
{
    
}

@end

@implementation ESCPaintedFigure (Private)

- (CGPoint)deCodePoint:(CGPoint)sp
{
    // 计算旋转
    CGFloat rY = sp.y - self.center.y;
    CGFloat rX = sp.x-self.center.x;
    CGFloat r = sqrtf(powf(rX, 2)+powf(rY, 2));
    if (r == 0) return sp;
//    X
    CGFloat aX = acosf(rX/r);
    CGFloat dx = r*cosf(aX-self.rotationAngle)*self.scale;
    
//    Y
    CGFloat aY = asinf(rY/r);
    CGFloat dy = r*sinf(aY-self.rotationAngle)*self.scale;
    
    return self.isEnd ? CGPointMake(self.location.sx+self.center.x+dx, self.location.sy+self.center.y+dy) : CGPointMake(self.center.x+dx, self.center.y+dy);
}

- (CGPoint)enCodePoint:(CGPoint)sp
{
    return CGPointMake(sp.x-self.location.sx, sp.y-self.location.sy);
}

@end