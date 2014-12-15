//
//  ESCArchive.m
//  ESCDevelopKit
//
//  Created by 程巍巍 on 10/28/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCArchiver.h"

#include "zip.h"
#include "unzip.h"

#include <zlib.h>
#include <zconf.h>

#import <objc/runtime.h>

#define checkError   if (*error) return nil
#define Error(errorCode) [ESCArchiver _errorWithCode:errorCode]

#define Extension(type)    [ESCArchiver _extensionWithType:type]

@interface ESCArchiver ()
{
    NSDate *Date1980;
}

@property (nonatomic, strong) NSString *sourcePath;
@property (nonatomic, strong) NSString *destinationPath;
@property (nonatomic) BOOL isDirectory;
@property (nonatomic) ESCArchiveType type;
@property (nonatomic, strong) NSString *password;
@property (nonatomic) BOOL overWrite;

@end
@implementation ESCArchiver

+ (NSString *)archive:(NSString *)path
             to:(NSString *)destinationDirectionary
       withType:(ESCArchiveType)type
       password:(NSString *)password
      overWrite:(BOOL)overWrite
          error:(NSError *__autoreleasing *)error
{
    NSString *sourcePath = [path stringByResolvingSymlinksInPath];
    //检查源文件夹/文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:sourcePath isDirectory:&isDirectory]) {
        *error = Error(ESCArchiveErrorFileNotExist);
        checkError;
    }
    
    //未指定目标路径，则使用源所在路径
    if (!destinationDirectionary) destinationDirectionary = [path stringByDeletingLastPathComponent];
    //生成目标路径
    BOOL directory;
    destinationDirectionary = [destinationDirectionary stringByResolvingSymlinksInPath];
    if ([fileManager fileExistsAtPath:destinationDirectionary isDirectory:&directory]) {
        if (!directory) {
            *error = Error(ESCArchiveErrorDestinationDirInvalid);
            checkError;
        }
    }else{
        [fileManager createDirectoryAtPath:destinationDirectionary withIntermediateDirectories:YES attributes:nil error:error];
        checkError;
    }
    //目标文件名
    NSString *destinationFile = [destinationDirectionary stringByAppendingPathComponent:[[[sourcePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:Extension(type)]];
    
    if ([fileManager fileExistsAtPath:destinationFile isDirectory:&directory] || directory) {
        if (overWrite) {
            [fileManager removeItemAtPath:destinationFile error:error];
            checkError;
        }else{
            *error = Error(ESCArchiveErrorFileAlreadyExist);
            checkError;
        }
    }
    
    //创建实例，如果 destinationName 任务已存在，则生成实例失败
    ESCArchiver *archiver = [self archiverWithDestinationFile:destinationFile error:error];
    checkError;
    archiver.sourcePath = sourcePath;
    archiver.destinationPath = destinationFile;
    archiver.type = type;
    archiver.password = password;
    archiver.overWrite = overWrite;
    archiver.isDirectory = isDirectory;
    
    //打包
    switch (archiver.type) {
        case ESCArchiveTypeZip:
            [archiver _zip:error];
            break;
            
        default:
            break;
    }
    checkError;
    return archiver.destinationPath;
}

+ (NSString *)unArchive:(NSString *)packagePath
                     to:(NSString *)destinationDirectionary
               withType:(ESCArchiveType)type
               password:(NSString *)password
              overWrite:(BOOL)overWrite
                  error:(NSError *__autoreleasing *)error
{
    BOOL isDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查文件是否存在
    if (![fileManager fileExistsAtPath:packagePath isDirectory:&isDirectory] || isDirectory) {
        *error = Error(ESCArchiveErrorZipException);
        checkError;
    }
    //未指定目标路径，则使用源所在路径
    if (!destinationDirectionary) destinationDirectionary = [packagePath stringByDeletingLastPathComponent];
    //生成目标路径
    BOOL directory;
    destinationDirectionary = [destinationDirectionary stringByResolvingSymlinksInPath];
    if ([fileManager fileExistsAtPath:destinationDirectionary isDirectory:&directory]) {
        if (!directory) {
            *error = Error(ESCArchiveErrorDestinationDirInvalid);
            checkError;
        }
    }else{
        [fileManager createDirectoryAtPath:destinationDirectionary withIntermediateDirectories:YES attributes:nil error:error];
        checkError;
    }
    
    //创建实例，如果 packagePath 任务已存在，则生成实例失败
    ESCArchiver *archiver = [self archiverWithDestinationFile:packagePath error:error];
    checkError;
    archiver.sourcePath = packagePath;
    archiver.destinationPath = destinationDirectionary;
    archiver.type = type;
    archiver.password = password;
    archiver.overWrite = overWrite;
    
    //解包
    switch (archiver.type) {
        case ESCArchiveTypeZip:
            [archiver _unZipFile:archiver.sourcePath toDirectory:archiver.destinationPath];
            break;
            
        default:
            break;
    }
    checkError;
    return archiver.destinationPath;
}

#pragma mark- init
+ (instancetype)archiverWithDestinationFile:(NSString *)destinationFile error:(NSError *__autoreleasing*)error
{
    @synchronized(self){
        static NSMapTable *table;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            table = [NSMapTable strongToWeakObjectsMapTable];
        });
        ESCArchiver *archiver = [table objectForKey:destinationFile];
        if (archiver) {
            *error = Error(ESCArchiveErrorOnArchiving);
            return nil;
        }
        archiver = [[ESCArchiver alloc] init];
        [table setObject:archiver forKey:destinationFile];
        return archiver;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        Date1980 = [formatter dateFromString:@"1980-01-01"];
    }
    return self;
}

