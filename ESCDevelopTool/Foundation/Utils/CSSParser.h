//
//  CSSParser.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/14/15.
//
//  将 CSS 字符串转为 NSDictionary

#import <Foundation/Foundation.h>

@interface CSSParser : NSObject

/**
 *  初始化 parser
 *  @param source   css 样式字符串
 *  @param parser   默认样式，可以为空
 *  @discussion 如果 source 和 parser 都为 nil 或无有效数据，则返回 nil
 */
+ (instancetype)parserWithSource:(NSString *)source default:(CSSParser *)parser;

/**
 *  添加 css 样式资源
 *  @param source   css 样式字符串
 *  @param replaceOldSelector   YES 新加入的 selector 会替换原有的 selector ; NO 新加入的 selector 中的属性添加进原有的 selector 中
 */
- (void)appendSource:(NSString *)source replace:(BOOL)replaceOldSelector;

/**
 *  样式字符串，不是原子符串的拼接，而是有效样式信息的格式化输出
 */
@property (nonatomic, readonly) NSString *source;

/**
 *  format : {selector:{attribute:value}}
 */
@property (nonatomic, readonly) NSDictionary *CSS;

@end
