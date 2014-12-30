//
//  ESCPaintedFigure.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import <UIKit/UIKit.h>
#import "ESCPainterCanvas.h"

@interface ESCPaintedFigure : NSObject

@property (nonatomic, strong) ESCPaintedFigure *previous;

@property (nonatomic, weak) ESCPaintedFigure *next;

/**
 *
 */
- (void)drawInContext:(CGContextRef)context;

/**
 *  将图像数据序列化为 NSData
 */
- (NSData *)serializedData;

/**
 *  从序列化的数据中恢复图像，
 */
+ (instancetype)instanceWithSerializedData:(NSData *)data;

- (void)beganWithTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas;
- (void)recieveTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas;

@end

