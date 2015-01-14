//
//  CSSParser.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/14/15.
//
//

#import "CSSParser.h"

@interface CSSParser ()

@property (nonatomic, strong) NSMutableDictionary *_css;

// 选择一个样式表
@property (nonatomic, strong) NSRegularExpression *cssRegex;
// 选择样式表 selector
@property (nonatomic, strong) NSRegularExpression *seRegex;
// 选择 arrtibute:value
@property (nonatomic, strong) NSRegularExpression *avRegex;

@end

@implementation CSSParser

+ (instancetype)parserWithSource:(NSString *)source default:(CSSParser *)parser
{
    CSSParser *p = [[CSSParser alloc] init];
    for (NSString *key in parser.CSS) {
        [p._css setObject:[[parser.CSS objectForKey:key] copy] forKey:key];
    }
    [p appendSource:source replace:NO];
    return p._css.count ? p : nil;
}

- (void)appendSource:(NSString *)source replace:(BOOL)replaceOldSelector
{
    [self _parseSource:source replace:replaceOldSelector];
}

- (NSString *)source
{
    return self.description;
}

- (NSDictionary *)CSS
{
    return __css;
}

#pragma mark- private method
- (id)init
{
    if (self = [super init]) {
        self._css = [NSMutableDictionary new];
        // 初始化需要的正则
        NSError *error;
        self.cssRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z\\.#]+[-||a-z||A-Z||0-9]*[\\s]*\\{[\\s\\S]+?\\}" options:0 error:&error];
        self.seRegex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z\\.#]+[-||a-z||A-Z||0-9]*" options:0 error:&error];
        self.avRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]+[-||a-z||A-Z||0-9]*[\\s]*:[\\s]*[a-zA-Z0-9#]+" options:0 error:&error];
    }
    return self;
}

- (void)_parseSource:(NSString *)source replace:(BOOL)replace
{
    __weak typeof(self) wself = self;
    // 获取所有样式表
    [self.cssRegex enumerateMatchesInString:source options:0 range:NSMakeRange(0, source.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        __strong typeof(wself) sself = wself;
        NSString *cssStr = [source substringWithRange:result.range];
        // 获取 selector
        NSRange range = [sself.seRegex rangeOfFirstMatchInString:cssStr options:0 range:NSMakeRange(0, cssStr.length)];
        if (range.location == NSNotFound) return ;
        NSString *selector = [cssStr substringWithRange:range];
        if (replace) [self._css removeObjectForKey:selector];
        [sself.avRegex enumerateMatchesInString:cssStr options:0 range:NSMakeRange(0, cssStr.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSString *avStr = [cssStr substringWithRange:result.range];
            NSArray *avArr = [avStr componentsSeparatedByString:@":"];
            if (avArr.count != 2) return ;
            NSString *attribute = [avArr objectAtIndex:0];
            id value = [sself _resolveAttribute:attribute withValue:[avArr objectAtIndex:1]];
            
            if (!value) return;
            [sself _saveCss:@{attribute:value} forSelector:selector];
        }];
    }];
}

- (id)_resolveAttribute:(NSString *)attribute withValue:(id)value
{
    return value;
}

- (void)_saveCss:(NSDictionary *)css forSelector:(NSString *)selector
{
    if (!css.count) return;
    NSMutableDictionary *sel = [self._css objectForKey:selector];
    if (!sel){
        sel = [NSMutableDictionary new];
        [self._css setObject:sel forKey:selector];
    }
    [sel addEntriesFromDictionary:css];
}
#pragma mark- des
- (NSString *)description
{
    NSMutableString *des = [NSMutableString new];
    
    [self._css enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
        [des appendFormat:@"%@ {",key];
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
            [des appendFormat:@"\n  %@: %@;",key,obj];
        }];
        if ([des characterAtIndex:des.length-1] == ';')
            [des deleteCharactersInRange:NSMakeRange(des.length-1, 1)];
        [des appendFormat:@"\n}\n\n"];
    }];
    
    return des;
}

@end
