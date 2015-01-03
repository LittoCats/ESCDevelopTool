//
//  ESCPDFPageView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import "ESCPDFPageView.h"

#import "UIImage+ESC.h"
#import "UIColor+ESC.h"

@implementation ESCPDFPageView

- (void)setPageNumber:(NSInteger)pageNumber
{
    _pageNumber = pageNumber;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithSize:self.frame.size colors:@[[UIColor randomColor],[UIColor randomColor],[UIColor randomColor]] gradientDirection:M_PI_2-0.3]];
}

@end
