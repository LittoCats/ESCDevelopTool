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
    ESCImageTypePNG,
    ESCImageTypeJPEG,
    ESCImageTypeGIF
} ESCImageType;

@interface ESCImage : NSObject

@property (nonatomic, readonly) ESCImageType type;

@property (nonatomic, readonly) CGSize size;

@property (nonatomic, readonly) NSInteger dpi;

+ (instancetype)imageWithData:(NSData *)imgData;

@end
