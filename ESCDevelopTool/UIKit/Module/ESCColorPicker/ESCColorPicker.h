//
//  ESCColorPicker.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 2/9/15.
//
//

#import <UIKit/UIKit.h>

@class ESCColorPicker;
@protocol ESCColorPickerDelegate <NSObject>

@optional
- (void)colorPicker:(ESCColorPicker *)picker didPickColor:(UIColor *)color;

@end

@interface ESCColorPicker : UIControl

@property (nonatomic, weak) id<ESCColorPickerDelegate> delegate;

+ (instancetype)plate;
+ (instancetype)belt;
+ (instancetype)RGBSlider;

@end
