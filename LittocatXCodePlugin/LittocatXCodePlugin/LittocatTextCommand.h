//
//  LittocatTextCommand.h
//  LittocatXcodePlugin
//
//  Created by 程巍巍 on 12/27/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import "LittocatBaseCommand.h"

@interface LittocatTextCommand : NSObject

@property (nonatomic, strong) NSTextView    *textView;

/**
 *  @{@"location":#{location},@"length":#{length}}
 */
@property (nonatomic, readonly) NSDictionary *sel;

@property (nonatomic, readonly) NSString *text;

@property (nonatomic, readonly) BOOL (^insert)(NSString *text, NSInteger location);

@property (nonatomic, readonly) BOOL (^replace)(NSString *srcText, NSString *desText);

@property (nonatomic, readonly) NSString *filePath;
@end
