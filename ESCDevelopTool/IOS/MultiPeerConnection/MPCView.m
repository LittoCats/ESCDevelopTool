//
//  MPCView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import "MPCView.h"

@interface MPCView ()

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UITableView *peersTableView;

@property (nonatomic, strong) UITextView *messageView;

@property (nonatomic, strong) MPCInputView *inputView;

@end


#define kInputViewHeight 44.0f

@implementation MPCView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self defaultInit];
        
        UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)];
        sgr.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:sgr];
    }
    return self;
}

- (void)defaultInit
{
    self.contentView = [[UIScrollView alloc] init];
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    [self addSubview:_contentView];
    
    self.peersTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _peersTableView.delegate = self;
    _peersTableView.dataSource = self;
    [_contentView addSubview:_peersTableView];
    
    self.messageView = [[UITextView alloc] init];
    _messageView.editable = NO;
    [_contentView addSubview:_messageView];
    
    self.inputView = [[MPCInputView alloc] init];
    [self addSubview:_inputView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        self.peersTableView.frame = CGRectMake(0, 0, 128, self.frame.size.height);
        self.messageView.frame = CGRectMake(128, 0, self.frame.size.width - 128, self.frame.size.height - kInputViewHeight);
        self.inputView.frame = CGRectMake(128, self.frame.size.height - kInputViewHeight, _messageView.frame.size.width, kInputViewHeight);
        self.contentView.frame = self.bounds;
        self.contentView.contentSize = self.bounds.size;
    }else if (UIDeviceOrientationIsPortrait(orientation)){
        self.peersTableView.frame = CGRectMake(0, 0, 128, self.frame.size.height - kInputViewHeight);
        self.messageView.frame = CGRectMake(128, 0, self.frame.size.width, self.frame.size.height - kInputViewHeight);
        self.inputView.frame = CGRectMake(0, self.frame.size.height - kInputViewHeight, self.frame.size.width, kInputViewHeight);
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kInputViewHeight);
        self.contentView.contentSize = CGSizeMake(_messageView.frame.origin.x+_messageView.frame.size.width, _messageView.frame.size.height);
    }
}

- (BOOL)resignFirstResponder
{
    return [self.inputView resignFirstResponder];
}

#pragma mark- 
- (void)setDelegate:(id<MPCViewActionDelegate>)delegate
{
    _delegate = delegate;
    self.inputView.delegate = delegate;
}

- (void)reloadPeersTable
{
    [self.peersTableView reloadData];
}

- (void)reloadHistory:(NSAttributedString *)attrStr
{
    [self.messageView setAttributedText:attrStr];
}

#pragma mark- UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? [[self.delegate peersNearby] count] : [[self.delegate peersConnected] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPCPeer *peer = indexPath.section ? [[self.delegate peersNearby] objectAtIndex:indexPath.row] : [[self.delegate peersConnected] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    cell.textLabel.text = peer.displayName;
    cell.detailTextLabel.text = peer.detailInfo;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section ? @"Nearbies" : @"connected";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPath.section ? [self.delegate connectToPeer:[[self.delegate peersNearby] objectAtIndex:indexPath.row]] : [self.delegate checkoutComunication:[[self.delegate peersConnected] objectAtIndex:indexPath.row]];
}
@end

@implementation MPCInputView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_voiceButton setTitle:@"语音" forState:UIControlStateNormal];
    [_voiceButton sizeToFit];
    [self addSubview:_voiceButton];
    
    self.inputField = [[UITextField alloc] init];
    _inputField.placeholder = @"说点什么吧！";
    _inputField.delegate = self;
    _inputField.returnKeyType = UIReturnKeySend;
    [self addSubview:_inputField];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_sendButton setTitle:@"取消" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton sizeToFit];
    [self addSubview:_sendButton];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    frame.size.height = MAX(kInputViewHeight, _inputField.frame.size.height);
    self.voiceButton.frame = CGRectMake(10,
                                        (self.frame.size.height-_voiceButton.frame.size.height)/2,
                                        _voiceButton.frame.size.width, _voiceButton.frame.size.height);
    self.sendButton.frame = CGRectMake(self.frame.size.width-10-_sendButton.frame.size.width,
                                       (self.frame.size.height-_sendButton.frame.size.height)/2,
                                       _sendButton.frame.size.width, _sendButton.frame.size.height);
    self.inputField.frame = CGRectMake(_voiceButton.frame.origin.x+_voiceButton.frame.size.width+5,
                                       (self.frame.size.height-_inputField.frame.size.height)/2,
                                       self.frame.size.width-30-_voiceButton.frame.size.width-_sendButton.frame.size.width,
                                       self.frame.size.height);
}

- (BOOL)resignFirstResponder
{
    return [self.inputField resignFirstResponder];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate sendMessage:textField.text];
    textField.text = nil;
    return NO;
}
@end

