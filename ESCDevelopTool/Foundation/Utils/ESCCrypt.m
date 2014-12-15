//
//  ESCEncrypt.m
//  ESCDevelopKit
//
//  Created by 程巍巍 on 14-10-17.
//  Copyright (c) 2014年 Littocats. All rights reserved.
//

#import "ESCCrypt.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation ESCCrypt

#pragma mark- MD5
+ (NSString *)MD5Encrypt:(NSData *)data
{
    const void *cData = [data bytes];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cData, (CC_LONG)data.length, md);
    
    char mBuffer[CC_MD5_DIGEST_LENGTH*2] = {0};
    void *p = mBuffer;
    for (int index = 0; index < CC_MD5_DIGEST_LENGTH; index ++) {
        sprintf(p, "%.2X",md[index]);
        p += 2;
    }
    
    return [[NSString alloc] initWithBytes:mBuffer length:CC_MD5_DIGEST_LENGTH*2 encoding:NSUTF8StringEncoding];
}

+ (NSString *)MD5EncryptWithFilePath:(NSString *)path;
{
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
    if (!inputStream) return nil;
    
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) return nil;
    
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    BOOL hasMoreData = YES;
    UInt8 *buffer = malloc(4096);
    while (hasMoreData) {
        NSUInteger readBytesCount = [inputStream read:buffer maxLength:4096];
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,
                      (const void *)buffer,
                      (CC_LONG)readBytesCount);
    }
    free(buffer);
    
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(md, &hashObject);
    
    char mBuffer[CC_MD5_DIGEST_LENGTH*2] = {0};
    void *p = mBuffer;
    for (int index = 0; index < CC_MD5_DIGEST_LENGTH; index ++) {
        sprintf(p, "%.2X",md[index]);
        p += 2;
    }
    
    return [[NSString alloc] initWithBytes:mBuffer length:CC_MD5_DIGEST_LENGTH*2 encoding:NSUTF8StringEncoding];
}

+ (NSString *)MD5Encrypt:(NSData *)data withPaddingData:(NSData *)paddingData length:(NSInteger)length
{
    if (data.length >= length) {
        data = [data subdataWithRange:NSMakeRange(0, length)];
        return [self MD5Encrypt:data];
    }
    
    if (!paddingData || !paddingData.length) {
        char *buffer = malloc(sizeof(char) * (data.length - length));
        memset(buffer, ' ', sizeof(char) * (data.length - length));
        paddingData = [[NSData alloc] initWithBytesNoCopy:buffer length:sizeof(char) * (data.length - length)];
    }
    
    NSMutableData *datam = [NSMutableData dataWithData:data];
    while (datam.length < length) {
        [datam appendData:paddingData];
    }
    return [self MD5Encrypt:datam];
}

