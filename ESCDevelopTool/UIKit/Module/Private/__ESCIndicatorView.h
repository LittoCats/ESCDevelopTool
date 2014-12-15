//
//  __ESCIndicatorView.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/28/14.
//
//

#import <UIKit/UIKit.h>
#import "UIView+ESC_Private.h"

@interface __ESCIndicatorView : UIView

- (void)setMessage:(NSString *)message
             style:(ESCIndicatorStyle)style
          interval:(NSTimeInterval)interval;

- (void)setOwner:(UIView *)owner;

- (void)hide:(BOOL)isAll;

@end

@interface __ESCIndicatorViewOverlay : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UILabel *label;

@end