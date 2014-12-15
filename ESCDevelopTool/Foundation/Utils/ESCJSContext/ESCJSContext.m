//
//  ESCJSContext.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/5/14.
//
//

#import "ESCJSContext_Prevate.h"

@implementation ESCJSContext

+ (instancetype)context
{
    return [[self alloc] init];
}

- (BOOL)addProperty:(id)property withName:(NSString *)name
{
    JSStringRef jsName = JSStringCreateWithCFString((__bridge CFStringRef)(name));
    JSObjectRef jsProperty = NULL;
    
    if ([property isKindOfClass:NSClassFromString(@"NSBlock")]) {
        jsProperty = JSObjectMakeFunctionWithCallback(_ctx, jsName, kECSJSContextChannel);
        [self.blockTable setObject:[ESCJSFunctionCallback callbackWithNSBlock:property] forKey:kESCJSFunctionNameWithJSObjectRef(jsProperty)];
    }else{
        jsProperty = JSValueToObject(_ctx, [self JSValueWithNSObject:property], NULL) ;
    }
    
    JSValueRef exception = NULL;
    JSObjectSetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, jsProperty, kJSPropertyAttributeNone, &exception);
    JSStringRelease(jsName);
    return [self handleException:exception];;
}
- (BOOL)removePropertyWithName:(NSString *)name
{
    JSStringRef jsName = JSStringCreateWithCFString((__bridge CFStringRef)(name));
    JSValueRef exception = NULL;
    JSObjectDeleteProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, &exception);
    JSStringRelease(jsName);
    return [self handleException:exception];
}
- (id)propertyWithName:(NSString *)name
{
    JSValueRef exception = NULL;
    JSValueRef jsProperty = kESCJSObjectGetProperty(_ctx, JSContextGetGlobalObject(_ctx), name, &exception);
    return [self handleException:exception] ? [self NSObjectWithJSValue:jsProperty] : nil;
}

- (id)evaluateScript:(NSString *)jscript
{
    JSValueRef exception = NULL;
    JSStringRef jScript = JSStringCreateWithCFString((__bridge CFStringRef)(jscript));
    JSValueRef result = JSEvaluateScript(_ctx, jScript, NULL, NULL, 0, &exception);
    JSStringRelease(jScript);
    return [self handleException:exception] ? [self NSObjectWithJSValue:result] : nil;
}

- (id)callFunction:(NSString *)function withArguments:(NSArray *)arguments
{
    JSStringRef jsName = JSStringCreateWithCFString((__bridge CFStringRef)(function));
    JSValueRef exception = NULL;
    JSValueRef jsProperty = JSObjectGetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, &exception);
    
    JSStringRelease(jsName);
    
    JSValueRef jsValue = NULL;
    if (!exception) {
        JSObjectRef jsFunction = JSValueToObject(_ctx, jsProperty, &exception);
        if (!exception && JSObjectIsFunction(_ctx, jsFunction)) {
            jsValue = kESCContextEvaluateFunction(self, jsFunction, arguments, &exception);
        }
    }
    
    return [self handleException:exception] ? [self NSObjectWithJSValue:jsValue] : nil;
}

#pragma mark- 初始化及对像管理
- (id)init
{
    if (self = [super init]) {
        self.ctx = JSGlobalContextCreate(NULL);
        self.name = kESCJSContextNameWithJSContextRef(_ctx);
        self.blockTable = [NSMapTable strongToStrongObjectsMapTable];
        [kESCJSContextTable() setObject:self forKey:_name];
    }
    return self;
}

- (void)dealloc
{
    JSGlobalContextRelease(self.ctx);
}

static JSValueRef kECSJSContextChannel(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception)
{
    JSGlobalContextRef globalContext = JSContextGetGlobalContext(ctx);
    NSString *name = kESCJSContextNameWithJSContextRef(globalContext);
    ESCJSContext *context = [kESCJSContextTable() objectForKey:name];
    
    ESCJSFunctionCallback *functionCallback = [context.blockTable objectForKey:kESCJSFunctionNameWithJSObjectRef(function)];
    
    NSMutableArray *parameters = [NSMutableArray new];
    NSInteger numberOfArguments = MIN(argumentCount, [[functionCallback methodSignature] numberOfArguments]);
    for (NSInteger i = 0; i < numberOfArguments; i ++) {
        [parameters addObject:[context NSObjectWithJSValue:arguments[i]]];
    }
    
    id ret = [functionCallback evaluateWithArguments:parameters];
    
    return [context JSValueWithNSObject:ret];
}

