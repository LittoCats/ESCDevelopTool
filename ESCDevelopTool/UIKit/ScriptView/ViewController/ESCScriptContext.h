//
//  ESCScriptContext.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/14/15.
//
//

#import <Foundation/Foundation.h>

@protocol ESCScriptContext <NSObject>

@required

/**
 *  selector 参数，只能是 NSString NSNumber NSArray NSDictionary NSDate id<ESCScriptFunction> 类型，返加值只能是 NSString NSNumber NSArray NSDictionary NSDate NSBlock(参数同返回值同此说明)
 */
- (void)addCallback:(NSString *)callback withTarget:(id)target selector:(SEL)selector;

- (id)runScript:(NSString *)script;

@end

@protocol ESCScriptFunction <NSObject>

@required
- (void)callcallWithArguments:(NSArray *)arguments;

@end