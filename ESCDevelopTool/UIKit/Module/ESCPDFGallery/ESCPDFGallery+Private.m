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
    self.contentView.transform = CGAffineTransformMakeScale(self.zoomScale, self.zoomScale);
    self.contentView.backgroundColor = [UIColor yellowColor];
    self.contentSize = self.contentView.frame.size;
}

- (NSInteger)firstPageInRect:(CGRect)rect
{
    CGFloat location = rect.origin.y / (self.contentSize.width / self.maxPageWidth);
    // 使用二分法，找到指定区域中的第一个 page 的 pageNumber
    NSInteger startNumber = 0, endNumber = self.pagesRect.count;
    NSInteger pageNumber = 0;
    CGRect pageRect;
    while (YES) {
        pageNumber = (startNumber + endNumber)/2;
        pageRect = CGRectFromString([self.pagesRect objectAtIndex:pageNumber]);
        if (location < pageRect.origin.y) {
            endNumber = pageNumber;
        }else if (location > pageRect.origin.y+pageRect.size.height){
            startNumber = pageNumber;
        }else{
            break;
        }
    }
    
    return pageNumber;
}

#pragma mark- 重用管理
- (void)enqueuePageViewForReuse:(ESCPDFPageView *)pageView
{
    [self.reusablePageView addObject:pageView];
}

- (ESCPDFPageView *)dequeueReusablePageViewForPageNumber:(NSInteger)pageNumber
{
    CGRect rect = CGRectFromString([self.pagesRect objectAtIndex:pageNumber]);
    CGFloat scale = self.contentSize.width/self.maxPageWidth;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    // pageView 在 Ｘ 方向居中显示
    rect.origin.x = (self.contentSize.width - rect.size.width)/2.0;
    
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
- (void)updateContentInRect:(CGRect)vissibleRect
{
    if (vissibleRect.size.height <= 0 || vissibleRect.origin.y < 0) return;
 
    //将不在可视区域的 page 放入缓存
    for (ESCPDFPageView *pageView in self.contentView.subviews) {
        CGRect vissibleBounds = self.bounds;
        NSInteger pageNumber = -1;
        if (pageView.frame.origin.y+pageView.frame.size.height < vissibleBounds.origin.y) {
            [pageView removeFromSuperview];
            [self enqueuePageViewForReuse:pageView];
            PageRect rect = PageRectCopy(self.vissablePageRect);
            rect.y0 = pageView.frame.origin.y+pageView.frame.size.height;
            self.vissablePageRect = rect;
            
            pageNumber = pageView.pageNumber;
        }else if (pageView.frame.origin.y > vissibleBounds.origin.y+vissibleBounds.size.height){
            [pageView removeFromSuperview];
            [self enqueuePageViewForReuse:pageView];
            PageRect rect = PageRectCopy(self.vissablePageRect);
            rect.y1 = pageView.frame.origin.y;
            self.vissablePageRect = rect;
            
            pageNumber = pageView.pageNumber;
        }
        
        if (pageNumber != -1) {
            if (pageNumber == self.vissablePageRange.start) self.vissablePageRange = PageRangeMake(pageNumber+1, self.vissablePageRange.end);
            if (pageNumber == self.vissablePageRange.end) self.vissablePageRange = PageRangeMake(self.vissablePageRange.start, pageNumber-1);
        }
    }
    
    //  减去已显示的区域，主要是 Y 方向
    if (vissibleRect.origin.y < self.vissablePageRect.y0) {
        // 下拉之后，上面出现未显示内容的区域
        vissibleRect.size.height = self.vissablePageRect.y0 - vissibleRect.origin.y;
    }else if (vissibleRect.origin.y + vissibleRect.size.height > self.vissablePageRect.y1) {
        // 上拉之后，下面出现未显示内容的区域
        vissibleRect.size.height -= self.vissablePageRect.y1-vissibleRect.origin.y;
        vissibleRect.origin.y = self.vissablePageRect.y1 + 1.0;// page 页面范围波动值，因为在页面刚好切换的地方，如果没有指向下一页的波动值，则可能返回当前页码，而不能正常显示下一页面内容
    }else {return;}
    
    NSLog(@"vissibleRect : %@",NSStringFromCGRect(vissibleRect));
    
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

@end
