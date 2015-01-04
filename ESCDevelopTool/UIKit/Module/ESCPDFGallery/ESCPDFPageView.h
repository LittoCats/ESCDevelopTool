//
//  ESCPDFPageView.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import <UIKit/UIKit.h>
#import "ESCPDFDocument.h"

@interface ESCPDFPageView : UIView

@property (nonatomic,weak) ESCPDFDocument *document;

@property (nonatomic) CGFloat scale;

@property (nonatomic) NSInteger pageNumber;

@end
