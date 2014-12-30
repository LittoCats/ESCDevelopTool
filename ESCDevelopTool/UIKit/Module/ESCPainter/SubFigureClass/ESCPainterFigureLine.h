//
//  ESCPainterFigureLine.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "ESCPaintedFigure.h"

@interface ESCPainterFigureLine : ESCPaintedFigure

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat width;

@property (nonatomic) CGPoint startPoint;

@property (nonatomic) CGPoint endPoint;
@end
