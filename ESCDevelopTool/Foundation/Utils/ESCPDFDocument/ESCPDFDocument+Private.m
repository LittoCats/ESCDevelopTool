//
//  ESCPDFDocument+Private.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/30/14.
//	Copyright (c) 11/30/14 Littocats. All rights reserved.
//

#import "ESCPDFDocument+Private.h"

@implementation ESCPDFDocument (Private)

- (CGPDFPageRef)____pageWithPageNumberl:(NSInteger)pageNumber
{
    return CGPDFDocumentGetPage(self.document, pageNumber+1);
}

- (NSDictionary *)__InfomationWithCGPDFDictionary:(CGPDFDictionaryRef)dictionaryRef
{
    NSMutableDictionary *info = [NSMutableDictionary new];
    CGPDFDictionaryApplyFunction(dictionaryRef, &kESCCGPDFDictionaryApplyFunction, (__bridge void *)(info));
    return info;
}

- (NSDictionary *)__InfomationWithCGPDFArray:(CGPDFArrayRef)arrayRef
{
    NSMutableDictionary *info = [NSMutableDictionary new];
    NSInteger count = CGPDFArrayGetCount(arrayRef);
    while (count --) {
        CGPDFObjectRef objRef;
        CGPDFArrayGetObject(arrayRef, count, &objRef);
        CGPDFObjectType type = CGPDFObjectGetType(objRef);
        switch (type) {
            case kCGPDFObjectTypeDictionary:    [info setObject:@"PDFDictionary" forKey:@(count)];break;
            case kCGPDFObjectTypeArray:         [info setObject:@"PDFArray" forKey:@(count)];break;
            case kCGPDFObjectTypeString:        [info setObject:@"PDFString" forKey:@(count)];break;
            case kCGPDFObjectTypeName:          [info setObject:@"PDFName" forKey:@(count)];break;
            case kCGPDFObjectTypeReal:          [info setObject:@"PDFReal" forKey:@(count)];break;
            case kCGPDFObjectTypeInteger:       [info setObject:@"PDFInteger" forKey:@(count)];break;
            case kCGPDFObjectTypeBoolean:       [info setObject:@"PDFBoolean" forKey:@(count)];break;
            case kCGPDFObjectTypeNull:          [info setObject:@"PDFNull" forKey:@(count)];break;
            case kCGPDFObjectTypeStream:        [info setObject:@"PDFStream" forKey:@(count)];break;
            default:break;
        }
    }
    return info;
}

- (CGRect)__RectWithCGPDFArray:(CGPDFArrayRef)arrayRef
{
    // 1
    CGPDFInteger value0 ;
    CGPDFArrayGetInteger(arrayRef, 0, &value0);
    
    CGPDFInteger value1;
    CGPDFArrayGetInteger(arrayRef, 1, &value1);
    
    CGPDFReal value2;
    CGPDFArrayGetNumber(arrayRef, 2, &value2);
    
    CGPDFInteger value3;
    CGPDFArrayGetInteger(arrayRef, 3, &value3);
    
    return CGRectZero;
}

- (NSDictionary *)__AppearenceWithCGPDFDictionary:(CGPDFDictionaryRef)dictionaryRef
{
    NSMutableDictionary *appe = [NSMutableDictionary new];
    
    const char *name;
    CGPDFDictionaryGetName(dictionaryRef, "S", &name);
    NSString *type = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
    [appe setObject:type forKey:ESCPDFAnnotationKey_AppeType];
    
    if ([type isEqualToString:@"GoTo"]) {
        CGPDFArrayRef D;
        if (CGPDFDictionaryGetArray(dictionaryRef, "D", &D)) {
            CGPDFDictionaryRef pageDic ;
            if (CGPDFArrayGetDictionary(D, 0, &pageDic)) {
//                NSNumber *index = [self __pageNumberWithPageDictionary:pageDic];
            }
        }
    }else if ([type isEqualToString:@"URI"]){
        CGPDFStringRef string;
        CGPDFDictionaryGetString(dictionaryRef, "URI", &string);
        
        NSString *action = CFBridgingRelease(CGPDFStringCopyTextString(string));
        [appe setObject:action forKey:ESCPDFAnnotationKey_AppeAction];
    }
    
    
    return appe;
}

static void kESCCGPDFDictionaryApplyFunction(const char *key, CGPDFObjectRef obj, void *Info)
{
    NSMutableDictionary *info = (__bridge NSMutableDictionary *)(Info);
    CGPDFObjectType type = CGPDFObjectGetType(obj);
    NSString *property = [[NSString alloc] initWithCString:key encoding:NSUTF8StringEncoding];
    switch (type) {
        case kCGPDFObjectTypeDictionary:    [info setObject:property forKey:@"PDFDictionary"];break;
        case kCGPDFObjectTypeArray:         [info setObject:property forKey:@"PDFArray"];break;
        case kCGPDFObjectTypeString:        [info setObject:property forKey:@"PDFString"];break;
        case kCGPDFObjectTypeName:          [info setObject:property forKey:@"PDFName"];break;
        case kCGPDFObjectTypeReal:          [info setObject:property forKey:@"PDFReal"];break;
        case kCGPDFObjectTypeInteger:       [info setObject:property forKey:@"PDFInteger"];break;
        case kCGPDFObjectTypeBoolean:       [info setObject:property forKey:@"PDFBoolean"];break;
        case kCGPDFObjectTypeNull:          [info setObject:property forKey:@"PDFNull"];break;
        case kCGPDFObjectTypeStream:        [info setObject:property forKey:@"PDFStream"];break;
            
        default:
            break;
    }
}

#pragma mark- document info
- (BOOL)__getPageRect:(CGRect *)rect withPageNumber:(NSUInteger)pageNumber
{
    if (pageNumber > self.pageCount-1 || !self.document) return NO;
    CGPDFPageRef page = CGPDFDocumentGetPage(self.document, pageNumber+1);
    *rect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    return YES;
}
@end
