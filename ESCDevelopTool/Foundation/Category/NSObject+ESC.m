//
//  NSObject+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//	Copyright (c) 11/26/14 Littocats. All rights reserved.
//

#import "NSObject+ESC.h"

#import <objc/runtime.h>

@implementation NSObject (ESC)

@dynamic uniqueId;
static const char *kESCUniqueIdKey;
- (NSString *)uniqueId
{
    NSString *uniqueId = objc_getAssociatedObject(self, &kESCUniqueIdKey);
    if (!uniqueId){
        uniqueId = [[NSString alloc] initWithFormat:@"%@_%p",self.class,self];
        objc_setAssociatedObject(self, &kESCUniqueIdKey, uniqueId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSObject __ESC_ObjectMap] setObject:self forKey:uniqueId];
    }
    return uniqueId;
}

- (id)objectWithId:(NSString *)uniqueId
{
    return [[NSObject __ESC_ObjectMap] objectForKey:uniqueId];
}

- (BOOL)isEmpty
{
    return self == (NSObject *)NSNull.null;
}

+ (NSCache *)cache
{
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        cache.name = @"ESCDevelopTool universul cache";
    });
    return cache;
}

#pragma mark- private method
+ (NSMapTable *)__ESC_ObjectMap
{
    static NSMapTable *objectMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectMap = [NSMapTable weakToWeakObjectsMapTable];
    });
    return objectMap;
}

@end
