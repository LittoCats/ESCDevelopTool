//
//  ESCpainterFigureRoute.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "ESCPaintedFigure.h"

@interface ESCPainterFigureRoute : ESCPaintedFigure

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat width;
@property (nonatomic, strong) NSMutableArray *points;

@end
