//
//  ESCPDFGallery+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import "ESCPDFGallery.h"
#import "ESCPDFDocument.h"

typedef struct {
    NSInteger start;
    NSInteger end;
} PageRange;

NS_INLINE PageRange PageRangeMake(NSInteger start, NSInteger end){
    PageRange p;
    p.start = start;
    p.end = end;
    return p;
}

NS_INLINE BOOL isPageInRange(NSInteger pageNumber, PageRange range){
    return pageNumber >= range.start && pageNumber <= range.end;
}

typedef struct {
    CGFloat x0;
    CGFloat y0;
    CGFloat x1;
    CGFloat y1;
} PageRect;

NS_INLINE PageRect PageRectMake(CGFloat x0, CGFloat y0, CGFloat x1, CGFloat y1){
    PageRect pr;
    pr.x0 = 0;pr.y0 = 0; pr.y1 = 0; pr.x1 = 0;
    return pr;
}

NS_INLINE PageRect PageRectCopy(PageRect pageRect){
    PageRect pr;
    pr.x0 = pageRect.x0,pr.x1 = pageRect.x1,pr.y0 = pageRect.y0,pr.y1 = pageRect.y1;
    return pr;
}

@class ESCPDFPageView;
@interface ESCPDFGallery ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray *pagesRect;

@property (nonatomic) CGFloat maxPageWidth;

@property (nonatomic) PageRange vissablePageRange;

@property (nonatomic) PageRect vissablePageRect;

@property (nonatomic, strong) NSMutableArray *reusablePageView;
@end

@interface ESCPDFGallery (Private)<UIScrollViewDelegate>

- (NSArray *)analyzeDocumentPageRect;

- (void)updateContentSize;

- (void)updateContentInRect:(CGRect)vissibleRect;

- (NSInteger)firstPageInRect:(CGRect)rect;
@end