// exception 不存在，则返回 YES
- (BOOL)handleException:(JSValueRef)exception
{
    if (!exception) return YES;
    NSString *exceptionDescription = [self NSStringWithJSValue:exception];
    id excetionDetail = [self NSObjectWithJSValue:exception];
    
    NSLog(@"%@\n%@",exceptionDescription,excetionDetail);
    return NO;
}

#pragma mark- 静态表
static NSMapTable *kESCJSContextTable(){
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable strongToWeakObjectsMapTable];
    });
    return table;
}

static NSString *kESCJSContextNameWithJSContextRef(JSContextRef ctx){
    return [NSString stringWithFormat:@"ESCJSContext_%p",ctx];
}
static NSString *kESCJSFunctionNameWithJSObjectRef(JSObjectRef function){
    return [NSString stringWithFormat:@"ESCJSFunction_%p",function];
}

static JSValueRef kESCJSObjectGetProperty(JSContextRef ctx, JSObjectRef jsObj, NSString *name, JSValueRef *exception){
    JSStringRef jsName = JSStringCreateWithCFString((__bridge CFStringRef)(name));
    JSValueRef jsValue = JSObjectGetProperty(ctx, JSContextGetGlobalObject(ctx), jsName, exception);
    JSStringRelease(jsName);
    return jsValue;
}

static JSObjectRef kESCContextGetConstructor(JSContextRef ctx, char *name, JSValueRef *exception){
    JSStringRef constructorName = JSStringCreateWithUTF8CString(name);
    JSObjectRef constructor = (JSObjectRef)JSObjectGetProperty(ctx, JSContextGetGlobalObject(ctx), constructorName, exception);
    JSStringRelease(constructorName);
    return constructor;
}

static JSValueRef kESCContextEvaluateFunction(ESCJSContext *context, JSObjectRef function, NSArray *arguments, JSValueRef *exception){
    JSValueRef jsValue = NULL;
    
    JSValueRef *jsArgs = malloc(sizeof(JSValueRef) * arguments.count);
    for (int i = 0; i < arguments.count; i ++) {
        jsArgs[i] = [context JSValueWithNSObject:arguments[i]];
    }
    jsValue = JSObjectCallAsFunction(context.ctx, function, NULL, arguments.count, jsArgs, exception);
    
    free(jsArgs);
    
    
    return jsValue;
}
#pragma mark- 类型转换
#pragma mark- NSObject to JSValue
- (JSValueRef)JSValueWithNSObject:(id)obj
{
    JSValueRef ret = NULL;
    
    // String
    if( [obj isKindOfClass:NSString.class])
        ret = [self JSValueWithNSString:obj];
    
    // Number or Bool
    else if( [obj isKindOfClass:NSNumber.class] ) {
        NSNumber *number = (NSNumber *)obj;
        if( strcmp(number.objCType, @encode(BOOL)) == 0 ) {
            ret = JSValueMakeBoolean(_ctx, number.boolValue);
        }
        else {
            ret = JSValueMakeNumber(_ctx, number.doubleValue);
        }
    }
    
    // Array
    else if( [obj isKindOfClass:NSArray.class] ) {
        NSArray *array = (NSArray *)obj;
        JSValueRef *args = malloc(array.count * sizeof(JSValueRef));
        for( int i = 0; i < array.count; i++ ) {
            args[i] = [self JSValueWithNSObject:array[i]];
        }
        ret = JSObjectMakeArray(_ctx, array.count, args, NULL);
        free(args);
    }
    
    // Dictionary
    else if( [obj isKindOfClass:NSDictionary.class] ) {
        NSDictionary *dict = (NSDictionary *)obj;
        ret = JSObjectMake(_ctx, NULL, NULL);
        for( NSString *key in dict ) {
            JSStringRef jsKey = JSStringCreateWithUTF8CString(key.UTF8String);
            JSValueRef value = [self JSValueWithNSObject:dict[key]];
            JSObjectSetProperty(_ctx, (JSObjectRef)ret, jsKey, value, kJSPropertyAttributeNone, NULL);
            JSStringRelease(jsKey);
        }
    }
    
    // Block
    else if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]){
        ret = JSObjectMakeFunctionWithCallback(_ctx, NULL, kECSJSContextChannel);
        [self.blockTable setObject:[ESCJSFunctionCallback callbackWithNSBlock:obj] forKey:kESCJSFunctionNameWithJSObjectRef((JSObjectRef)ret)];
    }
    
    // Date
    else if( [obj isKindOfClass:NSDate.class] ) {
        NSDate *date = (NSDate *)obj;
        JSValueRef timestamp = JSValueMakeNumber(_ctx, date.timeIntervalSince1970 * 1000.0);
        ret = JSObjectMakeDate(_ctx, 1, &timestamp, NULL);
    }
    
    //NSValue
    else if ([obj isKindOfClass:NSValue.class]){
        const char *type = [obj objCType];
        NSDictionary *objc;
        if (strcmp(type, @encode(CGSize)) == 0) {
            CGSize size;
            [obj getValue:&size];
            objc = @{@"width":@(size.width),@"height":@(size.height)};
        }else if (strcmp(type, @encode(CGPoint)) == 0){
            CGPoint point;
            [obj getValue:&point];
            objc = @{@"x":@(point.x),@"y":@(point.x)};
        }else if (strcmp(type, @encode(CGRect)) == 0){
            CGRect rect;
            [obj getValue:&rect];
            objc = @{@"origin":@{@"x": @(rect.origin.x),@"y":@(rect.origin.y)},@"size":@{@"width":@(rect.size.width),@"height":@(rect.size.height)}};
        }
        
#ifdef UIKIT_EXTERN
        else if (strcmp(type, @encode(UIOffset)) == 0){
            UIOffset offset = [obj UIOffsetValue];
            objc = @{@"vertical":@(offset.vertical),@"horizontal":@(offset.horizontal)};
        }else if (strcmp(type, @encode(UIEdgeInsets)) == 0){
            UIEdgeInsets edgeInsets;
            [obj getValue:&edgeInsets];
            objc = @{@"top":@(edgeInsets.top),@"left":@(edgeInsets.left),@"right":@(edgeInsets.right),@"bottom":@(edgeInsets.bottom)};
        }
#endif
        ret = [self JSValueWithNSObject:objc];
    }
    
    //UIColor 返回 hex string
