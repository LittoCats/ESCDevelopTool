//
//  ESCInternationalManager.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/20/14.
//  Copyright (c) 12/19/14 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESCInternationalManager;
@protocol ESCInternationalManagerDelegate <NSObject>

@required
+ (void)intermationalManager:(ESCInternationalManager *)manager didChangeLocal:(NSLocale *)newLocal;

@end

@interface ESCInternationalManager : NSObject

+ (NSString *)internationalString:(NSString *)international withComment:(NSString *)comment;

+ (void)registeDelegate:(id<ESCInternationalManagerDelegate>)delegate;

@end

