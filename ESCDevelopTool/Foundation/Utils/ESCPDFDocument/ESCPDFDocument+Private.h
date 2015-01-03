//
//  ESCPDFDocument+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/30/14.
//	Copyright (c) 11/30/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_ESCPDFDocument_Private
#define ESCDevelopTool_ESCPDFDocument_Private

#import "ESCPDFDocument.h"
#import "ESCCrypt.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#define kESCPDFContextError(DOMAIN,USERINFO) [[NSError alloc] initWithDomain:@"" # DOMAIN code:DOMAIN userInfo:USERINFO]

#ifndef ESCWEAKSELF
#define ESCWEAKSELF __weak typeof(self) wself = self
#endif

#ifndef ESCSTRONGSELF
#define ESCSTRONGSELF __strong typeof(wself) sself = wself; if (!sself) return
#endif

@interface ESCPDFDocument ()

/**
 *  PDF 文件路径，可能为空
 */
@property (nonatomic, strong) NSURL *url;

/**
 *
 */
@property (nonatomic) CGPDFDocumentRef document;

/**
 *  PDF 文件MD5 值
 */
@property (nonatomic, strong) NSString *MD5;

#pragma mark- private property

@property (nonatomic, strong) NSArray *__catalog;

@property (nonatomic, strong) NSError *__error;

@property (nonatomic) CGPDFOperatorTableRef _opTable;

@end

#pragma mark-
#pragma mark- LOAD

@interface ESCPDFDocument (Catalog)

- (NSArray *)____catalogWithInfo:(CGPDFDictionaryRef)catalogInfo;

- (NSNumber *)__pageNumberWithPageDictionary:(CGPDFDictionaryRef)catalogInfo;

@end

@interface ESCPDFDocument (Private)

- (CGPDFPageRef)____pageWithPageNumberl:(NSInteger)pageNumber;

- (NSDictionary *)__InfomationWithCGPDFDictionary:(CGPDFDictionaryRef)dictionaryRef;

- (NSDictionary *)__InfomationWithCGPDFArray:(CGPDFArrayRef)arrayRef;

- (CGRect)__RectWithCGPDFArray:(CGPDFArrayRef)arrayRef;

- (NSDictionary *)__AppearenceWithCGPDFDictionary:(CGPDFDictionaryRef)dictionaryRef;

- (BOOL)__getPageRect:(CGRect *)size withPageNumber:(NSUInteger)pageNumber;

@end

#pragma mark-
#pragma mark- Page
@interface ESCPDFPage()

@property (nonatomic) NSInteger pageNumber;

@property (nonatomic, weak) ESCPDFDocument *document;

@end

@interface ESCPDFPage (Private)

@end
#endif