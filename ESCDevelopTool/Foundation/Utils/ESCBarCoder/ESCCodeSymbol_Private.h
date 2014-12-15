//
//  ESCCodeSymbol_Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/11/14.
//
//

#ifndef ESCDevelopTool_ESCCodeSymbol_Private_h
#define ESCDevelopTool_ESCCodeSymbol_Private_h

#import "ESCCodeSymbol.h"

@interface ESCCodeSymbol ()
{
    ESCCodeSymbolType   _type;
    NSString            *_content;
    ESCQRCodeQuality    _quality;
    CGImageRef          _image;
    CGImageRef          _srcImage;
    
    uint32_t            _imageColor;
    uint32_t            _placeHolder;
    
    // zbar scanner
    void *_scanner;
}

@property (nonatomic)             CGImageRef      image;

@property (nonatomic, getter=isNeedUpdateImage) BOOL needUpdateImage;

@property (nonatomic, getter=isNeedUpdateContent) BOOL needUpdateContent;

#pragma mark- private property
@property (nonatomic)              NSUInteger       nps;        // number of points in location polygon
@property (nonatomic)              NSArray          *pointList; //list of points in location polygon

@property (nonatomic)              int              orientation;

@end

@interface ESCCodeSymbol (Generator)

- (CGImageRef)generateQRImage;

@end

@interface ESCCodeSymbol (Scanner)

- (void)zbarScannerInit;
- (void)zbarScannerRelease;

- (void)scanByZbar;

@end

#endif
