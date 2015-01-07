//
//  ESCGIFImage.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/6/15.
//
//

#import "ESCImage+Private.h"

@implementation ESCGIFImage

- (ESCImageType)type
{
    return ESCImageTypeGIF;
}

- (NSUInteger)frameCount
{
    return CGImageSourceGetCount(self.imgSource);
}

- (CGImageRef)createImageForFrameAtIndex:(NSUInteger)index
{
    return CGImageSourceCreateImageAtIndex(self.imgSource, index, NULL);
}

- (NSTimeInterval)intervalForFrameAtIndex:(NSUInteger)index
{
    NSDictionary *properties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(self.imgSource, index, NULL));
    return [[properties objectForKey:(NSString *)kCGImagePropertyGIFDelayTime] doubleValue];
}
@end
