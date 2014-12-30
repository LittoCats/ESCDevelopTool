//
//  Littocat XCode Plugin.h
//  Littocat XCode Plugin
//
//  Created by 程巍巍 on 12/26/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LittocatXCodePlugin : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end