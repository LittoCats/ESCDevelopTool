//
//  ESCPDFGallery+Private.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import "ESCPDFGallery+Private.h"
#import "ESCPDFDocument+Private.h"
#import "UIImage+ESC.h"
#import "UIColor+ESC.h"

#import "ESCPDFPageView.h"

@implementation ESCPDFGallery (Private)

- (NSArray *)analyzeDocumentPageRect
{
    NSMutableArray *pagesRect = [NSMutableArray new];
    CGRect rect = CGRectZero;
    for (NSInteger i = 0; i < self.document.pageCount; i ++) {
        CGRect crop ;
        [self.document __getPageRect:&crop withPageNumber:i];
        rect.size = crop.size;
        self.maxPageWidth = rect.size.width > self.maxPageWidth ? rect.size.width : self.maxPageWidth;
        [pagesRect addObject:NSStringFromCGRect(rect)];
        rect.origin.y += crop.size.height;
    }
    return [NSArray arrayWithArray:pagesRect];
}

- (void)updateContentSize
{
    // 设置 contentView size
    // page 的最大宽度缩放到 self 的宽度，总高度出需要做同比例的缩放
    // 需根据 self (UIScrollView）的 zoomScale 缩放宽高
    CGRect lastPageRect = CGRectFromString([self.pagesRect lastObject]);
    CGFloat pageScal = self.frame.size.width/self.maxPageWidth;
    self.contentView.frame = CGRectMake(0.0, 0.0,
                                        self.frame.size.width,
                                        (lastPageRect.origin.y+lastPageRect.size.height)*pageScal);
    self.contentView.backgroundColor = [UIColor yellowColor];
    self.scrollView.contentSize = self.contentView.frame.size;
    
    [self updateContentInRect:CGRectMake(0, self.scrollView.contentOffset.y, self.scrollView.contentSize.width, self.scrollView.frame.size.height)];
}

- (NSInteger)firstPageInRect:(CGRect)rect
{
    CGFloat location = rect.origin.y / (self.scrollView.contentSize.width / self.maxPageWidth);
    // 使用二分法，找到指定区域中的第一个 page 的 pageNumber
    NSInteger startNumber = 0, endNumber = self.pagesRect.count;
    NSInteger pageNumber = 0;
    CGRect pageRect;
    while (YES) {
        pageNumber = (startNumber + endNumber)/2;
        pageRect = CGRectFromString([self.pagesRect objectAtIndex:pageNumber]);
        if (location < pageRect.origin.y) {
            endNumber = pageNumber;
        }else if (location + 0.1 > pageRect.origin.y+pageRect.size.height){
            startNumber = pageNumber;
            if (endNumber-startNumber == 1) {
                pageNumber = endNumber;
                break;
            }
        }else{
            break;
        }
    }
    
    return pageNumber;
}

#pragma mark- 重用管理
- (void)enqueueUnvissiblePageViewForReuse
{
    //将不在可视区域的 page 放入缓存
    for (ESCPDFPageView *pageView in self.contentView.subviews) {
        CGRect vissibleBounds = self.scrollView.bounds;
        if (pageView.pageNumber == self.vissablePageRange.start) {
            if (pageView.frame.origin.y+pageView.frame.size.height < vissibleBounds.origin.y){
                [pageView removeFromSuperview];
                [self.reusablePageView addObject:pageView];
                
                PageRect rect = PageRectCopy(self.vissablePageRect);
                rect.y0 = pageView.frame.origin.y+pageView.frame.size.height;
                self.vissablePageRect = rect;
                
                self.vissablePageRange = PageRangeMake(pageView.pageNumber+1, self.vissablePageRange.end);
            }
        }else if(pageView.pageNumber == self.vissablePageRange.end){
            if (pageView.frame.origin.y > vissibleBounds.origin.y+vissibleBounds.size.height){
                [pageView removeFromSuperview];
                [self.reusablePageView addObject:pageView];
                
                PageRect rect = PageRectCopy(self.vissablePageRect);
                rect.y1 = pageView.frame.origin.y;
                self.vissablePageRect = rect;
                self.vissablePageRange = PageRangeMake(self.vissablePageRange.start, pageView.pageNumber-1);
            }
        }
    }
}

- (ESCPDFPageView *)dequeueReusablePageViewForPageNumber:(NSInteger)pageNumber
{
    CGRect rect = CGRectFromString([self.pagesRect objectAtIndex:pageNumber]);
    CGFloat scale = self.scrollView.contentSize.width/self.maxPageWidth;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    // pageView 在 Ｘ 方向居中显示
    rect.origin.x = (self.scrollView.contentSize.width - rect.size.width)/2.0;
    
    ESCPDFPageView *pageView = [self.reusablePageView lastObject];
    if (!pageView) {
        pageView = [[ESCPDFPageView alloc] initWithFrame:rect];
    }
    pageView.frame = rect;
    
    pageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithSize:rect.size colors:@[[UIColor randomColor],[UIColor randomColor],[UIColor randomColor]] gradientDirection:M_PI_2-0.3]];
    pageView.pageNumber = pageNumber;
    return pageView;
}

#pragma mark- 更新当前可视区域的内容
- (void)updateContentInRect:(CGRect)vr
{
    CGRect vissibleRect = vr;
    if (vissibleRect.size.height <= 1 || vissibleRect.origin.y < 0) return;
    
    //  减去已显示的区域，主要是 Y 方向
    if (vissibleRect.origin.y < self.vissablePageRect.y0) {
        // 下拉之后，上面出现未显示内容的区域
        vissibleRect.size.height = self.vissablePageRect.y0 - vissibleRect.origin.y;
    }else if (vissibleRect.origin.y + vissibleRect.size.height > self.vissablePageRect.y1) {
        // 上拉之后，下面出现未显示内容的区域
        vissibleRect.size.height -= self.vissablePageRect.y1-vissibleRect.origin.y;
        vissibleRect.origin.y = self.vissablePageRect.y1;
    }else {return;}
    
    NSInteger pageNumber = [self firstPageInRect:vissibleRect];
    if (isPageInRange(pageNumber, self.vissablePageRange)) return;
    
    // 从缓区取出一个 pageView,如果缓冲区中没有，则会生成一个
    ESCPDFPageView *pageView = [self dequeueReusablePageViewForPageNumber:pageNumber];
    [self.contentView addSubview:pageView];
    
    // 更新已显示 page 范围
    
    if (self.vissablePageRange.start > pageNumber) {
        self.vissablePageRange = PageRangeMake(pageNumber, self.vissablePageRange.end);
    }else if (self.vissablePageRange.end < pageNumber){
        self.vissablePageRange = PageRangeMake(self.vissablePageRange.start, pageNumber);
    }
    
    // 更新已显示的 pageRect
    PageRect pr = PageRectCopy(self.vissablePageRect);
    CGRect addedVissibleRect = pageView.frame;
    if (addedVissibleRect.origin.y+addedVissibleRect.size.height > self.vissablePageRect.y1) {
        pr.y1 = addedVissibleRect.origin.y+addedVissibleRect.size.height;
    }
    if (addedVissibleRect.origin.y < self.vissablePageRect.y0) {
        pr.y0 = addedVissibleRect.origin.y;
    }
    self.vissablePageRect = pr;
    
    [self updateContentInRect:vissibleRect];
}

#pragma mark- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self enqueueUnvissiblePageViewForReuse];
    [self updateContentInRect:CGRectMake(0, scrollView.contentOffset.y, scrollView.contentSize.width, scrollView.frame.size.height)];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}
@end
