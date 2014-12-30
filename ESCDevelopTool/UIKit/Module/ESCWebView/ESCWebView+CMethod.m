//
//  ESCWebView+CMethod.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/22/14.
//
//

#import "ESCWebView+Private.h"

NSMapTable *kESCWebViewInstanceTable(){
    static NSMapTable *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = [NSMapTable weakToWeakObjectsMapTable];
    });
    return map;
}

id kESCWebViewBridgeArgumentsAnylize(ESCWebView *webview, id argument)
{
    ESCWebView_ArgumentsType type;
    id value;
    if ([argument isKindOfClass:NSString.class]) {
        type = [argument characterAtIndex:0];
        value = [argument substringFromIndex:3];
    }else if ([argument isKindOfClass:NSArray.class]){
        type = ESCWebView_ArgumentsType_array;
        value = argument;
    }else{
        type = ESCWebView_ArgumentsType_object;
        value = argument;
    }
    id arg;
    switch (type) {
        case ESCWebView_ArgumentsType_string: return value;
        case ESCWebView_ArgumentsType_number: return @([value doubleValue]);
        case ESCWebView_ArgumentsType_boolean: return @([value boolValue]);
        case ESCWebView_ArgumentsType_date:
            return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        case ESCWebView_ArgumentsType_array:
            arg = [NSMutableArray new];
            for (id argument in value) {
                id subValue = kESCWebViewBridgeArgumentsAnylize(webview, argument);
                if (subValue) [arg addObject:subValue];
            }
            return [NSArray arrayWithArray:arg];
        case ESCWebView_ArgumentsType_object:
            arg = [NSMutableDictionary new];
            for (id property in value) {
                id subValue = kESCWebViewBridgeArgumentsAnylize(webview, [value objectForKey:property]);
                if (subValue) [arg setObject:subValue forKey:property];
            }
            return [NSDictionary dictionaryWithDictionary:arg];
        case ESCWebView_ArgumentsType_function:
            return [[ESCWebViewJSCallback alloc] initWithCallbackId:value webView:webview];
        default:
            return nil;
    }
}

id kESCWebViewBridgeArgumentsWrap(ESCWebView *webview, id arguments)
{
    if ([arguments isKindOfClass:NSString.class])
        return [[NSString alloc] initWithFormat:@"s->%@",arguments];
    
    if ([arguments isKindOfClass:NSNumber.class]) {
        if (strcmp([arguments objCType], @encode(BOOL)))
            return [[NSString alloc] initWithFormat:@"b->%@",arguments];
        return [[NSString alloc] initWithFormat:@"n->%@",arguments];
    }
    
    if ([arguments isKindOfClass:NSDate.class])
        return [[NSString alloc] initWithFormat:@"d->%f",[arguments timeIntervalSince1970]];
    
    if ([arguments isKindOfClass:NSArray.class]) {
        NSMutableArray *array = [NSMutableArray new];
        for (id argument in arguments) {
            id newArgument = kESCWebViewBridgeArgumentsWrap(webview, argument);
            if (newArgument) [array addObject:newArgument];
        }
        return array;
    }
    if ([arguments isKindOfClass:NSDictionary.class]) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        for (NSString *property in arguments) {
            id newPropertyValue = kESCWebViewBridgeArgumentsWrap(webview, [arguments objectForKey:property]);
            if (newPropertyValue) [dic setObject:newPropertyValue forKey:property];
        }
        return dic;
    }
    
    return nil;
}

