//
//  ESCJSContext.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/5/14.
//
//  Require JavaScriptCore.framework

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class JSContext;
@interface ESCJSContext : NSObject

+ (instancetype)context;


/**
 *  @property   NSString NSDictionary NSArray NSNumber NSDate NSBlock(参数及返回值类型必须是 property 支持的类型)
 */
- (BOOL)addProperty:(id)property withName:(NSString *)name;
- (BOOL)removePropertyWithName:(NSString *)name;
- (id)propertyWithName:(NSString *)name;

- (id)evaluateScript:(NSString *)jscript;

- (id)callFunction:(NSString *)function withArguments:(NSArray *)arguments;

@end

@interface ESCJSFunction : NSObject

- (id)evaluateWithArguments:(id)arg, ... NS_REQUIRES_NIL_TERMINATION;

@end