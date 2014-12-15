//
//  ESCImageGallery.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/12/14.
//
//

#import "ESCImageGallery+Private.h"

#import "UIColor+ESC.h"

#define kImages ((NSMutableArray *)self.images)

@implementation ESCImageGallery

- (void)setImages:(NSArray *)images
{
    _images = [NSMutableArray new];
    for (id imageInfo in images) {
        [kImages addObject:[self __imageWithInfo:imageInfo]];
    }
    [self __updateImageView];
}
- (UIImage *)imageAtIndex:(NSInteger)index
{
    return [[_images objectAtIndex:index] objectForKey:@"image"];
}
- (void)insertImage:(id)image atIndex:(NSInteger)index
{
    [kImages insertObject:[self __imageWithInfo:image] atIndex:index];
    [self __updateImageView];
}

- (void)removeImageAtIndex:(NSInteger)index
{
    [kImages removeObjectAtIndex:index];
    [self __updateImageView];
}

- (void)__updateImageView
{
    if (_imageView0.tag < _images.count) _imageView0.imageInfo = [_images objectAtIndex:_imageView0.tag];
    if (_imageView1.tag < _images.count) _imageView1.imageInfo = [_images objectAtIndex:_imageView1.tag];
    if (_imageView2.tag < _images.count) _imageView2.imageInfo = [_images objectAtIndex:_imageView2.tag];
    
    _pageControl.numberOfPages = _images.count;
    _pageControl.currentPage = _scrollView.contentOffset.x/_scrollView.frame.size.width;
    
    [self setNeedsLayout];
}

#pragma mark- init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        self.imageView0 = [[__ESCImageView alloc] initWithFrame:CGRectZero];
        _imageView0.tag = 0;
        self.imageView1 = [[__ESCImageView alloc] initWithFrame:CGRectZero];
        _imageView1.tag = 1;
        self.imageView2 = [[__ESCImageView alloc] initWithFrame:CGRectZero];
        _imageView2.tag = 2;

        [_scrollView addSubview:_imageView0];
        [_scrollView addSubview:_imageView1];
        [_scrollView addSubview:_imageView2];
        
        self.pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
    }
    return self;
}

#pragma mark- frame
- (void)setFrame:(CGRect)frame
{
    BOOL isNeedLayoutSubviews = fabsf(frame.size.width - self.frame.size.width) > 0.1 || fabsf(frame.size.height - self.frame.size.height) > 0.1;
    [super setFrame:frame];
    if (isNeedLayoutSubviews){
        [self layoutSubviews];
    }
}

- (void)layoutSubviews
{
    _scrollView.frame = self.bounds;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    _imageView0.frame = CGRectMake(w*_imageView0.tag, 0, w, h);
    _imageView1.frame = CGRectMake(w*_imageView1.tag, 0, w, h);
    _imageView2.frame = CGRectMake(w*_imageView2.tag, 0, w, h);
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*_images.count, self.frame.size.height);
    
    _pageControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-22);
}
@end
