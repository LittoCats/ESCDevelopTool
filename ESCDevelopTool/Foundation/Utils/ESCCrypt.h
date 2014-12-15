//
//  ESCCrypt.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCCrypt : NSObject

+ (NSString *)MD5Encrypt:(NSData *)data;
+ (NSString *)MD5EncryptWithFilePath:(NSString *)path;
+ (NSString *)MD5Encrypt:(NSData *)data withPaddingData:(NSData *)paddingData length:(NSInteger)length;

+ (NSString *)BASE64Encrypt:(NSData *)data;
+ (NSData *)BASE64Decrypt:(NSString *)data;

+ (NSString *)BASE16Encrypt:(NSData *)data;
+ (NSData *)BASE16Decrypt:(NSString *)data;

+ (NSData *)AES128Encrypt:(NSData *)data withPassword:(NSString *)password;
+ (NSData *)AES128Decrypt:(NSData *)encryptedData withPassword:(NSString *)password;

+ (NSData *)AES192Encrypt:(NSData *)data withPassword:(NSString *)password;
+ (NSData *)AES192Decrypt:(NSData *)encryptedData withPassword:(NSString *)password;

+ (NSData *)AES256Encrypt:(NSData *)data withPassword:(NSString *)password;
+ (NSData *)AES256Decrypt:(NSData *)encryptedData withPassword:(NSString *)password;

+ (NSData *)DESEncrypt:(NSData *)data withPassword:(NSString *)password;
+ (NSData *)DESDecrypt:(NSData *)encryptedData withPassword:(NSString *)password;

+ (NSData *)DES3Encrypt:(NSData *)data withPassword:(NSString *)password;
+ (NSData *)DES3Decrypt:(NSData *)encryptedData withPassword:(NSString *)password;

+ (NSData *)RSAEncrypt:(NSData *)data withPrivateKey:(NSData *)keyData password:(NSString *)password;
+ (NSData *)RSADecrypt:(NSData *)encryptedData withPublickKey:(NSData *)keyData;

@end