#ifdef UIKIT_EXTERN
    else if ([obj isKindOfClass:UIColor.class]){
        CGFloat red,green,blue,alpha;
        [obj getRed:&red green:&green blue:&blue alpha:&alpha];
        ret = [self JSValueFromNSString:[[NSString alloc] initWithFormat:@"#%.2X%.2X%.2X%.2X",(int)(red*255),(int)(green*255),(int)(blue*255),(int)(alpha*255)]];
    }
#endif
    
    return ret ? ret : JSValueMakeNull(_ctx);
}

- (JSValueRef)JSValueWithNSString:(NSString *)string
{
    JSStringRef jstr = JSStringCreateWithCFString((__bridge CFStringRef)string);
    JSValueRef ret = JSValueMakeString(_ctx, jstr);
    JSStringRelease(jstr);
    return ret;
}

#pragma mark- JSValue to NSObject
- (id)NSObjectWithJSValue:(JSValueRef)jsvalue
{
    JSType type = JSValueGetType(_ctx, jsvalue);
    
    switch( type ) {
        case kJSTypeString: return [self NSStringWithJSValue:jsvalue];
        case kJSTypeBoolean: return [NSNumber numberWithBool:JSValueToBoolean(_ctx, jsvalue)];
        case kJSTypeNumber: return [NSNumber numberWithDouble:JSValueToNumber(_ctx, jsvalue, NULL)];
        case kJSTypeNull: return NSNull.null;
        case kJSTypeUndefined: return nil;
        case kJSTypeObject: break;
    }
    
    if( type == kJSTypeObject ) {
        JSObjectRef jsObj = JSValueToObject(_ctx, jsvalue, NULL);
        
        //if object is an Function
        if (JSObjectIsFunction(_ctx, jsObj)) {
            return [[ESCJSFunction alloc] initWithContext:self function:jsObj];
        }else if( JSValueIsInstanceOfConstructor(_ctx, jsObj, kESCContextGetConstructor(_ctx, "Array", NULL), NULL) ){
            // Array
            JSStringRef lengthName = JSStringCreateWithUTF8CString("length");
            int count = JSValueToNumber(_ctx, JSObjectGetProperty(_ctx, jsObj, lengthName, NULL), NULL);
            JSStringRelease(lengthName);
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
            for( int i = 0; i < count; i++ ) {
                NSObject *obj = [self NSObjectWithJSValue:JSObjectGetPropertyAtIndex(_ctx, jsObj, i, NULL)];
                [array addObject:(obj ? obj : NSNull.null)];
            }
            return array;
        }else if( JSValueIsInstanceOfConstructor(_ctx, jsObj, kESCContextGetConstructor(_ctx, "Date", NULL), NULL) ){
            JSStringRef getTimeName = JSStringCreateWithUTF8CString("getTime");
            NSTimeInterval timeInteral = JSValueToNumber(_ctx, JSObjectCallAsFunction(_ctx, (JSObjectRef)JSObjectGetProperty(_ctx, jsObj, getTimeName, NULL), jsObj, 0, NULL, NULL), NULL);
            JSStringRelease(getTimeName);
            return [[NSDate alloc] initWithTimeIntervalSince1970:timeInteral/1000];
        }else {
            // Plain Object
            JSPropertyNameArrayRef properties = JSObjectCopyPropertyNames(_ctx, jsObj);
            size_t count = JSPropertyNameArrayGetCount(properties);
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
            for( size_t i = 0; i < count; i++ ) {
                JSStringRef jsName = JSPropertyNameArrayGetNameAtIndex(properties, i);
                NSObject *obj = [self NSObjectWithJSValue:JSObjectGetProperty(_ctx, jsObj, jsName, NULL)];
                
                NSString *name = (__bridge_transfer NSString *)JSStringCopyCFString( kCFAllocatorDefault, jsName );
                dict[name] = obj ? obj : NSNull.null;
            }
            
            JSPropertyNameArrayRelease(properties);
            return dict;
        }
    }
    return nil;
}

