//
//  ESCInternationalManager+UIKit.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/1/15.
//
//

#import "ESCInternationalManager.h"
#import <UIKit/UIKit.h>

@interface ESCInternationalManager (UIKit)<ESCInternationalManagerDelegate>



@end

@protocol ESCInternationalProtocol <NSObject>

- (void)updateInternationalInfomationWithUserInfo:(id)userInfo;

@end

@interface UILabel (ESCInternationalManager) <ESCInternationalProtocol>

- (void)setText:(NSString *)text withInternational:(NSString *)international;

@end

@interface UIButton (ESCInternationalManager) <ESCInternationalProtocol>

- (void)setTitle:(NSString *)text withInternational:(NSString *)international state:(UIControlState)state;

@end