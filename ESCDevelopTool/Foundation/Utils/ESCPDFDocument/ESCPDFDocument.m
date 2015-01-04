//
//  ESCPDFDocument.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import "ESCPDFDocument+Private.h"
#import <CoreGraphics/CoreGraphics.h>

const NSString *ESCPDFCatalogKey_Title          = @"title";
const NSString *ESCPDFCatalogKey_Subcatalog     = @"subcatalog";
const NSString *ESCPDFCatalogKey_Index          = @"index";

const NSString *ESCPDFAnnotationKey_Type        = @"Subtype";
const NSString *ESCPDFAnnotationKey_Rect        = @"Location";
const NSString *ESCPDFAnnotationKey_Appe        = @"Appearence";

const NSString *ESCPDFAnnotationKey_AppeType    = @"type";
const NSString *ESCPDFAnnotationKey_AppeAction  = @"action";

const NSString *ESCPDFBookmarkKey_Index         = @"index";
const NSString *ESCPDFBookmarkKey_Summary       = @"summary";
const NSString *ESCPDFBookmarkKey_Id            = @"id";

const NSString *ESCPDFGalleryBookmarkKey        = @"bookmark";
const NSString *ESCPDFGalleryCatalogKey         = @"catalog";
const NSString *ESCPDFGalleryThumbnailsKey      = @"thumbnils";

const NSString *ESCPDFPageInfoKey_Height        = @"height";
const NSString *ESCPDFPageInfoKey_Width         = @"width";

@implementation ESCPDFDocument

- (void)dealloc
{
    CGPDFDocumentRelease(self.document);
    CGPDFOperatorTableRelease(self._opTable);
}

- (instancetype)loadPDF:(NSURL *)url
{
    self.url = url;
    
    // 释放已有 document
    CGPDFDocumentRelease(self.document);
    self.document = NULL;
    
    //开始加载
    self.document = CGPDFDocumentCreateWithURL((__bridge CFURLRef)(self.url));
    if (self.document == NULL) {
        self.__error = kESCPDFContextError(ESCPDFContextError_LoadFaild,  @{@"url":[self.url absoluteString]});
        self.url = nil;
    }
    self.MD5 = [ESCCrypt MD5EncryptWithFilePath:[self.url relativePath]];
    
    return self;
}

- (BOOL)unLockDocumentWithPassword:(NSString *)password
{
    if (CGPDFDocumentIsEncrypted(self.document) && !CGPDFDocumentUnlockWithPassword(self.document, [password UTF8String]))
        return NO;
    return CGPDFDocumentIsUnlocked(self.document);
}

- (NSInteger)pageCount
{
    return CGPDFDocumentGetNumberOfPages(_document);
}

- (NSArray *)catalogs
{
    if (self.__catalog) return ___catalog;
    
    CGPDFDictionaryRef pdfCatalog = CGPDFDocumentGetCatalog(self.document);
    CGPDFDictionaryRef catalog = NULL;
    NSMutableArray *catalogArray = [NSMutableArray new];
    if (CGPDFDictionaryGetDictionary(pdfCatalog, "Outlines", &catalog)) {
        CGPDFDictionaryRef firstcatalog;
        if (CGPDFDictionaryGetDictionary(catalog, "First", &firstcatalog)) {
            [catalogArray addObjectsFromArray:[self ____catalogWithInfo:firstcatalog]];
        }
    }
    self.__catalog = [NSArray arrayWithArray:catalogArray];
    
    return ___catalog;
}

/**
 *  获取第 number 页数据,
 *  用于使用 CGContextDrawPDFPage 绘图
 */
- (ESCPDFPage *)pageWithPageNumber:(NSInteger)number
{
    ESCPDFPage *page = [[ESCPDFPage alloc] init];
    page.pageNumber = number;
    page.document = self;
    
    return page;
}

@end

@implementation ESCPDFPage

- (void)drawContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextDrawPDFPage(context, CGPDFDocumentGetPage(self.document.document, self.pageNumber));
    CGContextRestoreGState(context);
}

- (NSData *)thumbnail
{
    return nil;
}

- (NSArray *)annotations
{
    CGPDFDictionaryRef pageDic = CGPDFPageGetDictionary([self.document ____pageWithPageNumberl:_pageNumber]);
    if (!pageDic) return nil;
    CGPDFArrayRef annots = NULL;
    if (!CGPDFDictionaryGetArray(pageDic, "Annots", &annots)) return nil;
    
    NSMutableArray *annotations = [NSMutableArray new];
    
    NSInteger count = CGPDFArrayGetCount(annots);
    while (count--) {
        CGPDFObjectRef objRef;
        CGPDFArrayGetObject(annots, count, &objRef);
        CGPDFObjectType type = CGPDFObjectGetType(objRef);
        if (type != kCGPDFObjectTypeDictionary) continue;
        
        CGPDFDictionaryRef annot;
        if (!CGPDFArrayGetDictionary(annots, count, &annot)) continue;
        
        const char *name ;
        CGPDFDictionaryGetName(annot, "Subtype", &name);
        
        CGPDFArrayRef rectRef;
        CGPDFDictionaryGetArray(annot, "Rect", &rectRef);
        
        CGPDFDictionaryRef A;
        CGPDFDictionaryGetDictionary(annot, "A", &A);
        
        NSString *subType = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        CGRect rect = [self.document __RectWithCGPDFArray:rectRef];
        NSDictionary *appearence = [self.document __AppearenceWithCGPDFDictionary:A];
        
        [annotations addObject:@{ESCPDFAnnotationKey_Type:subType,
                                 ESCPDFAnnotationKey_Rect:[NSValue valueWithBytes:&rect objCType:@encode(CGRect)],
                                 ESCPDFAnnotationKey_Appe:appearence}];
    }
    
    NSLog(@"Annotations : %@",annotations);
    return annotations;
}
@end
