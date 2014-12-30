//
//  UIImage+ESC+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#ifndef ESCDevelopTool_UIImage_ESC_Private_h
#define ESCDevelopTool_UIImage_ESC_Private_h

#import "UIImage+ESC.h"

@interface UIImage (ESC_Private)
- (UIImage *)resizedImageWithNewSize:(CGSize)newSize
                           transform:(CGAffineTransform)transform
                      drawTransposed:(BOOL)transpose
                interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end


#endif
