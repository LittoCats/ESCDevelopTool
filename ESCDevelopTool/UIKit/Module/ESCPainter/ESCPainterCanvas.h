//
//  ESCPainterCanvas.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import <UIKit/UIKit.h>

@protocol ESCPainterCanvasDelegate;
@class ESCPaintedFigure;

@interface ESCPainterCanvas : UIView

@property (nonatomic, weak) id<ESCPainterCanvasDelegate> delegate;

@end

@protocol ESCPainterCanvasDelegate <NSObject>

@required

- (void)canvas:(ESCPainterCanvas *)canvas DidCreateFigure:(ESCPaintedFigure *)figure;

- (ESCPaintedFigure *)figureClassForCanvas:(ESCPainterCanvas *)canvas;

@end