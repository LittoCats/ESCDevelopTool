//
//  UIView+ESC_Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#ifndef ESCDevelopTool_UIView_ESC_Private_h
#define ESCDevelopTool_UIView_ESC_Private_h

#import <objc/runtime.h>

#import "UIView+ESC.h"

#import "__ESCIndicatorView.h"

#import "__ESCToastView.h"

UIKIT_EXTERN void __ESCExchangeMethodImplementation(Class class,SEL selector1, BOOL isClassMethod1,SEL selector2, BOOL isClassMethod2);

const char *kESCViewOverlaysKey;

const char *kESCViewToastKey;

const char *kESCViewIndicatorKey;

@interface UIView (ESC_Private)

@property (nonatomic, readonly) NSPointerArray *overlays;

@end

#endif
