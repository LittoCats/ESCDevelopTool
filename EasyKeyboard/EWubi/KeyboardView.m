//
//  KeyboardView.m
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/20/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import "KeyboardView.h"

#import "EKeyboardDelegate.h"

@implementation EKeyboardView
{
    BOOL fnOn;
    BOOL upCaseOn;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        NSData *settingData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"easy_keyboard_main" ofType:@"json"]];
        if (!settingData || settingData.length == 0) {
            [NSException raise:@"Easy keyboard settings file missed ..." format:nil];
        }
        
        self.settings = [NSJSONSerialization JSONObjectWithData:settingData options:0 error:nil];
        self.keyButtons = [NSPointerArray weakObjectsPointerArray];
        
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    NSArray *buttonLayouts = _settings[@"layout"];
    NSMutableArray *lineArray = [NSMutableArray arrayWithCapacity:buttonLayouts.count];
    for (NSArray *lineSetting in buttonLayouts) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:lineSetting.count];
        for (NSDictionary *setting in lineSetting) {
            EKeyboardButton *button = [EKeyboardButton buttonWithTarget:self userInfo:setting];
            [self addSubview:button];
            [array addObject:button];
        }
        [lineArray addObject:[NSArray arrayWithArray:array]];
    }
    self.lines = [NSArray arrayWithArray:lineArray];
}

- (void)setFrame:(CGRect)frame
{
    BOOL needLayoutSubview = fabsf(frame.size.width-self.frame.size.width) > 1.0 || fabsf(frame.size.height-self.frame.size.height) > 1.0;
    [super setFrame:frame];
    if (needLayoutSubview)[self layoutSubviews];
}

- (void)layoutSubviews
{
    CGRect rect = CGRectZero;
    CGFloat iWidth = self.frame.size.width;
    CGFloat iHeight = self.frame.size.height;
    rect.size.height = iHeight/_lines.count - 5.0;
    rect.origin.y = 2.5;
    for (NSArray *line in _lines) {
        rect.origin.x = 2.5;
        for (EKeyboardButton *button in line) {
            rect.size.width = iWidth* [button.userInfo[@"width"] floatValue] - 5.0;
            button.frame = rect;
            rect.origin.x += button.frame.size.width + 5.0;
        }
        rect.origin.y += rect.size.height + 5.0;
    }
}

