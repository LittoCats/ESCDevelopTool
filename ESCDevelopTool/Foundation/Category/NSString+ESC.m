//
//  NSString+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#import "NSString+ESC.h"
#import "Foundation+ESC.h"

@implementation NSString (ESC)


- (BOOL)isEmpty
{
    return self.length == 0;
}

- (id)toJSON
{
    NSError *error;
    id JSON = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    return JSON;
}

- (CGSize) sizeWithCTFont:(CTFontRef)fontRef constrainedToSize:(CGSize)constraint
{
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), (CFStringRef)self);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFStringGetLength((CFStringRef)self)), kCTFontAttributeName, fontRef);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    
    // compute size
    CGSize naturalSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, constraint, &fitRange);
    
    // clean up
    CFRelease(framesetter);
    CFRelease(attrString);
    
    float fontHeight = CTFontGetLeading(fontRef);
    naturalSize.height = MAX(fontHeight, naturalSize.height + 1);
    
    return naturalSize;
}
@end
