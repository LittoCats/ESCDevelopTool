//
//  ESCRuntime.c
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#include <stdio.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


void __ESCExchangeMethodImplementation(Class class,SEL selector1, BOOL isClassMethod1,SEL selector2, BOOL isClassMethod2)
{
    Method methodSrc = isClassMethod1 ? class_getClassMethod(class, selector1) : class_getInstanceMethod(class, selector1);
    Method methodDes = isClassMethod2 ? class_getClassMethod(class, selector2) : class_getInstanceMethod(class, selector2);
    
    method_exchangeImplementations(methodSrc, methodDes);
}