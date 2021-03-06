//
//  NSString+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_NSString_ESC
#define ESCDevelopTool_NSString_ESC

#import <Foundation/Foundation.h>

#import <CoreText/CoreText.h>

@interface NSString (ESC)

- (BOOL)isEmpty;

- (id)toJSON;

- (CGSize) sizeWithCTFont:(CTFontRef)fontRef constrainedToSize:(CGSize)constraint;

@end

#endif