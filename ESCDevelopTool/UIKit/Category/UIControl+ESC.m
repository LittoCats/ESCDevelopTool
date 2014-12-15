//
//  UIControl+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/1/14.
//	Copyright (c) 12/1/14 Littocats. All rights reserved.
//

#import "UIControl+ESC.h"

#import <objc/runtime.h>

#define kESCBLOCKHANDLER(event) +(void)event:(id)sender{[sender __CallControlBlock:event];}
#define kESCBLOCKEVENTTYPE(eventType) if ((event & eventType) == eventType) [eventNames addObject:@"" # eventType]
#define kESCCONTROLEVENTNAMED(eventName) if ([name isEqualToString:@"" # eventName]) return eventName

static const char *kESCUIControlBlockOperationsKey;

@interface ____UIControlBlockEventHandler : NSObject

- (void)__CallControlBlock:(UIControlEvents)event;
@end

@implementation ____UIControlBlockEventHandler

kESCBLOCKHANDLER(UIControlEventTouchDown)
kESCBLOCKHANDLER(UIControlEventTouchDownRepeat)
kESCBLOCKHANDLER(UIControlEventTouchDragInside)
kESCBLOCKHANDLER(UIControlEventTouchDragOutside)
kESCBLOCKHANDLER(UIControlEventTouchDragEnter)
kESCBLOCKHANDLER(UIControlEventTouchDragExit)
kESCBLOCKHANDLER(UIControlEventTouchUpInside)
kESCBLOCKHANDLER(UIControlEventTouchUpOutside)
kESCBLOCKHANDLER(UIControlEventTouchCancel)
kESCBLOCKHANDLER(UIControlEventValueChanged)
kESCBLOCKHANDLER(UIControlEventEditingDidBegin)
kESCBLOCKHANDLER(UIControlEventEditingChanged)
kESCBLOCKHANDLER(UIControlEventEditingDidEnd)
kESCBLOCKHANDLER(UIControlEventEditingDidEndOnExit)
kESCBLOCKHANDLER(UIControlEventAllTouchEvents)
kESCBLOCKHANDLER(UIControlEventAllEditingEvents)
kESCBLOCKHANDLER(UIControlEventApplicationReserved)
kESCBLOCKHANDLER(UIControlEventSystemReserved)
kESCBLOCKHANDLER(UIControlEventAllEvents)

+(NSArray *)__eventName:(UIControlEvents)event
{
    NSMutableArray *eventNames = [NSMutableArray new]               ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchDown)                     ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchDownRepeat)               ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchDragInside)               ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchDragOutside)              ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchDragEnter)                ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchDragExit)                 ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchUpInside)                 ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchUpOutside)                ;
    kESCBLOCKEVENTTYPE(UIControlEventTouchCancel)                   ;
    kESCBLOCKEVENTTYPE(UIControlEventValueChanged)                  ;
    kESCBLOCKEVENTTYPE(UIControlEventEditingDidBegin)               ;
    kESCBLOCKEVENTTYPE(UIControlEventEditingChanged)                ;
    kESCBLOCKEVENTTYPE(UIControlEventEditingDidEnd)                 ;
    kESCBLOCKEVENTTYPE(UIControlEventEditingDidEndOnExit)           ;
    kESCBLOCKEVENTTYPE(UIControlEventApplicationReserved)           ;
    kESCBLOCKEVENTTYPE(UIControlEventSystemReserved)                ;
    
    return eventNames;
}

+(UIControlEvents)__ControlEventWithName:(NSString *)name
{
    kESCCONTROLEVENTNAMED(UIControlEventTouchDown);
    kESCCONTROLEVENTNAMED(UIControlEventTouchDownRepeat);
    kESCCONTROLEVENTNAMED(UIControlEventTouchDragInside);
    kESCCONTROLEVENTNAMED(UIControlEventTouchDragOutside);
    kESCCONTROLEVENTNAMED(UIControlEventTouchDragEnter);
    kESCCONTROLEVENTNAMED(UIControlEventTouchDragExit);
    kESCCONTROLEVENTNAMED(UIControlEventTouchUpInside);
    kESCCONTROLEVENTNAMED(UIControlEventTouchUpOutside);
    kESCCONTROLEVENTNAMED(UIControlEventTouchCancel);
    kESCCONTROLEVENTNAMED(UIControlEventTouchDown);
    kESCCONTROLEVENTNAMED(UIControlEventValueChanged);
    kESCCONTROLEVENTNAMED(UIControlEventEditingDidBegin);
    kESCCONTROLEVENTNAMED(UIControlEventEditingChanged);
    kESCCONTROLEVENTNAMED(UIControlEventEditingDidEnd);
    kESCCONTROLEVENTNAMED(UIControlEventEditingDidEndOnExit);
    kESCCONTROLEVENTNAMED(UIControlEventAllTouchEvents);
    kESCCONTROLEVENTNAMED(UIControlEventAllEditingEvents);
    kESCCONTROLEVENTNAMED(UIControlEventApplicationReserved);
    kESCCONTROLEVENTNAMED(UIControlEventSystemReserved);
    kESCCONTROLEVENTNAMED(UIControlEventAllEvents);
    return UIControlEventAllEvents;
}

- (void)__CallControlBlock:(UIControlEvents)event{}
@end

@implementation UIControl (ESC)

- (void)handleControlEvents:(UIControlEvents)events
                  withBlock:(void(^)(id sender/* UIControl or subClass*/, UIControlEvents event))block
{
    NSArray *methodsName = [____UIControlBlockEventHandler __eventName:events];
    NSMapTable *operations = [self __ControlOperations];
    
    [methodsName enumerateObjectsUsingBlock:^(id methodName, NSUInteger idx, BOOL *stop) {
        if (block) {
            [operations setObject:block forKey:methodName];
            [self addTarget:____UIControlBlockEventHandler.class action:NSSelectorFromString([methodName stringByAppendingString:@":"]) forControlEvents:[____UIControlBlockEventHandler __ControlEventWithName:methodName]];
        }else{
            [operations removeObjectForKey:methodName];
            [self removeTarget:____UIControlBlockEventHandler.class action:NSSelectorFromString([methodName stringByAppendingString:@":"]) forControlEvents:[____UIControlBlockEventHandler __ControlEventWithName:methodName]];
        }
    }];
}

#pragma mark-
- (void)__CallControlBlock:(UIControlEvents)event {
    NSMapTable *operations = [self __ControlOperations];
    
    if(operations == nil || operations.count == 0) return;
    void(^block)(id, UIControlEvents) = [operations objectForKey:[[____UIControlBlockEventHandler __eventName:event] firstObject]];
    
    if (block) block(self, event);
}

#pragma mark- handle block
- (NSMapTable *)__ControlOperations
{
    NSMapTable *operations = (NSMapTable*)objc_getAssociatedObject(self, &kESCUIControlBlockOperationsKey);
    if(operations == nil)
    {
        operations = [NSMapTable strongToStrongObjectsMapTable];
        objc_setAssociatedObject(self, &kESCUIControlBlockOperationsKey, operations, OBJC_ASSOCIATION_RETAIN);
    }
    return operations;
}

@end
