//
//  ESCPDFPageView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import "ESCPDFPageView.h"

@implementation ESCPDFPageView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor( context, 1, 1.0, 1.0, 1.0 );
    CGContextFillRect( context, self.bounds );
    
    CGContextTranslateCTM( context, 0.0, self.bounds.size.height );
    CGContextScaleCTM( context, self.scale, -self.scale );
    
    
    
    [[self.document pageWithPageNumber:self.pageNumber+1] drawContext:context];
}

@end
