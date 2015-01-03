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
    self.delegate = self;
    self.maximumZoomScale = 1.0;
    self.minimumZoomScale = 1.0;

    self.contentView = [[UIView alloc] init];
    _contentView.clipsToBounds = YES;
    
    [self addSubview:_contentView];
    self.pageSpace = 13.0f;
    
    self.vissablePageRange = PageRangeMake(0, -1);
    self.vissablePageRect = PageRectMake(0, 0, 0, 0);
    self.reusablePageView = [NSMutableArray new];
}

- (void)setBounds:(CGRect)bounds
{
    BOOL isNeedUpdateContentSize = fabsf(bounds.size.width - self.frame.size.width) > 1.0;
    [super setBounds:bounds];
    _vissablePageRect.x1 = _vissablePageRect.x0 + bounds.size.width;
    isNeedUpdateContentSize ? [self updateContentSize] : nil;
    
    [self updateContentInRect:CGRectMake(0, self.contentOffset.y, self.frame.size.width, self.frame.size.height)];
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
