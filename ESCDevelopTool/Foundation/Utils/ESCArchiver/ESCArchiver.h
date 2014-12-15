//
//  ESCArchiver.h
//  ESCDevelopKit
//
//  Created by 程巍巍 on 10/29/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#ifndef ESCDevelopKit_ESCArchiver_h
#define ESCDevelopKit_ESCArchiver_h
typedef NS_ENUM(NSInteger, ESCArchiveType) {
    ESCArchiveTypeZip,              // .zip
    
    //    ESCArchiveTypeTar
};
typedef NS_ENUM(NSInteger, ESCArchiveError) {
    ESCArchiveErrorFileNotExist,        //
    ESCArchiveErrorFileAlreadyExist,
    ESCArchiveErrorDestinationDirInvalid,
    ESCArchiveErrorOnArchiving,          //
    
    ESCArchiveErrorWriteToZipFaild,
    ESCArchiveErrorZipException,        //创建关闭 zip 文件异常
    ESCArchiveErrorZipOpenException,    //打开 zip 文件异常
    ESCArchiveErrorZipReadException,
    ESCArchiveErrorZipPasswordWrong,
};
@interface ESCArchiver : NSObject

/**
 *  打包
 *  @destinationDirectionary 压缩文件放置的文件夹，如果不在在，则自动创建，创建失败，则压缩失败
 *  @discussion 不要指定压缩文件名，压缩文件自动以 源文件夹或源文件名命名，并加上相应类型的后缀
 */
+ (NSString *)archive:(NSString *)sourcePath
                   to:(NSString *)destinationDirectionary
             withType:(ESCArchiveType)type
             password:(NSString *)password
            overWrite:(BOOL)overWrite
                error:(NSError *__autoreleasing*)error;

/**
 *  解包
 */
+ (NSString *)unArchive:(NSString *)packagePath
               to:(NSString *)destinationPath
         withType:(ESCArchiveType)type
         password:(NSString *)password
        overWrite:(BOOL)overWrite
            error:(NSError *__autoreleasing*)error;
@end


#endif
