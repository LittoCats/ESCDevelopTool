//
//  ESCBarCoder.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/9/14.
//
//

#ifndef ESCDevelopTool_ESCBarCoder_h
#define ESCDevelopTool_ESCBarCoder_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, ESCCodeSymbolType) {
    ESCCodeSymbolType_QR               = 64         // 二维码
};

typedef NS_ENUM(NSInteger, ESCQRCodeQuality) {
    ESCQRCodeQuality_Low,
    ESCQRCodeQuality_Standard,
    ESCQRCodeQuality_Medium,
    ESCQRCodeQuality_High
};

// 在不同的线程中，不能共用实例
@interface ESCCodeSymbol : NSObject

@property (nonatomic)              ESCCodeSymbolType  type;
@property (nonatomic)              NSString        *content;      //symbol data

/**
 *  二维码纠错等级，非二维码，恒等于零
 */
@property (nonatomic)              ESCQRCodeQuality       quality;

/**
 *  根据以上属性生成的图像，
 *  @discussion 属性变更后，获取时，才会重新生成
 */
@property (nonatomic, readonly)             CGImageRef      image;
/**
 *  扫描时，传入的图像，如果要生成编码图像，则该值恒为 NULL
 */
@property (nonatomic, assign)             CGImageRef      srcImage;

/**
 *  设置生成图像的颜色及背景色,默认图像颜色为 #000000FF(黑色) ，背景色为 #FFFFFFFFF(白色）
 */
- (void)setImageColor:(NSString *)colorHex placeHolder:(NSString *)placeHolderHex;

/**
 *  扫描图像
 */
+ (instancetype)imageWithImage:(CGImageRef)srcImage;
@end
#endif