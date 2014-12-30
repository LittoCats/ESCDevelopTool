//
//  ESCWebView+URLProtocol.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/22/14.
//
//

#import "ESCWebView+Private.h"

@implementation ESCWebViewURLProtocol

+ (void)load
{
    [NSURLProtocol registerClass:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //    非 private scheme
    if ([request.URL.scheme isEqualToString:@"escwebviewbridge"]) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSURL *url = self.request.URL;
    NSString *uniqueId = url.host;
    
    long long serializeNo = [[url.path lastPathComponent] longLongValue];
    ESCWebView *webview = [kESCWebViewInstanceTable() objectForKey:uniqueId];
    if (webview.__serializeNo_ < serializeNo){
        webview.__serializeNo_ = serializeNo;
        
        NSString *action = [[url pathComponents] objectAtIndex:1];
        NSString *queryString = url.query;
        NSString *argumentString = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)(queryString), CFSTR(""), kCFStringEncodingUTF8));
        id arguments = [NSJSONSerialization JSONObjectWithData:[argumentString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if ([webview.__actionMapTable_ objectForKey:action]){
            id ret;
            ((ESCWebViewJSAction)[webview.__actionMapTable_ objectForKey:action])(webview, action, kESCWebViewBridgeArgumentsAnylize(webview, arguments),&ret);
                // 返回结果
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [self.client URLProtocol:self didLoadData:ret ? ret : nil];
            [self.client URLProtocolDidFinishLoading:self];
        }else{
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [self.client URLProtocol:self didLoadData:nil];
            [self.client URLProtocolDidFinishLoading:self];
        }
    }
}
- (void)stopLoading
{
    
}


@end
