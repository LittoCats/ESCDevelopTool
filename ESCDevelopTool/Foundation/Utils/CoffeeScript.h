//
//  CoffeeScript.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/7/15.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN const struct {
    NSString* (*compile)(NSString *cource, BOOL bare);
//    id<NSObject> (*eval)(NSString *cource, NSArray *arguments);
} CoffeeScript;