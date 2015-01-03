//
//  ESCPDFGallery.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import "ESCPDFGallery+Private.h"
#import "ESCPDFPageView.h"

@implementation ESCPDFGallery

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    self.clipsToBounds = YES;
    
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 1.0;
    [self addSubview:_scrollView];

    self.contentView = [[UIView alloc] init];
    _contentView.clipsToBounds = YES;
    
    [_scrollView addSubview:_contentView];
    self.pageSpace = 13.0f;
    
    self.vissablePageRange = PageRangeMake(0, -1);
    self.vissablePageRect = PageRectMake(0, 0, 0, 0);
    self.reusablePageView = [NSMutableArray new];
}

- (void)setBounds:(CGRect)bounds
{
    BOOL isBoundsChanged = fabsf(self.bounds.size.width-bounds.size.width) > 0.1 || fabsf(self.bounds.size.height-bounds.size.height)>0.1;
    [super setFrame:bounds];
    if (!isBoundsChanged) return;
    [self.scrollView setFrame:self.bounds];
    [self updateContentSize];
}

#pragma mark- document 控制
- (void)setDocument:(ESCPDFDocument *)document
{
    _document = document;
    self.pagesRect = [self analyzeDocumentPageRect];
    [self updateContentSize];
}


#pragma mark- 跳转控制
- (void)scrollToPage:(NSUInteger)pageIndex withOffset:(UIOffset)offset animated:(BOOL)animated
{
    
}

@end
