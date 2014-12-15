//
//  ESCCodeSymbol+Scanner.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/11/14.
//	Copyright (c) 12/11/14 Littocats. All rights reserved.
//

#import "ESCCodeSymbol_Private.h"
#import "zbar.h"
#import "symbol.h"

#ifdef __cplusplus
using namespace zbar;
#endif

@implementation ESCCodeSymbol (Scanner)

- (void)zbarScannerInit
{
    if (!_scanner)
        _scanner = zbar_image_scanner_create();
}

- (void)zbarScannerRelease
{
    if (_scanner){
        zbar_image_scanner_destroy(_scanner);
        _scanner = NULL;
    }
}

- (void)scanByZbar
{
    zbar_image_t *zimage = [self __barImageWithCGImage:_srcImage];
    zbar_scan_image(_scanner, zimage);
    // release memery
    if (zimage) zbar_image_destroy(zimage);
    
    const zbar_symbol_set_t *set = zbar_image_scanner_get_results(_scanner);
    
    const zbar_symbol_t *symbol = set->head ;
    const zbar_symbol_t *sym ;
    while (symbol && (sym = symbol->next)) {
        if (!symbol) {
            symbol = sym;
            continue;
        }
        if (symbol->quality < sym->quality)
            symbol = sym;
    }
    if (!symbol) return;
    //拼装结果
    _type = kTypeWithZbar_symbol_type(symbol->type);
    _content = [[NSString alloc] initWithBytes:symbol->data length:symbol->datalen encoding:NSUTF8StringEncoding];
    self.nps = symbol->npts;
    self.orientation = symbol->orient;
    _quality = symbol->quality;
    
    NSUInteger num = symbol->npts;
    point_t *points = symbol->pts;
    NSMutableArray *pointList = [NSMutableArray new];
    while (num --) {
        point_t point = *points++;
        CGPoint cgpoint = CGPointMake(point.x, point.y);
        [pointList addObject:[NSValue value:&cgpoint withObjCType:@encode(CGPoint)]];
    }
    self.pointList = [NSArray arrayWithArray:pointList];
}

#pragma mark-
- (zbar_image_t *)__barImageWithCGImage:(CGImageRef)image
{
    CGRect crop = CGRectMake(0, 0,
                             CGImageGetWidth(image),
                             CGImageGetHeight(image));
    CGSize size = crop.size;
    
    unsigned int w = size.width + 0.5;
    unsigned int h = size.height + 0.5;
    
    unsigned long datalen = w * h;
    uint8_t *raw = malloc(datalen);
    if(!raw) {
        return(nil);
    }
    
    zbar_image_t *zimg = zbar_image_create();
    
    zbar_image_set_data(zimg, raw, datalen, zbar_image_free_data);
    zbar_image_set_format(zimg, zbar_fourcc('Y','8','0','0'));
    zbar_image_set_size(zimg, w, h);
    
    // scale and crop simultaneously
    CGFloat scale = size.width / crop.size.width;
    crop.origin.x *= -scale;
    crop.size.width = scale * (CGFloat)CGImageGetWidth(image);
    scale = size.height / crop.size.height;
    CGFloat height = CGImageGetHeight(image);
    // compensate for wacky origin
    crop.origin.y = height - crop.origin.y - crop.size.height;
    crop.origin.y *= -scale;
    crop.size.height = scale * height;
    
    // generate grayscale image data
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx =
    CGBitmapContextCreate(raw, w, h, 8, w, cs, 0);
    CGColorSpaceRelease(cs);
    CGContextSetAllowsAntialiasing(ctx, 0);
    
    CGContextDrawImage(ctx, crop, image);
    CGContextRelease(ctx);
    
    return zimg;
}

static ESCCodeSymbolType kTypeWithZbar_symbol_type(zbar_symbol_type_t type)
{
    return (NSInteger)type;
}
@end
