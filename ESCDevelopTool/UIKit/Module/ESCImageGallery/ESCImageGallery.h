//
//  ESCImageGallery.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/12/14.
//
//

#import <UIKit/UIKit.h>

@protocol ESCImageGalleryDelegate;

@interface ESCImageGallery : UIView

/**
 *  图片信息，可以是 imageFilePath/imageurl/UIImage
 */
- (void)setImages:(NSArray *)images;
- (UIImage *)imageAtIndex:(NSInteger)index;
- (void)removeImageAtIndex:(NSInteger)index;
- (void)insertImage:(id/* imageFilePath/imageurl/UIImage */)image atIndex:(NSInteger)index;

@property (nonatomic, readonly) NSInteger imageCount;

@property (nonatomic, weak) id<ESCImageGalleryDelegate> delegate;
@end

@protocol ESCImageGalleryDelegate <NSObject>

/**
 *  初始化 image 数据时，会先调用此委托
 *  @info images 中的值，可通过此委托传入缓存的 image 数据。
 *  @return 如果返回 非 UIImage 对像，将自行决定加载数据的方法
 */
- (UIImage *)imageGallery:(ESCImageGallery *)imageGallery imageWithInfo:(id)info;

- (UIImage *)imageGallery:(ESCImageGallery *)imageGallery imageHolderWithInfo:(id)info;

@end