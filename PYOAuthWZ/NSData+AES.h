//
//  NSData+AES.h
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

#import <Foundation/Foundation.h>

@interface NSData (AES)

/*!
 The key should be md5
 */
- (NSData *)aes128ecbDecryptedWithKey:(NSString *)key;
- (NSData *)aes128ecbEncryptedWithKey:(NSString *)key;

/*!
 We will md5 this key automatically
 */
- (NSData *)aes128ecbDecryptedWithPlainKey:(NSString *)key;
- (NSData *)aes128ecbEncryptedWithPlainKey:(NSString *)key;

@end

@interface NSString (AES)

/*!
 The key should be md5
 */
- (NSString *)aes128ecbDecryptedWithKey:(NSString *)key;
- (NSString *)aes128ecbEncryptedWithKey:(NSString *)key;

/*!
 We will md5 this key automatically
 */
- (NSString *)aes128ecbDecryptedWithPlainKey:(NSString *)key;
- (NSString *)aes128ecbEncryptedWithPlainKey:(NSString *)key;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
