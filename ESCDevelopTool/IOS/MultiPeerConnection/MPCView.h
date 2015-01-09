//
//  MPCView.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import <UIKit/UIKit.h>

#import "MPCActionDelegate.h"

@interface MPCView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<MPCViewActionDelegate> delegate;

- (void)reloadHistory:(NSAttributedString *)attrStr;

- (void)reloadPeersTable;

@end

@interface MPCInputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, weak) id<MPCViewActionDelegate> delegate;

@end