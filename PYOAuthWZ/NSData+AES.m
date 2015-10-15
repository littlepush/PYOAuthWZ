//
//  NSData+AES.m
//  PYOAuthWZ
//
//  Created by Push Chen on 10/12/15.
//  Copyright © 2015 PushLab. All rights reserved.
//

/*
 LGPL V3 Lisence
 This file is part of cleandns.
 
 PYCore is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 PYData is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with cleandns.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 LISENCE FOR IPY
 COPYRIGHT (c) 2013, Push Chen.
 ALL RIGHTS RESERVED.
 
 REDISTRIBUTION AND USE IN SOURCE AND BINARY
 FORMS, WITH OR WITHOUT MODIFICATION, ARE
 PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS
 ARE MET:
 
 YOU USE IT, AND YOU JUST USE IT!.
 WHY NOT USE THIS LIBRARY IN YOUR CODE TO MAKE
 THE DEVELOPMENT HAPPIER!
 ENJOY YOUR LIFE AND BE FAR AWAY FROM BUGS.
 */

#import "NSData+AES.h"

#import <CommonCrypto/CommonCryptor.h>
#import "PYCore.h"

NSData *_hexStringToData(NSString *hexString)
{
    NSMutableData *_data = [NSMutableData data];
    unsigned int _index, _intValue;
    for ( _index = 0; _index + 2 <= hexString.length; _index += 2 ) {
        NSString *_hexStr = [hexString substringWithRange:NSMakeRange(_index, 2)];
        NSScanner *_scanner = [NSScanner scannerWithString:_hexStr];
        [_scanner scanHexInt:&_intValue];
        [_data appendBytes:&_intValue length:1];
    }
    return _data;
}

NSString *_dataToHexString(NSData *data) {
    NSMutableString *_hexString = [NSMutableString string];
    const char *_dataBuffer = [data bytes];
    for ( NSUInteger i = 0; i < data.length; ++i ) {
        unsigned char _b = _dataBuffer[i];
        [_hexString appendFormat:@"%02X", _b];
    }
    return _hexString;
}

@implementation NSData (AES)

- (NSData *)aes128ecbDecryptedWithKey:(NSString *)key
{
    NSData *_keyData = _hexStringToData(key);
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          _keyData.bytes,
                                          _keyData.length,
                                          NULL,
                                          [self bytes],
                                          [self length],
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)aes128ecbEncryptedWithKey:(NSString *)key
{
    NSData *_keyData = _hexStringToData(key);
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength * 4;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          _keyData.bytes,
                                          _keyData.length,
                                          NULL,
                                          [self bytes],
                                          [self length],
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)aes128ecbDecryptedWithPlainKey:(NSString *)key
{
    return [self aes128ecbDecryptedWithKey:[key md5sum]];
}

- (NSData *)aes128ecbEncryptedWithPlainKey:(NSString *)key
{
    return [self aes128ecbEncryptedWithKey:[key md5sum]];
}

@end

@implementation NSString (AES)

- (NSString *)aes128ecbDecryptedWithKey:(NSString *)key
{
    NSData* _encryptedData = _hexStringToData(self);
    NSData *_result = [_encryptedData aes128ecbDecryptedWithKey:key];
    return [[NSString alloc] initWithData:_result encoding:NSUTF8StringEncoding];
}

- (NSString *)aes128ecbEncryptedWithKey:(NSString *)key
{
    NSData *_originData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *_result = [_originData aes128ecbEncryptedWithKey:key];
    return _dataToHexString(_result);
}

- (NSString *)aes128ecbDecryptedWithPlainKey:(NSString *)key
{
    return [self aes128ecbDecryptedWithKey:[key md5sum]];
}

- (NSString *)aes128ecbEncryptedWithPlainKey:(NSString *)key
{
    return [self aes128ecbEncryptedWithKey:[key md5sum]];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
