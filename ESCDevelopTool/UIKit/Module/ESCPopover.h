//
//  ESCPopover.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN const NSString *ESCPopoverTintcolorKey;

@class UIView;

@interface ESCPopover : UIView

@property (nonatomic, strong) UIView *contentView;


- (void)presentFromRect:(CGRect)rect
                 inView:(UIView *)view
                options:(NSDictionary *)options;
@end
