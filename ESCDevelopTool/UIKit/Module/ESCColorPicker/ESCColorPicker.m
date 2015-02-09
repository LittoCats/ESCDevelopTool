//
//  ESCColorPicker.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 2/9/15.
//
//

#import "ESCColorPicker.h"
#import <CoreGraphics/CoreGraphics.h>

#define BITS_PER_BYTE 8
#define BYTES_PER_PIXEL 4

static void kQRCodeGeneratorDataProviderReleaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}

@interface ESCColorPickerPlate : ESCColorPicker



@end
@implementation ESCColorPickerPlate

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            const NSInteger bitsPerPixel = BITS_PER_BYTE * BYTES_PER_PIXEL;
            const NSInteger bytesPerLine = BYTES_PER_PIXEL * 256;
            const NSInteger rawDataSize = 256 * 16 * BYTES_PER_PIXEL;
            unsigned char* rawData = (unsigned char*)malloc(rawDataSize);
            memset(rawData, 0, rawDataSize);
            
            uint32_t *ptrData = (uint32_t *)rawData;
            for (int x = 0; x < 256; x++) {
                for (int y = 0; y < 16; y++) {
                    uint32_t alpha = 0xff000000;
                    uint32_t red = x/16;
                    uint32_t green = red%2 ? x%16 : 16-x%16;
                    uint32_t blue = y;
                    
                    red |= red << 4;
                    green |= green << 4;
                    blue |= blue << 4;
                    
                    uint32_t color = alpha | (blue << 16) | (green  << 8) | red;
                    *(ptrData ++) = color;
                }
            }
            
            CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                                      rawData,
                                                                      rawDataSize,
                                                                      kQRCodeGeneratorDataProviderReleaseData);
            
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
            CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
            CGImageRef imageRef = CGImageCreate(256,
                                                16,
                                                BITS_PER_BYTE,
                                                bitsPerPixel,
                                                bytesPerLine,
                                                colorSpaceRef,
                                                bitmapInfo,
                                                provider,
                                                NULL,NO,renderingIntent);
            
            CGColorSpaceRelease(colorSpaceRef);
            CGDataProviderRelease(provider);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.layer.contents = (__bridge id)(imageRef);
            });
            
        });
    }
    return self;
}

@end

@implementation ESCColorPicker

+ (instancetype)plate
{
    return [ESCColorPickerPlate new];
}
+ (instancetype)belt
{
    return nil;
}
+ (instancetype)RGBSlider
{
    return nil;
}
@end
