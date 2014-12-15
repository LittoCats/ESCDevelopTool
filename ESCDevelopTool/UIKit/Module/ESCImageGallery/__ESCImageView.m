//
//  __ESCImageView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/12/14.
//
//

#import "ESCImageGallery+Private.h"

@implementation __ESCImageView

- (void)setImageInfo:(NSMutableDictionary *)imageInfo
{
    if (_imageInfo == imageInfo) {
        return;
    }
    [_imageInfo removeObjectForKey:@"imageView"];
    [_imageInfo setObject:@(self.zoomScale) forKey:@"zoomScale"];
    _imageInfo = imageInfo;
    [_imageInfo setObject:self forKey:@"imageView"];
    [self __updateImage];
}

- (void)__updateImage
{
    if (!self.imageInfo) return;
    
    if ([[_imageInfo objectForKey:@"loading"] boolValue])[self __showLoading];
    else [self __hideLoading];
    
    UIImage *image = [self.imageInfo objectForKey:@"image"];
    if (image) {
        [self.imageView setImage:image];
        CGFloat zoomScal = [[_imageInfo objectForKey:@"zoomScale"] floatValue];
        self.zoomScale = zoomScal > 0 ? zoomScal : 1.0;
    }else{
        [self.imageView setImage:[_imageInfo objectForKey:@"imageHolder"]];
        self.zoomScale = 1.0;
        
        if (![_imageInfo objectForKey:@"error"])
            kESCImageGalleryDownloader(_imageInfo);
    }
}

- (void)__showLoading
{
    if (!self.loading) {
        self.loading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _loading.layer.cornerRadius = 3.5;
        _loading.backgroundColor = [UIColor blackColor];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.center = CGPointMake(22, 22);
        [_loading addSubview:indicatorView];
        [indicatorView startAnimating];
    }
    _loading.center = self.center;
    [self.superview addSubview:_loading];
}

- (void)__hideLoading
{
    [self.loading removeFromSuperview];
}

#pragma mark- init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 1.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark- frame 
- (void)setFrame:(CGRect)frame
{
    BOOL isNeedLayoutSubviews = fabsf(self.frame.size.width-frame.size.width) > 0.1 || fabsf(self.frame.size.height-frame.size.height) > 0.1;
    [super setFrame:frame];
    if (isNeedLayoutSubviews) {
        [self layoutSubviews];
    }
}

- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width*self.zoomScale, self.frame.size.height*self.zoomScale);
    _loading.center = self.center;
}

#pragma mark- frame
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextRotateCTM(context, -M_PI_4);
    
    CGFloat angle = M_PI_4+atanf(rect.size.width/rect.size.height);
    CGFloat radius = sqrtf(powf(rect.size.width, 2)+powf(rect.size.height, 2))/2;
    CGFloat x = -radius*cosf(angle);
    CGFloat y = radius*sinf(angle);
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSString *holder0 = @"ESCImageGallery";
    NSString *holder1 = @"by";
    NSString *holder2 = @"LittoCats";
    
    CGSize size0 = [holder0 sizeWithAttributes:attribute];
    CGSize size1 = [holder1 sizeWithAttributes:attribute];
    CGSize size2 = [holder2 sizeWithAttributes:attribute];
    
    [holder0 drawAtPoint:CGPointMake(x-size0.width/2, y-size0.height/2-size1.height) withAttributes:attribute];
    [holder1 drawAtPoint:CGPointMake(x-size1.width/2, y-size1.height/2) withAttributes:attribute];
    [holder2 drawAtPoint:CGPointMake(x-size2.width/2, y-size2.height/2+size1.height) withAttributes:attribute];
    
    CGContextRestoreGState(context);
}

#pragma mark- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
@end
