//
//  ESCPDFGallery.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ESCPDFGalleyrMode) {
    ESCPDFGalleyrModeContinuousScroll,
    ESCPDFGalleyrModeSinglePage
};

@class ESCPDFDocument;
@interface ESCPDFGallery : UIView

@property (nonatomic, strong) ESCPDFDocument *document;

@property (nonatomic) ESCPDFGalleyrMode galleyrMode;

/**
 *  重用不在可视区域的 页面，默认为 NO。
 */
//@property (nonatomic) BOOL enableReuseQueue;

/**
 *  连续滚动时，上一页与下一页之间的空隙，默认值为 13.0f
 */
@property (nonatomic) CGFloat pageSpace;

/**
 *  滚动到指定的页码，并设置页面偏移量到指定的区域
 */
- (void)scrollToPage:(NSUInteger)pageIndex withOffset:(UIOffset)offset animated:(BOOL)animated;
@end