#define kSettingsViewWidth  280.0f
#define kSettingsViewPadding 10.0f

@interface MPCSettingsView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *settings;

@property (nonatomic, strong) NSString *serviceTypeRegex;
@property (nonatomic, strong) NSString *displayNameRegex;

@end

@implementation MPCSettingsView

- (id)initWithCurrentSettings:(NSDictionary *)settngs
{
    self.settings = [settngs mutableCopy];
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self defaultInit];
        
        self.serviceTypeRegex = @"[^a-z||0-9||-]+";
        self.displayNameRegex = _serviceTypeRegex;
        
        self.serviceTypeField.text = [_settings objectForKey:@"serviceType"];
        self.displayNameField.text = [_settings objectForKey:@"displayName"];
    }
    return self;
}

- (void)defaultInit
{
    CGFloat originY = kSettingsViewPadding;
    CGFloat width = kSettingsViewWidth-2*kSettingsViewPadding;
    self.serviceTypeField = [[UITextField alloc] initWithFrame:CGRectMake(kSettingsViewPadding, originY, width, 36)];
    _serviceTypeField.placeholder = @"Please input service type";
    _serviceTypeField.backgroundColor = [UIColor whiteColor];
    _serviceTypeField.delegate = self;
    [self addSubview:_serviceTypeField];
    
    originY += _serviceTypeField.frame.size.height;
    
    self.serviceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSettingsViewPadding, originY, width, 44)];
    _serviceTypeLabel.numberOfLines = 0;
    _serviceTypeLabel.font = [UIFont systemFontOfSize:13];
    _serviceTypeLabel.textColor = [UIColor lightGrayColor];
    _serviceTypeLabel.text = @"Must be 1–15 characters long\nCan contain only ASCII lowercase letters, numbers, and hyphens.";
    [_serviceTypeLabel sizeToFit];
    _serviceTypeLabel.frame = (CGRect){kSettingsViewPadding,originY,width,_serviceTypeLabel.frame.size.height};
    [self addSubview:_serviceTypeLabel];
    
    originY += _serviceTypeLabel.frame.size.height+kSettingsViewPadding;
    
    self.displayNameField = [[UITextField alloc] initWithFrame:CGRectMake(kSettingsViewPadding, originY, width, 36)];
    _displayNameField.placeholder = @"Please input display name";
    _displayNameField.delegate = self;
    _displayNameField.backgroundColor = [UIColor whiteColor];
    [self addSubview:_displayNameField];
    
    originY += _displayNameField.frame.size.height;
    
    self.displayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSettingsViewPadding, originY, width, 44)];
    _displayNameLabel.numberOfLines = 0;
    _displayNameLabel.font = [UIFont systemFontOfSize:13];
    _displayNameLabel.textColor = [UIColor lightGrayColor];
    _displayNameLabel.text = @"The display name is intended for use in UI elements, and should be short and descriptive of the local peer. The maximum allowable length is 63 bytes in UTF-8 encoding. The displayName parameter may not be nil or an empty string";
    [_displayNameLabel sizeToFit];
    _displayNameLabel.frame = (CGRect){kSettingsViewPadding,originY,width,_displayNameLabel.frame.size.height};
    [self addSubview:_displayNameLabel];
    
    originY += _displayNameLabel.frame.size.height+kSettingsViewPadding;
    
    // button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    _cancelButton.frame = (CGRect){kSettingsViewPadding,originY,(kSettingsViewWidth-3*kSettingsViewPadding)/2,36};
    [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    self.activeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_activeButton setTitle:@"Active" forState:UIControlStateNormal];
    [_activeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _activeButton.frame = (CGRect){kSettingsViewWidth-kSettingsViewPadding-_cancelButton.frame.size.width, originY,_cancelButton.frame.size.width, 36};
    [self addSubview:_activeButton];
    
    originY += _cancelButton.frame.size.height+kSettingsViewPadding;
    
    self.frame = CGRectMake(0, 0, kSettingsViewWidth, originY);
}

#pragma mark- action and delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    if (textField == _serviceTypeField) {
        if ([string rangeOfString:_serviceTypeRegex options:NSRegularExpressionSearch].location != NSNotFound || textField.text.length >= 15) {
            return NO;
        }
    }else{
        if ([string rangeOfString:_displayNameRegex options:NSRegularExpressionSearch].location != NSNotFound || textField.text.length >= 7) {
            return NO;
        }
    }
    return YES;
}

- (void)buttonAction:(UIButton *)sender
{
    [self.delegate settingsChanged:sender != _activeButton ? nil : @{@"serviceType":_serviceTypeField.text ? _serviceTypeField.text : @"",@"displayName":_displayNameField.text ? _displayNameField.text : @""}];
}
@end