#pragma mark- function button
- (void)preInitFNButton:(EKeyboardButton *)button
{
    NSString *fn = button.userInfo[@"fn"];
    if ([fn isEqualToString:@"back"]) {
        [button addTarget:self action:@selector(deleteCharater:) forControlEvents:UIControlEventTouchUpInside];
    }else if([fn isEqualToString:@"fn"]) {
        [button addTarget:self action:@selector(changeCaseMode:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(fnOn:) forControlEvents:UIControlEventTouchDown];
    }else if([fn isEqualToString:@".?123"] || [fn isEqualToString:@"emo"]) {
        [button addTarget:self action:@selector(changeKeyboardMap:) forControlEvents:UIControlEventTouchUpInside];
    }else if([fn isEqualToString:@"globe"]) {
        [button addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    }else if([fn isEqualToString:@"space"] || [fn isEqualToString:@"space"]) {
        [button addTarget:self action:@selector(activeValue:) forControlEvents:UIControlEventTouchUpInside];
    }else if([fn isEqualToString:@"return"]) {
        [button addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([fn isEqualToString:@"next_map"] || [fn isEqualToString:@"previous_map"]){
        [button addTarget:self action:@selector(moveCursor:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([fn isEqualToString:@"hide"]){
        [button addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([fn isEqualToString:@"moveCursor"]){
        [button addTarget:self action:@selector(moveCursor:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)preInitButton:(EKeyboardButton *)button
{
    // update action
    [button addTarget:self action:@selector(clickKeyButton:) forControlEvents:UIControlEventTouchUpInside];
    [button addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:button action:@selector(longPress:)]];
    [self.keyButtons addPointer:(__bridge void *)(button)];
}

#pragma mark- action
- (void)deleteCharater:(EKeyboardButton *)sender
{
    if (fnOn) {
        [self.delegate moveCursor:YES];
    }
    [self.delegate deleteBackward];
}

- (void)changeCaseMode:(EKeyboardButton *)sender
{
    fnOn = NO;
    NSArray *buttons = [self.keyButtons allObjects];
    if (upCaseOn) {
        for (EKeyboardButton *button in buttons) {
            [button setTitle:[[button currentTitle] lowercaseString] forState:UIControlStateNormal];
        }
        upCaseOn = NO;
    }else{
        for (EKeyboardButton *button in buttons) {
            [button setTitle:[[button currentTitle] uppercaseString] forState:UIControlStateNormal];
        }
        upCaseOn = YES;
    }
    
}

- (void)fnOn:(EKeyboardButton *)sender
{
    fnOn = YES;
}

- (void)changeKeyboardMap:(EKeyboardButton *)sender
{
    // 切换 字符映射表
}

- (void)activeValue:(EKeyboardButton *)sender
{
    // 空格 或 enter 键按下
    [self clickKeyButton:sender];
}

- (void)moveCursor:(EKeyboardButton *)sender
{
    // 当存在上一、下一 keymap 时（例如 符号界面），则切换 keymap,否则移动光标
    const char direction = sender.keyValue.UTF8String[0];
    [self.delegate moveCursor:(direction == '>')];
}

- (void)returnAction:(EKeyboardButton *)sender
{

    // return key press
}

- (void)advanceToNextInputMode
{
    [self.delegate advanceToNextInputMode];
}

- (void)hideKeyboard:(EKeyboardButton *)sender
{
    [self.delegate dismissKeyboard];
}

- (void)clickKeyButton:(EKeyboardButton *)sender
{
    NSString *value = fnOn ? sender.fnLabel.text : sender.keyValue;
    NSLog(@"%@",value);
    
    value && value.length ? [self.delegate insertText:value] : nil;
}

- (void)longPress:(EKeyboardButton *)sender
{
    __weak typeof(sender) wsender = sender;
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(wsender) ssender = wsender; if (!ssender) return ;
        __strong typeof(wself) sself = wself; if (!sself) return;
        if (ssender.state != UIControlStateNormal)
            [sself clickKeyButton:ssender];
    });
}
@end

@implementation EKeyboardButton

+ (instancetype)buttonWithTarget:(id)target userInfo:(NSDictionary *)userInfo
{
    EKeyboardButton *button = [self buttonWithType:UIButtonTypeSystem];
    button.target = target;
    button.userInfo = userInfo;
    return button;
}

+ (id)buttonWithType:(UIButtonType)buttonType
{
    EKeyboardButton *button = [super buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:23];
    button.titleLabel.numberOfLines = 0;
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.cornerRadius = 10;
        
        self.fnLabel = [[UILabel alloc] init];
        [self.fnLabel sizeToFit];
        [self addSubview:_fnLabel];
    }
    return self;
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
    [self setTitle:userInfo[@"title"] forState:UIControlStateNormal];
    [self setFnTitle:userInfo[@"fnTitle"]];
//    self.exclusiveTouch = ![userInfo[@"exclusive"] boolValue];
    self.keyValue = userInfo[@"value"];
    
    [self removeTarget:self.target action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self removeGestureRecognizer:[self.gestureRecognizers lastObject]];
    
    if (userInfo[@"fn"]) {
        [self.target preInitFNButton:self];
    }else{
        [self.target preInitButton:self];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)lpgr
{
    [self.target longPress:self];
}

- (void)setKeyValue:(NSString *)keyValue
{
    _keyValue = !keyValue || keyValue.length == 0 ? self.titleLabel.text : keyValue;
}

#pragma mark- override
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    self.keyValue = title;
    self.backgroundColor = title && title.length ? [UIColor darkGrayColor] : [UIColor clearColor];
}

- (void)setFnTitle:(NSString *)title
{
    self.fnLabel.text = title;
    [_fnLabel sizeToFit];
    [self layoutSubviews];
}

#pragma mark- layout
- (void)setFrame:(CGRect)frame
{
    BOOL needLayoutSubview = fabsf(frame.size.width-self.frame.size.width) > 1.0 || fabsf(frame.size.height-self.frame.size.height) > 1.0;
    [super setFrame:frame];
    if (needLayoutSubview)[self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.fnLabel.frame = CGRectMake(self.frame.size.width-_fnLabel.frame.size.width-10, 5, _fnLabel.frame.size.width, _fnLabel.frame.size.height);
}
@end
