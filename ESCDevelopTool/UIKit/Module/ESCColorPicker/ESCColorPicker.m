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
            const NSInteger bytesPerLine = BYTES_PER_PIXEL * 256 * 6;
            const NSInteger rawDataSize = 256 * 2 * 256 * 6 * BYTES_PER_PIXEL;
            unsigned char* rawData = (unsigned char*)malloc(rawDataSize);
            memset(rawData, 0, rawDataSize);
            
            uint32_t *ptrData = (uint32_t *)rawData;
            
            for (int y = 0; y < 512; y++) {
                for (int z = 0; z < 6; z ++) {
                    for (int x = 0; x < 256; x++) {
                        uint32_t alpha = 0xff000000;
                        uint32_t red = 255, green = 255, blue = 255;
                        
                        [self R:&red G:&green B:&blue withX:x Y:y Z:z];
                        
                        uint32_t color = alpha | (blue << 16) | (green  << 8) | red;
                        *(ptrData ++) = color;
                    }
                }
            }
            
            CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                                      rawData,
                                                                      rawDataSize,
                                                                      kQRCodeGeneratorDataProviderReleaseData);
            
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
            CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
            CGImageRef imageRef = CGImageCreate(256 * 6,
                                                256 * 2,
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

- (void)R:(uint32_t *)red G:(uint32_t *)green B:(uint32_t *)blue withX:(int)x Y:(int)y Z:(int)z
{
    // red
    if (z == 0 || z == 1)           *red = 255;
    else if (z == 3 || z == 4)      *red = 0;
    else if (z == 2)                *red = 255-x;
    else                            *red = x;
    
    // green
    if (z == 1 || z == 2)           *green = 0;
    else if (z == 4 || z == 5)      *green = 255;
    else if (z == 0)                *green = 255 - x;
    else                            *green = x;
    
    // blue
    if (z == 2 || z == 3)           *blue = 255;
    else if (z == 5 || z == 0)      *blue = 0;
    else if (z == 1)                *blue = x;
    else                            *blue = 255 - x;
    
    if (y < 256) {
        CGFloat zoom = y/255.0;
        *red *= zoom;
        *green *= zoom;
        *blue *= zoom;
    }else{
        CGFloat zoom = (y-255)/255.0;
        *red += zoom*(255 - *red);
        *green += zoom*(255 - *green);
        *blue += zoom*(255 - *blue);
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(colorPicker:didPickColor:)]) return;
    CGPoint point = [[touches anyObject] locationInView:self];
    int w = point.x*256*6/self.frame.size.width;
    int h = point.y*256*2/self.frame.size.height;
    
    int x = w%256;
    int z = w/256;
    int y = h;
    
    uint32_t red=255,green=255,blue=255;
    [self R:&red G:&green B:&blue withX:x Y:y Z:z];
    
    [self.delegate colorPicker:self didPickColor:[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0]];
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