#pragma mark- Base16
static const char base16_table[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
+ (NSString *)BASE16Encrypt:(NSData *)data
{
    const char *bytes = [data bytes];
    char *buffer = malloc(sizeof(char)*[data length]*2+1);
    buffer[sizeof(char)*[data length]*2] = '\0';
    
    for (int i = 0; i < data.length; i ++) {
        UInt8 c = *(bytes+i);
        buffer[i*2] = base16_table[(c & 0xF0) >> 4];
        buffer[i*2+1] = base16_table[c & 0xF];
    }
    
    NSString *ret = [[NSString alloc] initWithCString:buffer encoding:NSUTF8StringEncoding];
    free(buffer);
    return ret;
}

static const char deBase16_table[] = {
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};

+ (NSData *)BASE16Decrypt:(NSString *)data
{
    if (data.length%2 != 0) {
        return nil;
    }
    
    const char *bytes = [data UTF8String];
    char *buffer = malloc(sizeof(char)*data.length/2);
    
    for (int i = 0; i < data.length; i += 2) {
        buffer[i/2] = ((deBase16_table[bytes[i]]) << 4) | (deBase16_table[bytes[i+1]]);
    }
    
    return [[NSData alloc] initWithBytesNoCopy:buffer length:sizeof(char)*data.length/2];
}

#pragma mark- Base64
static const char base64_table[64] =   {'A','B','C','D','E','F','G','H',
    'I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X',
    'Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n',
    'o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3',
    '4','5','6','7','8','9','+','/'};

+ (NSString *)BASE64Encrypt:(NSData *)data
{
    const char *srcData = [data bytes];
    NSInteger destLenght = (data.length/3 + ((data.length) % 3 ? 1 : 0)) * 4;
    unsigned char *destData = malloc(sizeof(char)*destLenght);
    unsigned char *base = destData;
    double index = data.length / 3;
    while (index --) {
        base[0] = base64_table[srcData[0] >> 2];
        base[1] = base64_table[(srcData[0] & 0b11) << 4 | (srcData[1] >> 4)];
        base[2] = base64_table[(srcData[1] & 0b1111) << 2 | (srcData[2] >> 6)];
        base[3] = base64_table[srcData[2] & 0b111111];
        srcData += 3;
        base += 4;
    }
    if (data.length%3 == 1) {
        base[0] = base64_table[srcData[0] >> 2];
        base[1] = base64_table[(srcData[0] & 0b11) << 4 | 0];
        base[2] = '=';
        base[3] = '=';
    }else if (data.length%3 == 2){
        base[0] = base64_table[srcData[0] >> 2];
        base[1] = base64_table[(srcData[0] & 0b11) << 4 | (srcData[1] >> 4)];
        base[2] = base64_table[(srcData[1] & 0b1111) << 2 | 0];
        base[3] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:destData length:destLenght encoding:NSUTF8StringEncoding freeWhenDone:YES];
}
static const char deBase64_table[] =   {
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3E,0x00,0x00,0x00,0x3F,
    0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,
    0x0F,0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x00,0x00,0x00,0x00,0x00,
    0x00,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F,0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,
    0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,0x30,0x31,0x32,0x33,0x00,0x00,0x00,0x00,0x00
};

+ (NSData *)BASE64Decrypt:(NSString *)base64string
{
    if (base64string.length%4) {
        NSLog(@"ESCCrypt error : The source data is not correct base64 code .");
        return nil;
    }
    
    if (base64string.length == 0) return [NSData new];
    const char *srcBytes = [base64string UTF8String];
    NSInteger destLenght = base64string.length/4*3;
    unsigned char *destBytes = malloc(sizeof(char)*destLenght);
    unsigned char *buffer = destBytes;
    int32_t temp = 0;
    NSUInteger index = destLenght-1;
    while (index --) {
        temp |= deBase64_table[srcBytes[0]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[1]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[2]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[3]];
        buffer[0] = (temp & 0xFF0000) >> 16;
        buffer[1] = (temp & 0x00FF00) >> 8;
        buffer[2] = (temp & 0x0000FF);
        temp = 0;
        srcBytes += 4;
        buffer += 3;
    }
    
    if (srcBytes[2] == '=') {
        temp |= deBase64_table[srcBytes[0]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[1]];
        buffer[0] = temp >> 4;
        destLenght -= 2;
    }else if (srcBytes[3] == '='){
        temp |= deBase64_table[srcBytes[0]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[1]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[2]];
        buffer[0] = (temp >> 2 & 0xFF00) >> 8;
        buffer[1] = (temp >> 2 & 0x00FF);
        destLenght -= 1;
    }else {
        temp |= deBase64_table[srcBytes[0]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[1]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[2]];
        temp <<= 6;
        temp |= deBase64_table[srcBytes[3]];
        buffer[0] = (temp & 0xFF0000) >> 16;
        buffer[1] = (temp & 0x00FF00) >> 8;
        buffer[2] = (temp & 0x0000FF);
    }
    
    return [[NSData alloc] initWithBytesNoCopy:destBytes length:destLenght freeWhenDone:YES];
}

#pragma mark- AES
+ (NSData *)AES128Encrypt:(NSData *)data withPassword:(NSString *)password
{
    return [self __crypt:data withType:kCCAlgorithmAES operation:kCCEncrypt passowrd:password keySize:kCCKeySizeAES128];
}
+ (NSData *)AES128Decrypt:(NSData *)encryptedData withPassword:(NSString *)password
{
    return [self __crypt:encryptedData withType:kCCAlgorithmAES operation:kCCDecrypt passowrd:password keySize:kCCKeySizeAES128];
}

+ (NSData *)AES192Encrypt:(NSData *)data withPassword:(NSString *)password
{
    return [self __crypt:data withType:kCCAlgorithmAES operation:kCCEncrypt passowrd:password keySize:kCCKeySizeAES192];
}
+ (NSData *)AES192Decrypt:(NSData *)encryptedData withPassword:(NSString *)password
{
    return [self __crypt:encryptedData withType:kCCAlgorithmAES operation:kCCDecrypt passowrd:password keySize:kCCKeySizeAES192];
}

+ (NSData *)AES256Encrypt:(NSData *)data withPassword:(NSString *)password
{
    return [self __crypt:data withType:kCCAlgorithmAES operation:kCCEncrypt passowrd:password keySize:kCCKeySizeAES256];
}
+ (NSData *)AES256Decrypt:(NSData *)encryptedData withPassword:(NSString *)password
{
    return [self __crypt:encryptedData withType:kCCAlgorithmAES operation:kCCDecrypt passowrd:password keySize:kCCKeySizeAES256];
}
#pragma mark- DES
+ (NSData *)DESEncrypt:(NSData *)data withPassword:(NSString *)password
{
    return [self __crypt:data withType:kCCAlgorithmDES operation:kCCEncrypt passowrd:password keySize:kCCKeySizeDES];
}
+ (NSData *)DESDecrypt:(NSData *)encryptedData withPassword:(NSString *)password
{
    return [self __crypt:encryptedData withType:kCCAlgorithmDES operation:kCCDecrypt passowrd:password keySize:kCCKeySizeDES];
}

#pragma mark- DES3
+ (NSData *)DES3Encrypt:(NSData *)data withPassword:(NSString *)password
{
    return [self __crypt:data withType:kCCAlgorithm3DES operation:kCCEncrypt passowrd:password keySize:kCCKeySize3DES];
}
+ (NSData *)DES3Decrypt:(NSData *)encryptedData withPassword:(NSString *)password
{
    return [self __crypt:encryptedData withType:kCCAlgorithm3DES operation:kCCDecrypt passowrd:password keySize:kCCKeySize3DES];
}

#pragma mark- RSA
+ (NSData *)RSAEncrypt:(NSData *)data withPrivateKey:(NSData *)keyData password:(NSString *)password
{
    SecKeyRef secKey = [self __RSAPrivateKeyWithData:keyData password:password];
    CFDataRef srcData = CFBridgingRetain(data);
    size_t dataLength = CFDataGetLength(srcData);
    
    size_t chipBufferSize = SecKeyGetBlockSize(secKey);
    uint8_t  *chipBuffer = malloc(chipBufferSize * sizeof(uint8_t));
    size_t blockCount = (size_t)ceil(dataLength/chipBufferSize);
    
    CFMutableDataRef encryptedData = CFDataCreateMutable(NULL, dataLength);
    
    for (size_t i = 0; i < blockCount; i ++){
        size_t bufferSize = MIN(chipBufferSize, dataLength - i*chipBufferSize);
        UInt8 *buffer = malloc(bufferSize*sizeof(UInt8));
        CFDataGetBytes(srcData, CFRangeMake(i*chipBufferSize, bufferSize), buffer);
        OSStatus status = SecKeyEncrypt(secKey,
                                        kSecPaddingPKCS1,
                                        buffer, bufferSize,
                                        chipBuffer, &bufferSize);
        if (status == noErr) CFDataAppendBytes(encryptedData, chipBuffer, bufferSize);
        else i = blockCount;
        
        free(buffer);
    }
    
    if (chipBuffer) free(chipBuffer);
    if (secKey) free(secKey);
    
    return CFBridgingRelease(encryptedData);
}
+ (NSData *)RSADecrypt:(NSData *)encryptedData withPublickKey:(NSData *)keyData
{
    CFDataRef srcData = CFBridgingRetain(encryptedData);
    size_t dataLength = CFDataGetLength(srcData);
    SecKeyRef  secKey = [self __RSAPublicKeyWithData:keyData];
    
    size_t chipBufferSize = SecKeyGetBlockSize(secKey);
    UInt8 *chipBuffer = malloc(chipBufferSize*sizeof(UInt8));
    size_t blockCount = (size_t)ceil(dataLength/chipBufferSize);
    
    CFMutableDataRef decryptedData = CFDataCreateMutable(NULL, dataLength);
    
    for (size_t i = 0; i < blockCount; i ++) {
        size_t bufferSize = MIN(chipBufferSize, dataLength - i * chipBufferSize);
        UInt8 *buffer = malloc(bufferSize * sizeof(UInt8));
        CFDataGetBytes(srcData, CFRangeMake(i*chipBufferSize, bufferSize), buffer);
        
        OSStatus status = SecKeyDecrypt(secKey,
                                        kSecPaddingPKCS1,
                                        buffer, bufferSize,
                                        chipBuffer, &bufferSize);
        if (status == noErr) CFDataAppendBytes(decryptedData, chipBuffer, bufferSize);
        else i = blockCount;
        
        free(buffer);
    }
    if (chipBuffer) free(chipBuffer);
    if (secKey) free(secKey);
    
    return CFBridgingRelease(decryptedData);
}

#pragma mark- private method
+ (NSData *)__crypt:(NSData *)data withType:(CCAlgorithm)algorithm operation:(CCOperation)operation passowrd:(NSString *)password keySize:(NSInteger)keySize
{
    NSInteger keyLength = (password.length/keySize+1)*keySize+1;
    char *key = malloc(keyLength);
    bzero(key, keyLength);
    [password getCString:key maxLength:keyLength encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, bufferSize);
    
    CCCryptorStatus status = CCCrypt(operation,
                                     algorithm,
                                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                                     key, keySize,
                                     NULL,
                                     [data bytes], dataLength,
                                     buffer, bufferSize,
                                     &bufferSize);
    
    NSData *result;
    if (status == kCCSuccess)
        result = [NSData dataWithBytes:buffer length:bufferSize];

    if (buffer) free(buffer);
    if (key) free(key);
    
    return result;
}

+ (SecKeyRef)__RSAPrivateKeyWithData:(NSData *)data password:(NSString *)password
{
    if (!data) NSLog(@"ESCCrypt warning : RSAPrivateKey maybe empty !");
    
    CFDataRef p12Data = CFBridgingRetain(data);
    CFStringRef pw = CFBridgingRetain(password);
    
    SecKeyRef privateKey = NULL;
    CFMutableDictionaryRef options = CFDictionaryCreateMutable(NULL, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(options, kSecImportExportPassphrase, pw);
    
    CFArrayRef items = NULL;
    OSStatus status = SecPKCS12Import(p12Data, options, &items);
    if (status == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identities = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identity = (SecIdentityRef)CFDictionaryGetValue(identities, kSecImportItemIdentity);
        status = SecIdentityCopyPrivateKey(identity, &privateKey);
        if (status != noErr) privateKey = NULL;
    }
    
    if (items) CFRelease(items);
    if (options) CFRelease(options);
    if (pw) CFRelease(pw);
    if (p12Data) CFRelease(p12Data);
    return privateKey;
}

+ (SecKeyRef)__RSAPublicKeyWithData:(NSData *)data
{
    if (!data) NSLog(@"ESCCrypt warning : RSAPublicKey maybe empty !");
    
    CFDataRef cerData = CFBridgingRetain(data);
    SecCertificateRef certification = SecCertificateCreateWithData(kCFAllocatorDefault, cerData);
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    OSStatus status =  SecTrustCreateWithCertificates(certification, policy, &trust);
    SecTrustResultType trustResult;
    if (status == noErr) status = SecTrustEvaluate(trust, &trustResult);
    
    SecKeyRef publicKey = status == noErr ? SecTrustCopyPublicKey(trust) : NULL;
    
    if (trust) CFRelease(trust);
    if (policy) CFRelease(policy);
    if (certification) CFRelease(certification);
    if (cerData) CFRelease(cerData);
    
    return publicKey;
}
@end