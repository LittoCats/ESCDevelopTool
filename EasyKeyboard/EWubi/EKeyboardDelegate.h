//
//  EKeyboardDelegate.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/21/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EKeyboardDelegate <NSObject>

@required
- (void)deleteBackward;
- (void)moveCursor:(BOOL)next; // YES 将光标后移一位
- (void)advanceToNextInputMode;
- (void)dismissKeyboard;
- (void)insertText:(NSString *)value;

@end
