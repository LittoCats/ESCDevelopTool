//
//  ESCImage+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/6/15.
//
//

#ifndef ESCDevelopTool_ESCImage_Private_h
#define ESCDevelopTool_ESCImage_Private_h

#import "ESCImage.h"

@interface ESCImage ()
{
    CGImageSourceRef imgSource;
}

@property (nonatomic) ESCImageType type;

@property (nonatomic) CGSize size;

@property (nonatomic) NSInteger dpi;

@end

#endif