- (NSString *)NSStringWithJSValue:(JSValueRef)jsvalue
{
    JSStringRef jsString = JSValueToStringCopy( _ctx, jsvalue, NULL );
    if( !jsString ) return nil;
    
    NSString *string = (__bridge_transfer NSString *)JSStringCopyCFString( kCFAllocatorDefault, jsString );
    JSStringRelease( jsString );
    
    return string;
}
@end


@implementation ESCJSFunction

- (id)evaluateWithArguments:(id)arg, ...
{
    NSMutableArray *arguments = [NSMutableArray new];
    
    id argument = arg;
    va_list vl;
    va_start(vl, arg);
    while (argument) {
        [arguments addObject:argument];
        argument = va_arg(vl, id);
    }
    va_end(vl);
    
    JSValueRef excpetion;
    JSValueRef result = kESCContextEvaluateFunction(_context, _func, arguments, &excpetion);
    return [_context handleException:excpetion] ? [_context NSObjectWithJSValue:result] : nil;
}

#pragma mark- 初始化及对像管理
- (id)initWithContext:(ESCJSContext *)context function:(JSObjectRef)function
{
    if (self = [super init]) {
        self.context = context;
        self.func = function;
        
        // pretect value
        JSValueProtect(context.ctx, function);
    }
    return self;
}

- (void)dealloc
{
    if (_context) return;
    JSValueUnprotect(_context.ctx, _func);
}
@end

#pragma mark-
#pragma mark-

@implementation ESCJSFunctionCallback

+ (id)callbackWithNSBlock:(id)blockObj
{
    const char *blocksig = kECSGetBlockSignature(blockObj);
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:blocksig];
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:signature];
    [invo setTarget:blockObj];
    object_setClass(invo, self);
    return invo;
}

- (id)evaluateWithArguments:(NSArray *)arguments
{
    // 设置参数
    NSInteger numberOfArguments = [[self methodSignature] numberOfArguments] - 1;
    NSInteger iMAX = MIN(arguments.count, numberOfArguments);
    int i = 0;
    for (; i < iMAX; i ++) {
        id argument = [arguments objectAtIndex:i];
        [self setArgument:&argument atIndex:i+1];
    }
    for (; i < numberOfArguments; i ++) {
        [self setArgument:nil atIndex:i++];
    }
    
    [self invoke];
    
    void *buffer;
    [self getReturnValue:&buffer];
    
    return CFBridgingRelease(buffer);
}

@end
