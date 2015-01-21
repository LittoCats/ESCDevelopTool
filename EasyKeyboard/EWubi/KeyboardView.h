//
//  KeyboardView.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/20/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EKeyboardDelegate;

NS_CLASS_AVAILABLE_IOS(8_0)
@interface EKeyboardView : UIView

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NSPointerArray *keyButtons;
@property (nonatomic,strong) NSArray *lines;

@property (nonatomic, weak) id<EKeyboardDelegate> delegate;

@end

NS_CLASS_AVAILABLE_IOS(8_0)
@interface EKeyboardButton : UIButton

@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSString *keyValue;

+ (instancetype)buttonWithTarget:(id)target userInfo:(NSDictionary *)userInfo ;

@property (nonatomic, strong) UILabel *fnLabel;

@end