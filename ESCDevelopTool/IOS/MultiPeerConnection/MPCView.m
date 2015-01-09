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
    indexPath.section ? [self.delegate connectSession:[[self.delegate peersNearby] objectAtIndex:indexPath.row]] : [self.delegate checkoutComunication:[[self.delegate peersConnected] objectAtIndex:indexPath.row]];
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