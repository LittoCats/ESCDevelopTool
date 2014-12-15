//
//  __ESCToastView.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import <UIKit/UIKit.h>

#import "UIView+ESC_Private.h"

@interface __ESCToastView : UILabel

@property (nonatomic) ESCToastPosition position;

@property (nonatomic) NSTimeInterval timeInterval;

- (void)setOwner:(UIView *)owner;

@property (nonatomic, weak) NSTimer *timer;

@end
