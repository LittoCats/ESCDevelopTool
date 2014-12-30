//
//  ESCWebView+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/22/14.
//
//

#ifndef ESCDevelopTool_ESCWebView_Private_h
#define ESCDevelopTool_ESCWebView_Private_h
#import "ESCWebView.h"

#define __ESCWebView_UniqueId_Key @"__ESCWebView_UniqueId_Key"

typedef NS_ENUM(char, ESCWebView_ArgumentsType) {
    ESCWebView_ArgumentsType_string         =   's',
    ESCWebView_ArgumentsType_number         =   'n',
    ESCWebView_ArgumentsType_boolean        =   'b',
    ESCWebView_ArgumentsType_date           =   'd',
    ESCWebView_ArgumentsType_function       =   'f',
    ESCWebView_ArgumentsType_array          =   'a',
    ESCWebView_ArgumentsType_object         =   'o'
};

@interface ESCWebViewURLProtocol : NSURLProtocol

@end

@interface ESCWebViewJSCallback ()

@property (nonatomic, copy) NSString *callbackId;

@property (nonatomic, weak) ESCWebView *webView;

- (id)initWithCallbackId:(NSString *)callbackId webView:(ESCWebView *)webview;
- (void)eval:(id)buffer,... NS_REQUIRES_NIL_TERMINATION;

@end

@interface ESCWebView ()

@property (nonatomic) unsigned long requestId;

@property (nonatomic, strong) NSString *__uniqueId_;

@property (nonatomic, strong) NSMapTable *__actionMapTable_;

@property (nonatomic, assign) long long __serializeNo_;

@property (nonatomic) id<ESCWebViewDOMProtocol> (^XMLDOM)(NSString *jQuery);

@end

UIKIT_EXTERN NSMapTable *kESCWebViewInstanceTable();
UIKIT_EXTERN id kESCWebViewBridgeArgumentsAnylize(ESCWebView *webview, NSDictionary *arguments);
UIKIT_EXTERN id kESCWebViewBridgeArgumentsWrap(ESCWebView *webview, id arguments);
UIKIT_EXTERN const NSString *kESCWebViewBridgeStaticLibrary;

#endif
