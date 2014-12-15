//
//  ESCCodeSymbol+Generator.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/11/14.
//	Copyright (c) 12/11/14 Littocats. All rights reserved.
//

#import "ESCCodeSymbol_Private.h"
#import "qr_encode.h"

#define BITS_PER_BYTE 8
#define BYTES_PER_PIXEL 4

@implementation ESCCodeSymbol (Generator)

- (CGImageRef)generateQRImage
{
    const char *cString = [_content UTF8String];
    
    CQR_Encode *encoder = new CQR_Encode;
    encoder->EncodeData(_quality, 1.0, true, -1, cString);
    NSInteger dimension = encoder->m_nSymbleSize;
    
    // matix
    bool **matix = (bool**)malloc(sizeof(bool*) * dimension);
    for (NSInteger i = 0; i < dimension; i ++)
        matix[i] = (bool*)malloc(sizeof(bool) * dimension);
    
    for (int y=0; y<dimension; y++) {
        for (int x=0; x<dimension; x++) {
            int v = encoder->m_byModuleData[y][x];
            bool bk = v==1;
            matix[x][y] = bk;
        }
    }
    
    NSInteger offset = dimension*0.1;
    offset = offset >= 10 ? offset : 10;
    NSInteger imageDimension = dimension*4 + offset;
    
    // renderDataMatrix
    const NSInteger bitsPerPixel = BITS_PER_BYTE * BYTES_PER_PIXEL;
    const NSInteger bytesPerLine = BYTES_PER_PIXEL * imageDimension;
    const NSInteger rawDataSize = imageDimension * imageDimension * BYTES_PER_PIXEL;
    unsigned char* rawData = (unsigned char*)malloc(rawDataSize);
    
    NSInteger matrixDimension = dimension;
    NSInteger pixelPerDot = imageDimension / matrixDimension;
    NSInteger offsetTopAndLeft = (NSInteger)((imageDimension - pixelPerDot * matrixDimension) / 2);
    NSInteger offsetBottomAndRight = (imageDimension - pixelPerDot * matrixDimension - offsetTopAndLeft);
    
    // alpha, blue, green, red
    const uint32_t white = _imageColor ? _imageColor : 0xFFFFFFFF;
    const uint32_t black = _placeHolder ? _placeHolder : 0xFF000000;
    const uint32_t transp = 0x00FFFFFF;
    
    uint32_t *ptrData = (uint32_t *)rawData;
    // top offset
    for(NSInteger c = offsetTopAndLeft*imageDimension; c>0; c--)
        *(ptrData++) = transp;
    
    for(int mx=0; mx<matrixDimension; mx++) {
        uint32_t *ptrDataSouce = ptrData; // start of the row we will copy
        // left offset
        for(NSInteger c=offsetTopAndLeft; c>0; c--)
            *(ptrData++) = transp;
        
        for(NSInteger my=0; my<matrixDimension; my++) {
            uint32_t clr = matix[mx][my] ? black : white;
            // draw one pixel line of data
            for(NSInteger c=pixelPerDot; c>0; c--)
                *(ptrData++) = clr;
        }
        
        // right offset
        for(NSInteger c=offsetBottomAndRight; c>0; c--)
            *(ptrData++) = transp;
        
        // then copy that row pixelPerDot-1 times
        for(NSInteger c=(pixelPerDot-1)*imageDimension; c>0; c--)
            *(ptrData++) = *(ptrDataSouce++);
    }
    
    // bottom offset
    for(NSInteger c=offsetBottomAndRight*imageDimension; c>0; c--)
        *(ptrData++) = transp;
    
    // release matix
    for (int y = 0; y < dimension; y ++) {
        free(matix[y]);
    }
    free(matix);
    
    // create CGImageRef
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                              rawData,
                                                              rawDataSize,
                                                              kQRCodeGeneratorDataProviderReleaseData);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageDimension,
                                        imageDimension,
                                        BITS_PER_BYTE,
                                        bitsPerPixel,
                                        bytesPerLine,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL,NO,renderingIntent);
    
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    
    return imageRef;
}

static void kQRCodeGeneratorDataProviderReleaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}
@end
