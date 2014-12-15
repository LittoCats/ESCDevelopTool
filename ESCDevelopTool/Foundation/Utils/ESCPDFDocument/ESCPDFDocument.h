//
//  ESCPDFDocument.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, ESCPDFContextError) {
    ESCPDFContextError_Busy,
    ESCPDFContextError_LoadFaild,
    ESCPDFContextError_NeedPassword,
    ESCPDFContextError_PasswordInvalid,
    ESCPDFContextError_Cannotunlock,
    ESCPDFContextError_Empty,                // 当文档中 pagecount 为 0 时
    ESCPDFContextError_BookmarkFileNotExist,        // 当委托存在，但返回的文件路径不存在或格式不正确时，出现该错误
};

FOUNDATION_EXTERN const NSString *ESCPDFCatalogKey_Title;
FOUNDATION_EXTERN const NSString *ESCPDFCatalogKey_Subcatalog;
FOUNDATION_EXTERN const NSString *ESCPDFCatalogKey_Index;

FOUNDATION_EXPORT const NSString *ESCPDFAnnotationKey_Type;
FOUNDATION_EXPORT const NSString *ESCPDFAnnotationKey_Rect;
FOUNDATION_EXPORT const NSString *ESCPDFAnnotationKey_Appe;     // appearence

FOUNDATION_EXPORT const NSString *ESCPDFAnnotationKey_AppeType;
FOUNDATION_EXPORT const NSString *ESCPDFAnnotationKey_AppeAction;

FOUNDATION_EXTERN const NSString *ESCPDFBookmarkKey_Index;
FOUNDATION_EXTERN const NSString *ESCPDFBookmarkKey_Summary;
FOUNDATION_EXTERN const NSString *ESCPDFBookmarkKey_Id;

FOUNDATION_EXTERN const NSString *ESCPDFPageInfoKey_Height;
FOUNDATION_EXTERN const NSString *ESCPDFPageInfoKey_Width;

#define ESCPDFCatalogIndentation           13

@protocol ESCPDFDocumentDelegate;
@class ESCPDFPage;

@interface ESCPDFDocument : NSObject

/**
 *  PDF 文件路径，可能为空
 */
@property (nonatomic, readonly) NSURL *url;

/**
 *  PDF 文件MD5 值
 */
@property (nonatomic, readonly) NSString *MD5;

/**
 *  pageCount
 */
@property (nonatomic, readonly) NSInteger pageCount;


@property (nonatomic, weak) id <ESCPDFDocumentDelegate> delegate;

/**
 *  加载 PDF 文档,加载完成后需解锁，才能读取信息
 */
- (instancetype)loadPDF:(NSURL *)url;

/**
 *  解锁，解锁可能需要密码,无密码直接传入nil,无密码，传入的密码被忽略
 */
- (BOOL)unLockDocumentWithPassword:(NSString *)password;

/**
 *  获取 目录
 */
- (NSArray *)catalogs;

/**
 *  获取第 number 页数据,
 *  用于使用 CGContextDrawPDFPage 绘图
 */
- (ESCPDFPage *)pageWithPageNumber:(NSInteger)number;

@end

@interface ESCPDFPage : NSObject

- (void)drawContext:(CGContextRef)context;

- (NSData *)thumbnail;

- (NSArray *)annotations;

@end


@protocol ESCPDFDocumentDelegate <NSObject>

@optional

/**
 *  handle error,
 *  @当 Context 产生错误时，调用方法,
 *  @调于该方法的线程不确定,
 *  @建议仅用于简单的错误处理
 */
- (void)pdfDocument:(ESCPDFDocument *)document handleError:(NSError *)error;

@end
