//
//  ESCCrypt.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCCrypt : NSObject

+ (NSString *)MD5Encrypt:(const NSData *)data;
+ (NSString *)MD5EncryptWithFilePath:(const NSString *)path;
+ (NSString *)MD5Encrypt:(const NSData *)data withPaddingData:(const NSData *)paddingData length:(const NSInteger)length;

+ (NSString *)BASE64Encrypt:(const NSData *)data;
+ (NSData *)BASE64Decrypt:(const NSString *)data;

+ (NSString *)BASE16Encrypt:(const NSData *)data;
+ (NSData *)BASE16Decrypt:(const NSString *)data;

+ (NSData *)AES128Encrypt:(const NSData *)data withPassword:(const NSString *)password;
+ (NSData *)AES128Decrypt:(const NSData *)encryptedData withPassword:(const NSString *)password;

+ (NSData *)AES192Encrypt:(const NSData *)data withPassword:(const NSString *)password;
+ (NSData *)AES192Decrypt:(const NSData *)encryptedData withPassword:(const NSString *)password;

+ (NSData *)AES256Encrypt:(const NSData *)data withPassword:(const NSString *)password;
+ (NSData *)AES256Decrypt:(const NSData *)encryptedData withPassword:(const NSString *)password;

+ (NSData *)DESEncrypt:(const NSData *)data withPassword:(const NSString *)password;
+ (NSData *)DESDecrypt:(const NSData *)encryptedData withPassword:(const NSString *)password;

+ (NSData *)DES3Encrypt:(NSData *)data withPassword:(NSString *)password;
+ (NSData *)DES3Decrypt:(NSData *)encryptedData withPassword:(NSString *)password;

#if TARGET_OS_IPHONE
+ (NSData *)RSAEncrypt:(NSData *)data withPrivateKey:(NSData *)keyData password:(NSString *)password;
+ (NSData *)RSADecrypt:(NSData *)encryptedData withPublickKey:(NSData *)keyData;
#endif
@end
