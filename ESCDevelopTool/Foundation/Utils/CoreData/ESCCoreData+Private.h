//
//  ESCCoreData+Private.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/14/14.
//	Copyright (c) 12/14/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_ESCCoreData_Private
#define ESCDevelopTool_ESCCoreData_Private

#define kBGMOC_NAME(name) [NSString stringWithFormat:@"ESCMOC_BACKGROUNDCONTEXT_%@",name]
#define kMAMOC_NAME(name) [NSString stringWithFormat:@"ESCMOC_MAINCONTEXT_%@",name]
#define kCUMOC_NAME(name, thread) [NSString stringWithFormat:@"ESCMOC_CUINCONTEXT_%p_%@",thread,name]

#define kESCMOCERROR_TYPE(propertyName, propertyClass) [NSError errorWithDomain:[NSString stringWithFormat:@"ESCCoreDataContext insert error : property < %@ > need value with Type %@ .",propertyName,propertyClass] code:0 userInfo:nil]

#import "ESCCoreData.h"

@interface ESCCoreData ()

@property (nonatomic, strong) NSString *name;

@end

@interface ESCCoreData (Private)

+ (instancetype)ancestContextWithName:(NSString *)name;

- (void)excuteBlock:(void (^)())block;

@end

@interface ESCCoreDataMain : ESCCoreData

@end

#endif