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

@interface MPCSettingsView : UIView

@property (nonatomic, weak) id<MPCViewActionDelegate> delegate;

- (id)initWithCurrentSettings:(NSDictionary *)settngs;

@property (nonatomic, strong) UILabel *serviceTypeLabel;
@property (nonatomic, strong) UITextField *serviceTypeField;
@property (nonatomic, strong) UILabel *displayNameLabel;
@property (nonatomic, strong) UITextField *displayNameField;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *activeButton;

@end