//
//  KeyboardViewController.m
//  EWubi
//
//  Created by 程巍巍 on 1/20/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import "KeyboardViewController.h"

#import "EKeyboardDelegate.h"

#import "KeyboardView.h"


@interface KeyboardViewController ()<EKeyboardDelegate>

@end

@implementation KeyboardViewController
{
}

- (void)loadView
{
    self.view = [[EKeyboardView alloc] init];
    ((EKeyboardView *)self.view).delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
}

#pragma mark- keyboard core
- (void)insertText:(NSString *)cs
{
    [self.textDocumentProxy insertText:cs];
}

- (void)deleteBackward
{
    // 删除上一下/下一个字符
    [self.textDocumentProxy deleteBackward];
}
- (void)moveCursor:(BOOL)next
{
    [self.textDocumentProxy adjustTextPositionByCharacterOffset:next ? 1 : -1];
}
@end
