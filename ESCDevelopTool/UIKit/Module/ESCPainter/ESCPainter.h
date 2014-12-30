//
//  ESCPainter.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/29/14.
//
//

#import <UIKit/UIKit.h>

@interface ESCPainter : UIView

/**
 *  @param options 
 */
- (instancetype)initWithFrame:(CGRect)frame options:(NSDictionary *)options;

/**
 *  重绘
 */
- (void)redo;
/**
 *  撤销
 */
- (void)undo;

/**
 *  清空
 */
- (void)clear;

/**
 *  获取图像
 *  UIView 已实同该方法
 */
//- (UIImage *)snap;

/**
 *  获取序列化的图像数据
 */
- (NSData *)serializedFigureData;

- (void)loadSerializedFigrueData;

@end
