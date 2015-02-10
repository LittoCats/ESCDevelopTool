//
//  ESCColorPicker.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 2/9/15.
//
//

#import "ESCColorPicker+Private.h"
#import <CoreGraphics/CoreGraphics.h>

#import <math.h>

#import "ESCCrypt.h"

static void kQRCodeGeneratorDataProviderReleaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}

@implementation ESCColorPicker

+ (instancetype)plate
{
    return [ESCColorPickerPlate new];
}
+ (instancetype)belt
{
    return [ESCColorPickerBelt new];
}
+ (instancetype)RGBSlider
{
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(colorPicker:didPickColor:)]) return;
    CGPoint point = [[touches anyObject] locationInView:self];
    
    uint32_t red = 255, green = 255, blue = 255;
    [self R:&red G:&green B:&blue atPoint:point];
    [self.delegate colorPicker:self didPickColor:[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0]];
}

- (void)R:(uint32_t *)red G:(uint32_t *)green B:(uint32_t *)blue atPoint:(CGPoint)point
{
}

- (UIImage *)cachedColorCard:(CGImageRef)imageRef
{
    NSString *cacheName = [NSString stringWithFormat:@"Littocats_ESCDevelopTool_ColorCard_%@",NSStringFromClass(self.class)];
    NSString *cacheFile = [NSTemporaryDirectory() stringByAppendingPathComponent:[ESCCrypt MD5Encrypt:[cacheName dataUsingEncoding:NSUTF8StringEncoding]]];
    if (imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:cacheFile atomically:YES];
        return image;
    }
    
    return [UIImage imageWithContentsOfFile:cacheFile];
}
@end

@implementation ESCColorPickerBelt

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *colorCard = [self cachedColorCard:nil];
            if (!colorCard) {
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
                
                colorCard = [self cachedColorCard:imageRef];
                
                CGImageRelease(imageRef);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.layer.contents = (__bridge id)([colorCard CGImage]);
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

- (void)R:(uint32_t *)red G:(uint32_t *)green B:(uint32_t *)blue atPoint:(CGPoint)point
{
    int w = point.x*256*6/self.frame.size.width;
    int h = point.y*256*2/self.frame.size.height;
    
    int x = w%256;
    int z = w/256;
    int y = h;
    
    [self R:red G:green B:blue withX:x Y:y Z:z];
}

@end


#define demission   2312
#define demission_2 1156
#define demission_4 578

@implementation ESCColorPickerPlate

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *colorCard = [self cachedColorCard:nil];
            if (!colorCard) {
                const NSInteger bitsPerPixel = BITS_PER_BYTE * BYTES_PER_PIXEL;
                const NSInteger bytesPerLine = BYTES_PER_PIXEL * demission;
                const NSInteger rawDataSize = demission * demission * BYTES_PER_PIXEL;
                unsigned char* rawData = (unsigned char*)malloc(rawDataSize);
                memset(rawData, 0, rawDataSize);
                
                uint32_t *ptrData = (uint32_t *)rawData;
                
                
                for (int x = -demission_2; x < demission_2; x ++) {
                    for (int y = -demission_2; y < demission_2; y ++) {
                        uint32_t red = 255, green = 255, blue = 255, alpha = 0xff000000;
                        
                        [self R:&red G:&green B:&blue withX:x Y:y];
                        
                        uint32_t color = alpha | ((blue << 16) & 0x00ff0000) | ((green  << 8) & 0x0000ff00) | (red & 0x000000ff);
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
                CGImageRef imageRef = CGImageCreate(demission,
                                                    demission,
                                                    BITS_PER_BYTE,
                                                    bitsPerPixel,
                                                    bytesPerLine,
                                                    colorSpaceRef,
                                                    bitmapInfo,
                                                    provider,
                                                    NULL,NO,renderingIntent);
                
                CGColorSpaceRelease(colorSpaceRef);
                CGDataProviderRelease(provider);
                
                colorCard = [self cachedColorCard:imageRef];
                
                CGImageRelease(imageRef);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.layer.contents = (__bridge id)([colorCard CGImage]);
            });

        });
    }
    return self;
}

- (void)R:(uint32_t *)red G:(uint32_t *)green B:(uint32_t *)blue withX:(int)x Y:(int)y
{
    float delta = M_PI/3, a_1 = delta, a_2 = delta*2, a_3 = delta*3, a_4 = delta*4, a_5 = delta*5, a_6 = delta*6;
    float r = sqrtf(powf(x, 2)+powf(y, 2));
    
    if (r <= demission_2) {
        float sina = fabsf(y/r);
        float a = asinf(sina);
        if (x >= 0 && y >= 0)           a = a;
        else if (x <= 0 && y >= 0)      a = M_PI-a;
        else if (x <= 0 && y <= 0)      a = M_PI+a;
        else if (x >= 0 && y <= 0)      a = M_PI*2-a;
        
        // red
        if (a <= a_1 || a>= a_5)            *red = 255;
        else if (a >= a_2 && a <= a_4)      *red = 0;
        else if (a >= a_1 && a <= a_2)      *red = 255*(a_2-a)/delta;
        else if (a >= a_4 && a <= a_5)      *red = 255*(a-a_4)/delta;
        
        // green
        if (a >= a_1 && a <= a_3)           *green = 255;
        else if (a >= a_4)                  *green = 0;
        else if (a <= a_1)                  *green = 255*a/delta;
        else if (a >= a_3 && a <= a_4)      *green = 255*(a_4-a)/delta;
        
        // blue
        if (a <= a_2)                       *blue = 0;
        else if (a >= a_3 && a <= a_5)      *blue = 255;
        else if (a >= a_5)                  *blue = 255*(a_6-a)/delta;
        else if (a >= a_2 && a <= a_3)      *blue = 255*(a-a_2)/delta;
        
        // 收敛
        if (r > demission_4*4/3.0) {
            CGFloat zoom = sqrtf((demission_2 - r)/(demission_4*2/3.0));
            *red     *= zoom;
            *green   *= zoom;
            *blue    *= zoom;
        }else{
            CGFloat zoom = (demission_4*4/3.0 - r)/(demission_4*4/3.0);
            *red     += zoom*(255 - *red);
            *green   += zoom*(255 - *green);
            *blue    += zoom*(255 - *blue);
        }
    }
}

- (void)R:(uint32_t *)red G:(uint32_t *)green B:(uint32_t *)blue atPoint:(CGPoint)point
{
    int y = point.x*demission/self.frame.size.width - demission_2;
    int x = point.y*demission/self.frame.size.height - demission_2;
    
    [self R:red G:green B:blue withX:x Y:y];
}

@end
