//
//  ESCImage.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/6/15.
//
//

#import "ESCImage+Private.h"

static Class kESCImageClassMap(NSString *type){
    static NSDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{@"com.compuserve.gif":[ESCGIFImage class],
                @"public.png":[ESCPNGImage class],
                @"public.jpeg":[ESCJPEGImage class],
                @"com.microsoft.bmp":[ESCBMPImage class],
                @"com.microsoft.cur":[ESCCURImage class],
                @"com.microsoft.ico":[ESCICOImage class],
                @"public.jpeg-2000":[ESCJPEG2000Image class]};
    });
    return [map objectForKey:type];
}

@implementation ESCImage

+ (instancetype)imageWithData:(NSData *)imgData
{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imgData, NULL);
    CGImageSourceStatus status = CGImageSourceGetStatus(source);
    if (status != kCGImageStatusComplete) return nil;
    NSString *imgType = CFBridgingRelease(CGImageSourceGetType(source));
    Class class = kESCImageClassMap(imgType);
    ESCImage *image = [[class alloc] init];
    image.imgSource = source;
    return image;
}

- (instancetype)initWithImageSource:(CGImageSourceRef)imageSource
{
    if (self = [super init]) {
        self.imgSource = imageSource;
        self.properties = CFBridgingRelease(CGImageSourceCopyProperties(imageSource, NULL));
    }
    return self;
}

- (id)init
{
    NSLog(@"You should init ESCImage instance with class method 'imageWithData' .");
    return nil;
}

- (void)dealloc
{
    if (_imgSource) CFRelease(_imgSource);
    _imgSource = nil;
}

#pragma mark- common properties
- (ESCImageType)type
{
    return ESCImageTypeUnknown;
}

- (NSInteger)fileSize
{
    return [[self.properties objectForKey:(NSString *)kCGImagePropertyFileSize] integerValue];
}

- (CGSize)size
{
    return CGSizeMake([[self.properties objectForKey:(NSString *)kCGImagePropertyPixelWidth] floatValue], [[self.properties objectForKey:(NSString *)kCGImagePropertyPixelHeight] floatValue]);
}

- (NSInteger)depth
{
    return [[self.properties objectForKey:(NSString *)kCGImagePropertyDepth] integerValue];
}

- (NSString *)profileName
{
    return [self.properties objectForKey:(NSString *)kCGImagePropertyProfileName];
}

- (ESCImageColorModel)colorModel
{
    static NSDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{};
    });
    return [[map objectForKey:[self.properties objectForKey:(NSString *)kCGImagePropertyColorModel]] intValue];
}

- (NSInteger)dpi
{
    NSInteger wDpi = [[self.properties objectForKey:(NSString *)kCGImagePropertyDPIWidth] integerValue];
    NSInteger hDpi = [[self.properties objectForKey:(NSString *)kCGImagePropertyDPIHeight] integerValue];
    return MIN(wDpi, hDpi);
}

- (BOOL)hasAlpha
{
    return [[self.properties objectForKey:(NSString *)kCGImagePropertyHasAlpha] boolValue];
}

- (CGImageRef)createImage
{
    return CGImageSourceCreateImageAtIndex(self.imgSource, 0, NULL);
}
@end
