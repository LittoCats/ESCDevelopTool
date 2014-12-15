//
//  ESCImageGallery+Private.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/12/14.
//	Copyright (c) 12/12/14 Littocats. All rights reserved.
//

#import "ESCImageGallery+Private.h"

@implementation ESCImageGallery (ScrollView)

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger tag = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    UIView *image_m = [self __viewWithTag:tag];
    UIView *image_l = [self __viewWithTag:tag-1];
    UIView *image_r = [self __viewWithTag:tag+1];
    
    if (!image_m) {
        UIView *image_n = [self __imageViewNotUsed:tag];
        image_n.tag = tag;
    }
    if (!image_l && tag-1>=0) {
        UIView *image_n = [self __imageViewNotUsed:tag];
        image_n.tag = tag-1;
    }
    if (!image_r && tag+1<self.images.count) {
        UIView *image_n = [self __imageViewNotUsed:tag];
        image_n.tag = tag+1;
    }
    
    [self __updateImageView];
}

#pragma mark- 
- (UIView *)__viewWithTag:(NSInteger)tag
{
    if (tag == self.imageView0.tag) return self.imageView0;
    if (tag == self.imageView1.tag) return self.imageView1;
    if (tag == self.imageView2.tag) return self.imageView2;
    return nil;
}

- (UIView *)__imageViewNotUsed:(NSInteger)tag
{
    if (tag != self.imageView0.tag && tag-1 != self.imageView0.tag && tag+1 != self.imageView0.tag) return self.imageView0;
    if (tag != self.imageView1.tag && tag-1 != self.imageView1.tag && tag+1 != self.imageView1.tag) return self.imageView1;
    if (tag != self.imageView2.tag && tag-1 != self.imageView2.tag && tag+1 != self.imageView2.tag) return self.imageView2;
    return nil;
}
@end