#pragma mark- zipArchive and unZipArchive
- (void)_zip:(NSError *__autoreleasing*)error
{
    //初始化 zipFile
    zipFile zip = zipOpen([_destinationPath UTF8String], 0);
    if (!zip) {
        *error = Error(ESCArchiveErrorZipException);
        return;
    }
    //分析文件目录对应关系
    NSMutableDictionary *sourceTable = [NSMutableDictionary new];
    if (!_isDirectory) [sourceTable setObject:_sourcePath forKey:_destinationPath];
    else [ESCArchiver analyseDirectory:_sourcePath withRelativePath:@"" table:&sourceTable];
    
    //压缩
    for (NSString *key in sourceTable) {
        *error = [self _addFile:[sourceTable objectForKey:key] toZip:zip withName:key];
        if (*error) return;
    }
    BOOL ret = zipClose(zip,NULL) == Z_OK ? YES : NO;
    if (!ret) *error = Error(ESCArchiveErrorZipException);
}
- (NSError *)_addFile:(NSString *)file toZip:(zipFile)zip withName:(NSString *)name
{
    time_t current;
    time( &current );
    
    zip_fileinfo zipInfo = {0};
    zipInfo.dosDate = (unsigned long) current;
    
    NSError* error = nil;
    NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&error];
    if( error == nil && attr ){
        NSDate* fileDate = (NSDate*)[attr objectForKey:NSFileModificationDate];
        if( fileDate ){
            zipInfo.dosDate = [fileDate timeIntervalSinceDate:Date1980];
        }
    }
    int ret ;
    NSData* data = nil;
    if( [_password length] == 0){
        ret = zipOpenNewFileInZip( zip,
                                  (const char*) [name UTF8String],
                                  &zipInfo,
                                  NULL,0,
                                  NULL,0,
                                  NULL,//comment
                                  Z_DEFLATED,
                                  Z_DEFAULT_COMPRESSION );
    }else{
        data = [ NSData dataWithContentsOfFile:file];
        uLong crcValue = crc32( 0L,NULL, 0L );
        crcValue = crc32( crcValue, (const Bytef*)[data bytes], (unsigned int)[data length] );
        ret = zipOpenNewFileInZip3( zip,
                                   (const char*) [name UTF8String],
                                   &zipInfo,
                                   NULL,0,
                                   NULL,0,
                                   NULL,//comment
                                   Z_DEFLATED,
                                   Z_DEFAULT_COMPRESSION,
                                   0,
                                   15,
                                   8,
                                   Z_DEFAULT_STRATEGY,
                                   [_password cStringUsingEncoding:NSASCIIStringEncoding],
                                   crcValue );
    }
    if( ret!=Z_OK ){
        return Error(ESCArchiveErrorZipException);
    }
    if( data==nil ){
        data = [ NSData dataWithContentsOfFile:file];
    }
    unsigned int dataLen = (unsigned int)[data length];
    ret = zipWriteInFileInZip( zip, (const void*)[data bytes], dataLen);
    if( ret!=Z_OK ){
        return Error(ESCArchiveErrorWriteToZipFaild);
    }
    ret = zipCloseFileInZip(zip);
    if( ret!=Z_OK )
        return Error(ESCArchiveErrorZipException);
    return nil;
}

