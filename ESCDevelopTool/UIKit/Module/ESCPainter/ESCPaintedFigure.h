//
//  ESCPaintedFigure.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import <UIKit/UIKit.h>
#import "ESCPainterCanvas.h"

typedef struct {
    CGFloat sx,sy,ex,ey;
} ESCPaintedFigureLocation;

@interface ESCPaintedFigure : NSObject

@property (nonatomic, weak) ESCPaintedFigure *previous;

@property (nonatomic, strong) ESCPaintedFigure *next;

/**
 *  图形的框架，图形的旋转是基于框架中心的
 */
@property (nonatomic) ESCPaintedFigureLocation location;

@property (nonatomic) CGFloat rotationAngle;

/**
 *  default 1.0;
 */
@property (nonatomic) CGFloat scale;

@property (nonatomic, strong) UIColor *color;       // 线条颜色
@property (nonatomic) CGFloat width;                // 线条宽度
@property (nonatomic, readonly) NSArray *recordPoints;   // 记录点，location 中的相对位置坐标

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
- (void)endWithTouches:(NSSet *)touches inCanvas:(ESCPainterCanvas *)canvas;

/**
 *  默认返回 YES;
 */
- (BOOL)isValid;

@end

