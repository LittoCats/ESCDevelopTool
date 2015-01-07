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

@property (nonatomic) CGImageSourceRef imgSource;

@property (nonatomic, strong) NSDictionary *properties;

//@property (nonatomic) ESCImageType type;
//
//@property (nonatomic) CGSize size;
//
//@property (nonatomic) NSInteger fileSize;
//
//@property (nonatomic) NSInteger depth;
//
//@property (nonatomic) NSInteger dpi;
//
//@property (nonatomic) BOOL hasAlpha;
//
//@property (nonatomic) ESCImageColorModel colorModel;
//
//@property (nonatomic, strong) NSString *profileName;

@end

#endif
