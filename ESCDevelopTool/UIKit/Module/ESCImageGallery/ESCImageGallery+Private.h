//
//  ESCImageGallery+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/12/14.
//	Copyright (c) 12/12/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_ESCImageGallery_Private
#define ESCDevelopTool_ESCImageGallery_Private

#import "ESCImageGallery.h"

UIKIT_EXTERN void kESCImageGalleryDownloader(NSMutableDictionary *imageInfo);

@class __ESCImageView;
@interface ESCImageGallery ()

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) __ESCImageView *imageView0;
@property (nonatomic, strong) __ESCImageView *imageView1;
@property (nonatomic, strong) __ESCImageView *imageView2;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

- (void)__updateImageView;
@end

@interface ESCImageGallery (Private)

- (NSDictionary *)__imageWithInfo:(id)info;
@end

@interface ESCImageGallery (UIScrollView)<UIScrollViewDelegate>

@end

@interface __ESCImageView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) NSMutableDictionary *imageInfo;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *loading;

- (void)__updateImage;

- (void)__showLoading;
- (void)__hideLoading;
@end

#endif