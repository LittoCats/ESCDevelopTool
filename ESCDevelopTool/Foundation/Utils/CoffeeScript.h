//
//  CoffeeScript.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/7/15.
//
//

#import <Foundation/Foundation.h>


@protocol CoffeeScriptProtocol <NSObject> 

@property (nonatomic, readonly) NSString *(^compile)(NSString *coffee);

@property (nonatomic, readonly) NSString *(^eval)(NSString *coffee);

@end

FOUNDATION_EXTERN id<CoffeeScriptProtocol> CoffeeScript;