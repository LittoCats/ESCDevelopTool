//
//  ECSCoreData.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 10/29/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

/*
 
 结构图
 
             ******************************         *****************     *************
             *      BackgroundContext     *    ->   *     Save      * ->  *    PSD    *
             ******************************         *****************     *************
                         |
                         ^
                         |
                         -----<---------------------------------------<----
                                                                          ^
             ******************************         *****************     |
             *      BackgroundContext     *    ->   *     Save      * -----
             ******************************         *****************
                         |           |
                         ^           |					   ******************************    ***********************
                         |           ---------->-------->  *     Object did changed     * -> *     Update UIView   *  -> Alse task with UI
                         |                                 ******************************    ***********************
                         ^
                         |
                         ----------------------<-----------------------<-----<-----------
                                                                          ^             ^
             ******************************         *****************     |             |
             *      BackgroundContext     *  --->   *     Save      * -->--     ******************
             ******************************         *****************     |     *      Save      * <- AnyContext out of mainThread
                                                                          |     ******************
                                                                          ^
                                                                          |
             ******************************         *****************     |
             *      BackgroundContext     *  ---->   *     Save      * -->-
             ******************************         *****************
 
 */

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#ifndef ESCDevelopTool_ECSCoreData_h
#define ESCDevelopTool_ECSCoreData_h

#define ESCMOC(name) [ESCMOC contextNamed:name]

FOUNDATION_EXTERN const NSString *ESCMOCSaveErrorNotification;

@interface ESCCoreData : NSManagedObjectContext

//  同一个线中程，将返回同一个 context，了线程中的 context 数据在 save 时自动同步到主线程 context，
//  context 同步过程为异步执行，子线程中 save 完成，主线程中的数据同步可能有延迟，保存到文件可能进一步被延迟

/**
 *  获取当前线程中的 context
 *  name 为所要管理的 model
 *  不要在不同的线程中传递 NSManagedObjectContext / NSManagedObejct.
 *  需的context 的时候，一般情况下，应使用此方法获取，NSManagedObject 应由 [NSManagedObjectContext objectWithID:NSManagedObjectID] 获得
 *  Notice : 不允许重新设置 parentContext 及 persistentStoreCoordinator ,否则出错
 */
+ (instancetype)contextNamed:(NSString *)name;

/**
 *  insert
 */
- (NSManagedObject *)insertObjectToEntity:(NSString *)entityName;

/**
 *  查询数据
 *  @entityName 
 *  @limit
 *  @offset
 *  @sort NSSortDescriptor The sort descriptors specify how the objects returned when the fetch request is issued should be ordered—for example by last name then by first name. The sort descriptors are applied in the order in which they appear in the sortDescriptors array (serially in lowest-array-index-first order).A value of nil is treated as no sort descriptors.
 *  @predicate  The predicate is used to constrain the selection of objects the receiver is to fetch.
 */
- (NSArray *)fetchObjectInEntity:(NSString *)entityName
                       withLimit:(NSInteger)limit
                          offset:(NSInteger)offset
                            sort:(NSArray *(^)())sortDescriptors
                       predicate:(NSPredicate *(^)(NSDictionary *propertiesByName))predicate;
@end

//生成 NSPredicate 的工具方法
// id user = @{@"name":@"Zhangsan"};
// NSPredicateCreate(@"name == #{user.name}",user);

/**
 *  IOS6 以下没有 NSDictionaryOfVariableBindings 方法，需实现
 *  结果为 以变量名为 key 的字典
 */
#ifndef NSDictionaryOfVariableBindings//(...)
#define NSDictionaryOfVariableBindings(...) _ESCNSDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)
#endif

/**
 *  NSPredicateCreate(@"name == #{user.name}",NSDictionaryOfVariableBindings(user));
 *  description 为描述，#{} 代表值引用，值放在 varibaleBindings 中
 */
#define NSPredicateCreate(...) kNSPredicateCreate(__VA_ARGS__,nil)
#define kNSPredicateCreate(description, ...) __kESCPredicateCreate(description, __kESCNSDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__,nil))

FOUNDATION_EXTERN NSDictionary *__kESCNSDictionaryOfVariableBindings(NSString *variable, ...);   //you can't call this method directly forever
FOUNDATION_EXTERN NSPredicate *__kESCPredicateCreate(NSString *description, NSDictionary *variableBindings); //you can't call this method directly forever
#endif