- (NSError *)_unZipFile:(NSString *)file toDirectory:(NSString *)directory
{
    unzFile unzip = unzOpen((const char*)[file UTF8String] );
    if(!unzip){
        return Error(ESCArchiveErrorZipException);
    }

    int ret = unzGoToFirstFile(unzip);
    unsigned char		buffer[4096] = {0};
    BOOL isDirectory = NO;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if( ret!=UNZ_OK ){
        return Error(ESCArchiveErrorZipOpenException);
    }
    do{
        //检查是否加密
        BOOL isEncrypt = unzIsEncrypted(unzip);
        if (isEncrypt) {
            if (_password.length == 0)
                return Error(ESCArchiveErrorZipPasswordWrong);
            ret = unzOpenCurrentFilePassword(unzip, [_password cStringUsingEncoding:NSASCIIStringEncoding]);
            if (ret != UNZ_OK)
                return Error(ESCArchiveErrorZipPasswordWrong);
        }else{
            ret = unzOpenCurrentFile(unzip);
            if( ret!=UNZ_OK )
                return Error(ESCArchiveErrorZipOpenException);
        }
        
        // reading data and write to file
        int read ;
        unz_file_info	fileInfo ={0};
        ret = unzGetCurrentFileInfo(unzip, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
        if( ret!=UNZ_OK ){
            unzCloseCurrentFile(unzip);
            return Error(ESCArchiveErrorZipOpenException);
        }
        char *filename = (char *)malloc( fileInfo.size_filename +1 );
        unzGetCurrentFileInfo(unzip, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
        filename[fileInfo.size_filename] = '\0';
        
        NSString* strPath = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
        NSString* fullPath = [directory stringByAppendingPathComponent:strPath];
        
        //文件是否已存在
        NSError *error;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDirectory] || isDirectory) {
            if (_overWrite) {
                [fileManager removeItemAtPath:fullPath error:&error];
                if (error) return error;
            }else{
                return Error(ESCArchiveErrorFileAlreadyExist);
            }
        }
        
        [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
        if( fileInfo.dosDate!=0 ){
            NSDate* orgDate = [[NSDate alloc]
                               initWithTimeInterval:(NSTimeInterval)fileInfo.dosDate
                               sinceDate:Date1980 ];
            
            NSDictionary* attr = [NSDictionary dictionaryWithObject:orgDate forKey:NSFileModificationDate];
            if( attr ) [[NSFileManager defaultManager] setAttributes:attr ofItemAtPath:fullPath error:&error];
            if (error) return error;
        }
        
        FILE* fp = fopen( (const char*)[fullPath UTF8String], "wb");
        while( fp ){
            read=unzReadCurrentFile(unzip, buffer, 4096);
            if(read > 0){
                fwrite(buffer, read, 1, fp );
            }else if(read < 0){
                fclose(fp);
                return Error(ESCArchiveErrorZipReadException);
            }else
                break;
        }
        if(fp) fclose( fp );
        unzCloseCurrentFile(unzip);
        ret = unzGoToNextFile(unzip);
    }while(ret == UNZ_OK);
    return nil;
}

#pragma mark- private util
+ (NSError *)_errorWithCode:(ESCArchiveError)code
{
    switch (code) {
        case ESCArchiveErrorFileNotExist:
            return [NSError errorWithDomain:@"ESCArchive error : file not exist ." code:code userInfo:nil];
            
        default:
            return nil;
    }
}

+ (NSString *)_extensionWithType:(ESCArchiveType)type
{
    switch (type) {
        case ESCArchiveTypeZip:
            return @"zip";
            
        default:
            return @"";
    }
}

+ (void)analyseDirectory:(NSString *)directory withRelativePath:(NSString *)relativePath table:(NSMutableDictionary *__autoreleasing*)table
{
    relativePath = [relativePath stringByAppendingPathComponent:[directory lastPathComponent]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isDirectory;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:&error];
    if (error) return;
    for (NSString *path in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:path];
        if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
            if (isDirectory) {
                [self analyseDirectory:filePath withRelativePath:relativePath table:table];
            }else{
                [*table setObject:filePath forKey:[relativePath stringByAppendingPathComponent:path]];
            }
        }
    }
}
@end