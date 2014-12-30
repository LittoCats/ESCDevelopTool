//
//  ESCWebView.m
//  ESCDevelopKit
//
//  Created by 程巍巍 on 11/17/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

/**
 *  私用请求 __ESCWebViewBridge://action?param1=param1...
 *  请求类型为 UPDATE
 */

#import "ESCWebView+Private.h"
#import "ESCCrypt.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation ESCWebView

#pragma mark- 初始化
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.__uniqueId_ = [NSString stringWithFormat:@"ESCWebView_%.0f_%p",[NSDate timeIntervalSinceReferenceDate],self];
        self.__actionMapTable_ = [NSMapTable strongToStrongObjectsMapTable];
        [kESCWebViewInstanceTable() setObject:self forKey:self.__uniqueId_];
        // 初始化 bridge
        [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var %@ = '%@';",__ESCWebView_UniqueId_Key,self.__uniqueId_]];
#ifdef DEBUG
        NSString *jsLib = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"__esc_webview_bridge" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
#else
        NSString *jsLib = [[NSString alloc] initWithData:[ESCCrypt BASE64Decrypt:kESCWebViewBridgeStaticLibrary] encoding:NSUTF8StringEncoding];
#endif
        [self stringByEvaluatingJavaScriptFromString:jsLib];
        
        [self addJSAction:@"__log__" withCallback:^(ESCWebView *webView, NSString *action, NSArray *arguments, __autoreleasing id *returnValue) {
            NSMutableString *logStr = [NSMutableString new];
            for (id obj in arguments) {
                [logStr appendString:[obj description]];
            }
            NSLog(@"ESCWEBVIEW LOG : %@",logStr);
        }];

        [self stringByEvaluatingJavaScriptFromString:@"var console = {};console.log = __log__;"];
        
#ifdef DEBUG
        [self stringByEvaluatingJavaScriptFromString:@"__log__('ESCWebView LOG Test .');"];
#endif
    }
    return self;
}

#pragma mark- DOM 操作管理
- (void)setJQueryEnable:(BOOL)jQueryEnable enabledHandler:(void (^)(ESCWebView *webview))handler;
{
    if (jQueryEnable && _jQueryEnable){
        if (handler) handler(self);
        return;
    }
    if (jQueryEnable) {
        if ([[self stringByEvaluatingJavaScriptFromString:@"typeof($);"] isEqualToString:@"undefined"]) {
            NSFileManager *manager = [NSFileManager defaultManager];
            NSString *jQuerySource = [NSTemporaryDirectory() stringByAppendingPathComponent:[ESCCrypt MD5Encrypt:[ESCWebView_JQuerySourceURL dataUsingEncoding:NSUTF8StringEncoding]]];
            BOOL isDirectionary;
            NSError *error;
            NSString *jQuery;
            if ([manager fileExistsAtPath:jQuerySource isDirectory:&isDirectionary] && !isDirectionary) {
                jQuery = [NSString stringWithContentsOfFile:jQuerySource encoding:NSUTF8StringEncoding error:&error];
                [self stringByEvaluatingJavaScriptFromString:jQuery];
                if ([[self stringByEvaluatingJavaScriptFromString:@"typeof($);"] isEqualToString:@"undefined"]){
                    NSLog(@"ESCWebView load jQuery faild < %@ >.",error);
                }else{
                    _jQueryEnable = jQueryEnable;
                    if (handler) handler(self);
                }
            }else{
                if (!error) {
                    __weak typeof(self) wself = self;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ESCWebView_JQuerySourceURL]];
                        NSURLResponse *response;
                        NSError *error;
                        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                        [data writeToFile:jQuerySource atomically:YES];
                        NSString *jQuery = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        __strong typeof(wself) sself = wself;
                        if (!sself) return ;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [sself stringByEvaluatingJavaScriptFromString:jQuery];
                            if ([[sself stringByEvaluatingJavaScriptFromString:@"typeof($);"] isEqualToString:@"undefined"]){
                                NSLog(@"ESCWebView load jQuery faild < %@ >.",error);
                            }else{
                                _jQueryEnable = jQueryEnable;
                                if (handler) handler(sself);
                            }
                        });
                    });
                    
                    jQuery = [NSString stringWithContentsOfURL:[NSURL URLWithString:ESCWebView_JQuerySourceURL] encoding:NSUTF8StringEncoding error:&error];
                    [[jQuery dataUsingEncoding:NSUTF8StringEncoding] writeToFile:jQuerySource atomically:YES];
                }
            }
            if (error || !jQuery)
                NSLog(@"ESCWebView load jQuery faild < %@ >.",error);
        }else{
            _jQueryEnable = jQueryEnable;
        }
    }else
        _jQueryEnable = jQueryEnable;
}

- (id<ESCWebViewDOMProtocol> (^)(NSString *))XMLDOM
{
    if (!self.isJQueryEnable) return nil;
    if (!_XMLDOM)
        _XMLDOM = ^id<ESCWebViewDOMProtocol> (NSString *jQuery){
            return nil;
        };
    
    return _XMLDOM;
}

#pragma mark- web <-> native 交互接口
- (BOOL)addJSAction:(NSString *)name withCallback:(ESCWebViewJSAction)callback;
{
    if (!name || ![name isKindOfClass:NSString.class] || !name.length) return NO;
    if ([self.__actionMapTable_ objectForKey:name] || ![[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"typeof(%@)",name]] isEqualToString:@"undefined"]) {
        return NO;
    }
    [self.__actionMapTable_ setObject:callback forKey:name];
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__ESCWebView_registeNativeCallback_('%@');",name]];
    return YES;
}

- (void)callJSFunction:(NSString *)func withArguments:(id)buffer,...
{
    
}

#pragma mark- 数据类型转换


@end

#pragma mark
#pragma mark
/********************************************  ESCWebViewJSCallback   ****************************************************/

@implementation ESCWebViewJSCallback

- (id)initWithCallbackId:(NSString *)callbackId webView:(ESCWebView *)webview
{
    if (!callbackId || !webview) return nil;
    if (self = [super init]) {
        self.callbackId = callbackId;
        self.webView = webview;
    }
    return self;
}

- (void)eval:(id)buffer, ...
{
    if (!_webView) return;
    NSMutableArray *arguments = [NSMutableArray new];
    va_list vList;
    va_start(vList, buffer);
    id argument;
    while ((argument = va_arg(vList, id)))
        [arguments addObject:argument];
    va_end(vList);
    
    arguments = kESCWebViewBridgeArgumentsWrap(_webView, arguments);
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__ESCWebView_Bridge_eval_callback('%@',%@);",_callbackId,[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arguments options:0 error:nil] encoding:NSUTF8StringEncoding]]];
}

- (void)dealloc
{
    if (_webView) {
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__ESCWebView_Bridge_delete_callback('%@');",_callbackId]];
    }
}
@end