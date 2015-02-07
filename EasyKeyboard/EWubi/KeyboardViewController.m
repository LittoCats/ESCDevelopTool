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

#import "FreeImeDB.h"
#import "FreePinYin.h"
#import "FreeWuBi.h"
#import "Hans.h"


@interface KeyboardViewController ()<EKeyboardDelegate,CandidateDelegate>

/**
 *  候选词列表
 */
@property (nonatomic, strong) NSArray *hanList;
/**
 *  输入缓冲
 */
@property (nonatomic, strong) NSMutableString *iBuffer;

@property (nonatomic, strong) EKeyboardView *view;

@end

@implementation KeyboardViewController
{
}

- (void)loadView
{
    self.view = [[EKeyboardView alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard];
    self.view.clipsToBounds = NO;
    ((EKeyboardView *)self.view).delegate = self;
}

- (void)viewDidLoad
{
    CandidateView *candidateView = [[CandidateView alloc] init];
    candidateView.delegate = self;
    ((EKeyboardView *)self.view).candidateView = candidateView;
    
    self.iBuffer = [NSMutableString new];
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

- (void)pushBuffer:(NSString *)cs
{
    [self.iBuffer appendString:cs];
    self.hanList = [[FreeImeDB db] hansForKey:_iBuffer type:FreeImeDBKeyTypeWubi];
    if (self.hanList.count == 1 || _iBuffer.length == 4) {
        Hans *han = [(id<FreeIMETableProtocol>)[self.hanList firstObject] value];
        [self flushBuffer:han];
    }
    [self.view.candidateView reloadData:_hanList];
}

- (void)flushBuffer:(Hans *)han
{
    [self.iBuffer deleteCharactersInRange:NSMakeRange(0, _iBuffer.length)];
    self.hanList = nil;
    [self.view.candidateView reloadData:_hanList];
    if (han) {
        [self.textDocumentProxy insertText:han.value];
        han.frequency = @([han.frequency integerValue] + 1);
        [han.managedObjectContext save:nil];
    }
}

#pragma mark- keyboard core
- (void)insertText:(NSString *)cs
{
    char c = [[cs lowercaseString] characterAtIndex:0];
    if (c > 'a' || c < 'z' ) {
        [self pushBuffer:cs];
    }else{
        [self flushBuffer:nil];
        [self.textDocumentProxy insertText:cs];
    }
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

#pragma mark- CandidateDelegate
- (void)candidateView:(CandidateView *)view didSelectHan:(Hans *)han
{
    [self flushBuffer:han];
}
@end
