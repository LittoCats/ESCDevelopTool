//
//  FreeImeDB.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/22/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Hans;

typedef NS_ENUM(char, FreeImeDBKeyType) {
    FreeImeDBKeyTypeWubi,
    FreeImeDBKeyTypePinyin
};

@interface FreeImeDB : NSManagedObjectContext

@property (nonatomic, strong) NSEntityDescription *freeWuBi;
@property (nonatomic, strong) NSEntityDescription *freePinYin;
@property (nonatomic, strong) NSEntityDescription *hans;

/**
 *  单例
 */
+ (instancetype)db;

- (NSArray *)hansForKey:(NSString *)key type:(FreeImeDBKeyType)type;

@end

@protocol FreeIMETableProtocol <NSObject>

@property (nonatomic, readonly) Hans *value;

@end
