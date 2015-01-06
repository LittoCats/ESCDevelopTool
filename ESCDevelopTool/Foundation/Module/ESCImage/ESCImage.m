//
//  ESCImage.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/6/15.
//
//

#import "ESCImage+Private.h"

@implementation ESCImage

+ (instancetype)imageWithData:(NSData *)imgData
{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imgData, NULL);
    CGImageSourceStatus status = CGImageSourceGetStatus(source);
    if (status != kCGImageStatusComplete) return nil;
    
    CFStringRef imgType = CGImageSourceGetType(source);
    
    
    return nil;
}


- (void)dealloc
{
    if (imgSource) CFRelease(imgSource);
    imgSource = nil;
}
@end