const NSString *kESCWebViewBridgeStaticLibrary = @"ZXZhbChmdW5jdGlvbihwLGEsYyxrLGUsZCl7ZT1mdW5jdGlvbihjKXtyZXR1cm4oYzxhPycnOmUocGFyc2VJbnQoYy9hKSkpKygoYz1jJWEpPjM1P1N0cmluZy5mcm9tQ2hhckNvZGUoYysyOSk6Yy50b1N0cmluZygzNikpfTtpZighJycucmVwbGFjZSgvXi8sU3RyaW5nKSl7d2hpbGUoYy0tKXtkW2UoYyldPWtbY118fGUoYyl9az1bZnVuY3Rpb24oZSl7cmV0dXJuIGRbZV19XTtlPWZ1bmN0aW9uKCl7cmV0dXJuJ1xcdysnfTtjPTF9O3doaWxlKGMtLSl7aWYoa1tjXSl7cD1wLnJlcGxhY2UobmV3IFJlZ0V4cCgnXFxiJytlKGMpKydcXGInLCdnJyksa1tjXSl9fXJldHVybiBwfSgnKGgoKXtwIEosdSxxO2cuRD0wO2cuSz0wO2cueD17fTtnLlo9aCh3KXs2KHcuRj09PTApezIgdn0yIGdbd109aCgpe3AgNTs1PUkuZS5PLkwoUik7NS5HKHcpOzIgSi5TKHYsNSl9fTtKPWgoKXtwIEgsNSx0LGs7NT1JLmUuTy5MKFIpO3Q9USAxMSgpO0g9NS4xMCgpO2s9cSg1KTs2KGsuYyE9PVwnMTJcJyl7az0xMy4xNShrKX10LjE0KFwnMTZcJyxcJ1g6Ly9cJytVK1wnL1wnK0grXCcvXCcrKCsrRCkrXCc/XCcrayxXKTt0LlkoXCdWXCcsKytEKTsyIHQuMWUodil9O2cuMWc9aChtLDUpezYoIShtPXhbbV0pKXsyfTIgbS5TKHYsdSg1KSl9O2cuMWY9aChtKXsyIDE3IHhbbV19OzFjLmUuYz1cJ3NcJzsxOC5lLmM9XCduXCc7MTkuZS5jPVwnYlwnOzFkLmUuYz1cJ2ZcJztOLmUuYz1cJ2RcJztJLmUuYz1cJ2FcJztxPWgoNyl7cCBFLHkseixpLGwsNCw5LGo7ND03LmM7Nig0PT09XCdzXCcpezJcJ3MtPlwnKzd9Nig0PT09XCduXCcpezJcJ24tPlwnKzd9Nig0PT09XCdiXCcpezJcJ2ItPlwnKzd9Nig0PT09XCdkXCcpezJcJ2QtPlwnKzd9Nig0PT09XCdmXCcpe3hbS109NzsyXCdmXCcrSysrfTYoND09PVwnYVwnKXt5PVtdO0EoOT0wLGo9Ny5GOzk8ajs5Kyspe0U9N1s5XTt5LkcocShFKSl9MiB5fXo9e307QShpIFAgNyl7bD03W2ldO3pbaV09cShsKX0yIHp9O3U9aCg1KXtwIDcsQyxCLHIsaSxsLDQsOCw5LGo7ND1cJ1wnOzg9e307Nig1LmM9PT1cJ3NcJyl7ND01LlQoMCwxKTs4PTUuVCgzKX1NIDYoNS5jPT09XCdhXCcpezQ9XCdhXCc7OD01fU17ND1cJ29cJzs4PTV9Nig0PT09XCdzXCcpezIgOH02KDQ9PT1cJ25cJyl7MiA4fTYoND09PVwnYlwnKXsyIDh9Nig0PT09XCdkXCcpe0I9USBOKCk7Qi4xYig4KjFhKTsyIEJ9Nig0PT09XCdhXCcpe0M9W107QSg5PTAsaj04LkY7OTxqOzkrKyl7Nz04WzldO0MuRyh1KDcpKX0yIEN9Nig0PT09XCdyXCcpe3I9e307QShpIFAgOCl7bD04W2ldO3JbaV09dShsKX0yIHJ9MiB2fX0pLkwoZyk7Jyw2Miw3OSwnfHxyZXR1cm58fHR5cGV8YXJnc3xpZnxhcmd8dmFsdWV8X2l8fHxfX0VTQ1dlYlZpZXdfQnJpZGdlX09iamVjdFR5cGV8fHByb3RvdHlwZXx8dGhpc3xmdW5jdGlvbnxwcm9wZXJ0eXxfbGVufHBhcmFtZXRlcnN8cHJvcGVydHlWYWx1ZXxjYWxsYmFja3x8fHZhcnxfX0VTQ1dlYlZpZXdfQnJpZGdlX0FyZ3VtZW50c19XcmFwcGVyfG9iamVjdHx8aGFuZGxlfF9fRVNDV2ViVmlld19CcmlkZ2VfQXJndW1lbnRzX0FuYWx5emVyfG51bGx8bmFtZXxfX0VTQ1dlYlZpZXdfQnJpZGdlX0Z1bmN0aW9uX1dyYXBwZXJffG5ld0FycmF5fG5ld09iamVjdHxmb3J8ZGF0ZXxhcnJheXxfX0VTQ1dlYlZpZXdCcmlkZ2VfU2VyaWFsaXplTm9ffGl0ZW18bGVuZ3RofHB1c2h8YWN0aW9ufEFycmF5fF9fRVNDV2ViVmlld19CcmlkZ2V8X19FU0NXZWJWaWV3X0JyaWRnZV9GdW5jdGlvbl9XcmFwcGVyX1NlcmlhbGl6ZU5vX3xjYWxsfGVsc2V8RGF0ZXxzbGljZXxpbnxuZXd8YXJndW1lbnRzfGFwcGx5fHN1YnN0cmluZ3xfX0VTQ1dlYlZpZXdfVW5pcXVlSWRfS2V5fEVTQ1dlYlZpZXdCcmlkZ2VfU2VyaWFsaXplTm98ZmFsc2V8RVNDV0VCVklFV0JSSURHRXxzZXRSZXF1ZXN0SGVhZGVyfF9fRVNDV2ViVmlld19yZWdpc3RlTmF0aXZlQ2FsbGJhY2tffHBvcHxYTUxIdHRwUmVxdWVzdHxzdHJpbmd8SlNPTnxvcGVufHN0cmluZ2lmeXxQT1NUfGRlbGV0ZXxOdW1iZXJ8Qm9vbGVhbnwxMDAwfHNldFRpbWV8U3RyaW5nfEZ1bmN0aW9ufHNlbmR8X19FU0NXZWJWaWV3X0JyaWRnZV9kZWxldGVfY2FsbGJhY2t8X19FU0NXZWJWaWV3X0JyaWRnZV9ldmFsX2NhbGxiYWNrJy5zcGxpdCgnfCcpLDAse30pKQ==";