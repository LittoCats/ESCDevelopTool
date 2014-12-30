//
//  LittocatBaseCommand.h
//  LittocatXcodePlugin
//
//  Created by 程巍巍 on 12/27/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LittocatBaseCommand : NSObject

@property (nonatomic, readonly) BOOL (^writeToFile)(NSString *text, NSString *filePath, NSInteger offset);

@property (nonatomic, readonly) BOOL (^readFile)(NSString *filePath, NSInteger offset);

@end
