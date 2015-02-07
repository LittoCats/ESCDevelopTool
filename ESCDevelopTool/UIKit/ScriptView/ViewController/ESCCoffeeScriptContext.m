//
//  ESCCoffeeScriptContext.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/14/15.
//
//

#import "ESCCoffeeScriptContext.h"
#import "CoffeeScript.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import <objc/runtime.h>

static BOOL kSigHasReturnValue(NSMethodSignature *sig){
    const char *returnType = [sig methodReturnType];
    return returnType[0] == _C_ID ? YES : NO;
}
static void kResetInvocation(NSInvocation *invo){
    NSMethodSignature *sig = invo.methodSignature;
    NSInteger argCount = [sig numberOfArguments];
    for (int i = 2; i < argCount; i ++) {
        [invo setArgument:(__bridge void *)(NSNull.null) atIndex:i];
    }
    [invo setTarget:nil];
}

static NSInvocation *kCreateInvocation(id target, SEL selector){
    
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    NSInteger argCount = [sig numberOfArguments];
    for (int i = 2; i < argCount; i ++) {
        const char *argType = [sig getArgumentTypeAtIndex:i];
        if (argType[0] != _C_ID) return nil;
    }
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setSelector:selector];
    kResetInvocation(invo);
    return invo;
}


@interface ESCCoffeeScriptContext ()

@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) NSCache *invoCache;

@end

@implementation ESCCoffeeScriptContext

- (id)init
{
    if (self = [super init]) {
        self.context = [[JSContext alloc] init];
        self.invoCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)addCallback:(NSString *)callback withTarget:(id)target selector:(SEL)selector
{
    if (!callback || ![callback isKindOfClass:NSString.class] || callback.length == 0 || !target || !selector)
        return;
    
    NSString *sel = NSStringFromSelector(selector);
    
    if (![target respondsToSelector:selector]) [NSException raise:@"ESCCoffeeScriptContext : target must responds to selector" format:@"target < %@ >, target < %@ >",target, sel];
    
    
    __weak typeof(target) wtarget = target;
    __weak typeof(self) wself = self;
    _context[callback] = ^id{
        __strong typeof(wtarget) starget = wtarget; if (!starget) return nil;
        __strong typeof(wself) sself = wself; if (!sself) return nil;
        
        NSArray *args = [JSContext currentArguments];
        
        NSString *identifier = [NSString stringWithFormat:@"%p_%@",target, sel];
        NSInvocation *invo = [sself.invoCache objectForKey:identifier];
        if (!invo) {
            invo = kCreateInvocation(starget, selector);
            if (invo) [sself.invoCache setObject:invo forKey:identifier];
            else return nil;
        }
        
        NSInteger argCount = [invo.methodSignature numberOfArguments];
        for (int i = 0; i < MIN(args.count, argCount-2); i ++) {
            id arg = [args objectAtIndex:i];
            [invo setArgument:&arg atIndex:i+2];
        }
        [invo setTarget:starget];
        [invo retainArguments];
        [invo invoke];
        
        kResetInvocation(invo);
        
        if (kSigHasReturnValue(invo.methodSignature)) {
            id ret;
            [invo getReturnValue:&ret];
            return ret;
        }
        return nil;
    };
}

- (id)runScript:(NSString *)script
{
    return [self.context evaluateScript:CoffeeScript.compile(script, NO)];
}

@end
