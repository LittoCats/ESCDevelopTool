//
//  ESCBarCoder.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/9/14.
//
//

#import "ESCCodeSymbol_Private.h"

@implementation ESCCodeSymbol

- (id)init
{
    if (self = [super init]) {
        [self zbarScannerInit];
    }
    return self;
}

- (void)dealloc
{
    CGImageRelease(_image);
    _image = NULL;
    CGImageRelease(_srcImage);
    _srcImage = NULL;
    
    [self zbarScannerRelease];
}

#pragma mark- setter
- (void)setType:(ESCCodeSymbolType)type
{
    _type = type;
    self.needUpdateImage = YES;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.needUpdateImage = YES;
}

- (void)setQuality:(ESCQRCodeQuality)quality
{
    _quality = quality;
    self.needUpdateImage = YES;
}

- (void)setSrcImage:(CGImageRef)srcImage
{
    CGImageRelease(_srcImage);
    _srcImage = CGImageRetain(srcImage);
    self.needUpdateContent = YES;
}

- (void)setImageColor:(NSString *)colorHex placeHolder:(NSString *)placeHolderHex
{
    _imageColor = kHexValueWithString(colorHex);
    _placeHolder = kHexValueWithString(placeHolderHex);
}
#pragma mark- getter
- (ESCCodeSymbolType)type
{
    if (self.isNeedUpdateContent) [self updateContent];
    return _type;
}

- (NSString *)content
{
    if (self.isNeedUpdateContent) [self updateContent];
    return _content;
}

- (ESCQRCodeQuality)quality
{
    if (self.isNeedUpdateContent) [self updateContent];
    return _quality;
}

- (CGImageRef)image
{
    if (self.isNeedUpdateImage) [self updateImage];
    return _image;
}

- (CGImageRef)srcImage
{
    return _srcImage;
}

#pragma mark- scan

+ (instancetype)imageWithImage:(CGImageRef)srcImage
{
    ESCCodeSymbol *coder = [[ESCCodeSymbol alloc] init];
    coder.srcImage = srcImage;
    return coder;
}

#pragma mark-
- (void)updateImage
{
    switch (_type) {
        case ESCCodeSymbolType_QR:
            _image = [self generateQRImage];
            break;
            
        default:
            break;
    }
    self.needUpdateImage = NO;
}

- (void)updateContent
{
    [self scanByZbar];
    self.needUpdateContent = NO;
}

#pragma mark- utils
static uint32_t kHexValueWithString(NSString *string)
{
    //如果 string 不存在或不合法，则反回随机色
    if (!string || ![string isKindOfClass:NSString.class] || string.length < 4) {
        return arc4random()%UINT_MAX;
    }
    NSString *hex = [[string substringFromIndex:1] uppercaseString];
    char *HEX = (char *)malloc(sizeof(char)*9);
    HEX[0] = 'F';
    HEX[1] = 'F';
    HEX[8] = '\0';
    if (hex.length == 3 || hex.length == 4) {
        int i = 0;
        do {
            HEX[7-i*2] = [hex characterAtIndex:i];
            HEX[6-i*2] = [hex characterAtIndex:i];
        }while (hex.length > ++i);
    }else if (hex.length == 6 || hex.length == 8){
        int i = 0;
        do {
            HEX[7-i] = [hex characterAtIndex:i];
        }while (hex.length > ++i);
    }
    char *p;
    uint32_t value = (uint32_t)strtoul(HEX, &p, 16);
    free(HEX);
    return value;
}
@end
