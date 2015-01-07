//
//  ESCImage.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/6/15.
//
//  require #import <ImageIO/ImageIO.h>

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <CoreImage/CoreImage.h>

typedef enum {
    ESCImageTypeUnknown,
    ESCImageTypePNG,
    ESCImageTypeJPEG,
    ESCImageTypeGIF,
    ESCImageTypeBMP,
    ESCImageTypeICO,
    ESCImageTypeCUR,
    ESCImageTypeJPEG2000
} ESCImageType;

typedef enum {
    ESCImageColorModelUnknown,
    ESCImageColorModelRGB,
    ESCImageColorModelCMYK,
    ESCImageColorModelGray,
    ESCImageColorModelLab
}ESCImageColorModel;

@interface ESCImage : NSObject

@property (nonatomic, readonly) ESCImageType type;

@property (nonatomic, readonly) NSInteger fileSize;

@property (nonatomic, readonly) CGSize size;

@property (nonatomic, readonly) NSInteger depth;

@property (nonatomic, readonly) NSInteger dpi;

@property (nonatomic, readonly) BOOL hasAlpha;

@property (nonatomic, readonly) ESCImageColorModel colorModel;

@property (nonatomic, readonly) NSString *profileName;

+ (instancetype)imageWithData:(NSData *)imgData;

- (CGImageRef)createImage;

@end

@interface ESCGIFImage : ESCImage

@property (nonatomic) NSUInteger frameCount;

- (NSTimeInterval)intervalForFrameAtIndex:(NSUInteger)index;

- (CGImageRef)createImageForFrameAtIndex:(NSUInteger)index;

@end

@interface ESCPNGImage : ESCImage

@end

@interface ESCJPEGImage : ESCImage

@end

@interface ESCICOImage : ESCImage

@end

@interface ESCBMPImage : ESCImage

@end

@interface ESCCURImage : ESCImage

@end

@interface ESCJPEG2000Image : ESCImage

@end