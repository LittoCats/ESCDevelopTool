//
//  ESCWebView.h
//  ESCDevelopKit
//
//  Created by 程巍巍 on 11/17/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ESCWebView_JQuerySourceURL @"http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"

@class ESCWebView;

/**
 *  You should never retain callback object , otherwist ,it may cause retain cycle
 */
typedef void (^ESCWebViewJSAction)(ESCWebView *webView,NSString *action, NSArray *arguments, id *returnValue);

#define ESCWebViewEvalJSCallback(callback,...)  [callback eval:@"" # __VA_ARGS__, __VA_ARGS__, nil]

#define ESCWebViewCallJSFunction(webview,function,...)  [webview callJSFunction:function withArguments:@"" # __VA_ARGS__, __VA_ARGS__, nil]

@interface ESCWebViewJSCallback : NSObject

/**
 *  buffer为引导参数，不做为有效参数传入 callback
 *  应避免直接调用该方法，请使用 ESCWebViewEvalJSCallback(callback,...) 代替
 *  通过参数列表传入的 block 对像，会被 retain ,在函数执行完成后，即被 release
 */
- (void)eval:(id)buffer,... NS_REQUIRES_NIL_TERMINATION;

@end

@protocol ESCWebViewDOMProtocol;
@protocol ESCWebViewCSSProtocol;

@interface ESCWebView : UIWebView

/**
 *  当 jQueryEnable ＝ YES 时，可使用 XMLDOM 对网业元素进行操作
 *  XMLDOM 操作方式类似于 jQuery, 相当于 $ 操作符
 *  默认值为 NO
 */
@property (nonatomic,getter=isJQueryEnable,readonly) BOOL jQueryEnable;
/**
 *
 */
- (void)setJQueryEnable:(BOOL)jQueryEnable enabledHandler:(void (^)(ESCWebView *webview))handler;

/**
 *
 */
@property (nonatomic, readonly) id<ESCWebViewDOMProtocol> (^XMLDOM)(NSString *jQuery);

/**
 *  如果，name 对应的 jsAction 已存在，则返回 NO
 *  需要保证 name 与 webview 中的业务 javascript 变量不重名，否则可能被覆盖
 *  callback 会被 retain , 当 ESCWebView 释放时，自动释放，使用过程中，需注意循环引用问题
 *  @discussion     当webview 重新加载时，需重新加载 callback
 */
- (BOOL)addJSAction:(NSString *)name withCallback:(ESCWebViewJSAction)callback;

/**
 * buffer 为引导参数，不做为有效参传入 JSFunction
 *  应避免直接调用该方法，请使用 ESCWebViewCallJSFunction(webview,function,...) 代替
 *  通过参数列表传入的 block 对像，会被 retain ,在函数执行完成后，即被 release, 因此，js 代码中不要将参数中的block回调存储
 */
- (void)callJSFunction:(NSString *)func withArguments:(id)buffer,... NS_REQUIRES_NIL_TERMINATION;
@end

@protocol ESCWebViewDOMProtocol <NSObject>

@optional
@property (nonatomic, readonly) NSString *(^attr)(NSString *name, NSString *value);
@property (nonatomic, readonly) NSString *(^html)(NSString *html);
@property (nonatomic, readonly) void (^remove)();
@property (nonatomic, readonly) void (^removeAttr)(NSString *attr);
@property (nonatomic, readonly) void (^removeClass)(NSString *class);
@property (nonatomic, readonly) NSString *(^text)(NSString *text);
@property (nonatomic, readonly) NSString *(^val)(NSString *value);

@property (nonatomic, readonly) id<ESCWebViewCSSProtocol> (^css)(NSString *css);

@end

@protocol ESCWebViewCSSProtocol <NSObject>

@optional
@property (nonatomic, readonly) NSNumber * (^height)(NSNumber * height);
@property (nonatomic, readonly) NSNumber * (^width)(NSNumber * width);
@property (nonatomic, readonly) NSValue * (^position)(NSValue * position);
@property (nonatomic, readonly) NSValue * (^offset)(NSValue * position);
@property (nonatomic, readonly) NSValue * (^offsetParent)(NSValue * position);
@property (nonatomic, readonly) NSValue * (^scrollLeft)(NSValue * position);
@property (nonatomic, readonly) NSValue * (^scrollTop)(NSValue * position);

@end
