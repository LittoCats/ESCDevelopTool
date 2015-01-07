//
//  ESCPainter+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import "ESCPainter.h"

#import "ESCPaintedFigure.h"
#import "ESCPainterCanvas.h"

@interface ESCPainter ()<ESCPainterCanvasDelegate>

//  采用链表存储缓存的图形

@property (nonatomic, strong) ESCPaintedFigure *firstFigure;
@property (nonatomic, strong) ESCPaintedFigure *lastFigure;

@property (nonatomic, weak) ESCPaintedFigure *tempFigure;

@property (nonatomic, strong) ESCPainterCanvas *canvas;

@end

@interface ESCPainter (Private)

- (void)privateInit;

@end

@interface ESCPaintedFigure ()

@property (nonatomic) CGPoint center;

@property (nonatomic, strong) NSMutableArray *points;

@property (nonatomic) BOOL isEnd;

- (void)updateLocation:(CGPoint)p;

@end

@interface ESCPaintedFigure (Private)

/**
 *  计算出点的绘制坐标
 */
- (CGPoint)deCodePoint:(CGPoint)sp;

/**
 *  计算 当前点在 figure 中的坐标
 */
- (CGPoint)enCodePoint:(CGPoint)sp;
@end