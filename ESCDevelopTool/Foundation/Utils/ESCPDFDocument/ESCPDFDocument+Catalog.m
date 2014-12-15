//
//  ESCPDFDocument+Catalog.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/28/14.
//	Copyright (c) 11/28/14 Littocats. All rights reserved.
//

#import "ESCPDFDocument+Private.h"

@implementation ESCPDFDocument (Catalog)

- (NSArray *)____catalogWithInfo:(CGPDFDictionaryRef)catalogInfo
{
    NSMutableArray *catalog = [NSMutableArray new];
    
    NSMutableDictionary *item;
    
    // 获取 title
    CGPDFStringRef title;
    if (CGPDFDictionaryGetString(catalogInfo, "Title", &title)) {
        if (!item) item = [NSMutableDictionary new];
        NSString *catalogTitle = (__bridge NSString *)(CGPDFStringCopyTextString(title));
        [item setObject:[catalogTitle copy] forKey:ESCPDFCatalogKey_Title];
    }
    
    
    // 获取 subcatalog
    CGPDFDictionaryRef firstcatalog;
    if (CGPDFDictionaryGetDictionary(catalogInfo, "First", &firstcatalog)) {
        if (!item) item = [NSMutableDictionary new];
        [item setObject:[self ____catalogWithInfo:firstcatalog] forKey:ESCPDFCatalogKey_Subcatalog];
    }
    
    // 页面索引
    id pageIndex = [self __pageNumberWithPageDictionary:catalogInfo];
    if (pageIndex){
        if (!item) item = [NSMutableDictionary new];
        [item setObject:pageIndex forKey:ESCPDFCatalogKey_Index];
    }
    if (item) [catalog addObject:item];
    
    CGPDFDictionaryRef nextcatalog = catalogInfo;
    while (CGPDFDictionaryGetDictionary(nextcatalog, "Next", &nextcatalog)) {
        CGPDFStringRef title;
        NSString *catalogTitle;
        if (CGPDFDictionaryGetString(nextcatalog, "Title", &title)) {
            catalogTitle = (__bridge NSString *)(CGPDFStringCopyTextString(title));
        }
        id catalogIndex = [self __pageNumberWithPageDictionary:nextcatalog];
        
        // e有下一级菜单，则递归
        CGPDFDictionaryRef firstcatalog;
        NSArray *subcatalog;
        if (CGPDFDictionaryGetDictionary(nextcatalog, "First", &firstcatalog)) {
            subcatalog = [self ____catalogWithInfo:firstcatalog];
        }
        
        NSMutableDictionary *item = [NSMutableDictionary new];
        [item setObject:[catalogTitle copy] forKey:ESCPDFCatalogKey_Title];
        if (subcatalog) [item setObject:subcatalog forKey:ESCPDFCatalogKey_Subcatalog];
        if (catalogIndex) [item setObject:catalogIndex forKey:ESCPDFCatalogKey_Index];
        [catalog addObject:item];
    }
    return [NSArray arrayWithArray:catalog];
}

- (NSNumber *)__pageNumberWithPageDictionary:(CGPDFDictionaryRef)catalogInfo
{
    NSNumber *pageIndex;
    //  获取页面信息
    CGPDFArrayRef dest;
    if (CGPDFDictionaryGetArray(catalogInfo, "Dest", &dest)) {
        NSInteger count = CGPDFArrayGetCount(dest);
        CGPDFObjectRef temp;
        while (count --) {
            if (CGPDFArrayGetObject(dest, count, &temp)) {
                CGPDFObjectType type = CGPDFObjectGetType(temp);
                //                NSLog(@"+___________ : %u",type);
                if (type == kCGPDFObjectTypeDictionary) {
                    CGPDFDictionaryRef tempDic;
                    if (CGPDFArrayGetDictionary(dest, count, &tempDic)) {
                        //                        CGPDFDictionaryApplyFunction(tempDic, __ESCPDFDictionaryApplyFunction, NULL);
                        NSInteger i = 0;
                        while (i ++ <= self.pageCount) {
                            CGPDFPageRef pageRef = CGPDFDocumentGetPage(self.document, i);
                            CGPDFDictionaryRef pageDic = CGPDFPageGetDictionary(pageRef);
                            if (pageDic == tempDic) {
                                pageIndex = @(i-1);
                                break;
                            }
                        }
                    }
                    //                }else if (type == kCGPDFObjectTypeArray){
                    //
                    //                }else if (type == kCGPDFObjectTypeName){
                    //                    const char *tempName;
                    //                    CGPDFArrayGetName(dest, count, &tempName);
                    //                }else if (type == kCGPDFObjectTypeString){
                    //
                    //                }else if (type == kCGPDFObjectTypeReal){
                    //
                    //                }else if (type == kCGPDFObjectTypeInteger){
                    //                    CGPDFInteger tempInt;
                    //                    if (CGPDFArrayGetInteger(dest, count, &tempInt)) {
                    //                    }
                    //                }else if (type == kCGPDFObjectTypeBoolean){
                    //
                    //                }else if (type == kCGPDFObjectTypeNull){
                    
                }
            }
        }
    }
    
    CGPDFDictionaryRef parent;
    if (CGPDFDictionaryGetDictionary(catalogInfo, "Parent", &parent)) {
        CGPDFInteger count;
        if (CGPDFDictionaryGetInteger(parent, "Count", &count)) {
            
        }
        
        CGPDFDictionaryRef last;
        if (CGPDFDictionaryGetDictionary(parent, "Last", &last)) {
            
        }
        
    }
    return pageIndex;
}


@end
