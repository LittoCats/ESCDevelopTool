//
//  UIImage+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/8/14.
//	Copyright (c) 12/8/14 Littocats. All rights reserved.
//

#import "UIImage+ESC.h"

@implementation UIImage (ESC)

+ (UIImage *)imageWithSingleColor:(UIColor *)color
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, 1.0, 1.0, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){0.0f,0.0f,1.0f,1.0f});
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size colors:(NSArray *)colors gradientDirection:(CGFloat)direction
{
    if (!colors || colors.count < 2) return nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGFloat *colorComponents = malloc(sizeof(CGFloat)*4*colors.count);
    
    CGContextTranslateCTM( context, 0, size.height);
    CGContextScaleCTM( context, 1.0, -1.0 );
    
    CGFloat r,g,b,a;
    for (int i = 0; i < colors.count; i++) {
        UIColor *color = colors[i];
        [color getRed:&r green:&g blue:&b alpha:&a];
        colorComponents[i*4] = r;
        colorComponents[i*4+1] = g;
        colorComponents[i*4+2] = b;
        colorComponents[i*4+3] = a;
    }
    CGFloat *locations = malloc(sizeof(CGFloat)*colors.count);
    CGFloat stepLength = 1.0/(colors.count-1);
    
    locations[0] = 0.0;
    locations[colors.count-1] = 1.0;
    for (int i = 1; i < colors.count - 1; i ++) {
        locations[i] = stepLength*i;
    }
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, colors.count);
    
    CGFloat temp = (size.height - size.width * tanf(direction)) * cosf(direction);
    CGFloat x = size.width + temp*sinf(direction);
    CGFloat y = size.height - temp*cosf(direction);
    
    CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(x, y), options);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGGradientRelease(gradient);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(colorComponents);
    free(locations);
    
    return image;
}
@end
