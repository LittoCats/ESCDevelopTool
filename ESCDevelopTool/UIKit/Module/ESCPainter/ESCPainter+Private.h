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
