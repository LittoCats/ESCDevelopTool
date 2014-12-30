//
//  UIView+ESC_Script.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "UIView+ESC_Script.h"

#import <objc/runtime.h>

static const char *kUIView_ESC_Script_OptionsKey;
@implementation UIView (ESC_Script)

+ (id)allocWithOptions:(NSDictionary *)options
{
    id instance = [self alloc];
    objc_setAssociatedObject(instance, &kUIView_ESC_Script_OptionsKey, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return instance;
}

- (NSDictionary *)options
{
    return objc_getAssociatedObject(self, &kUIView_ESC_Script_OptionsKey);
}
@end
