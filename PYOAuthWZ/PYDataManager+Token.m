//
//  PYDataManager+Token.m
//  PYOAuthWZ
//
//  Created by Push Chen on 9/29/15.
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

#import "PYDataManager+Token.h"
#import "PYKernel+PYData.h"
#import <UIKit/UIKit.h>

NSString *const PYOAuthAPIRegisterClient = @"PYOAuthAPIRegisterClient";
NSString *const PYOAuthAPIAuthClient = @"PYOAuthAPIAuthClient";
NSString *const PYOAuthAPIUpdateClient = @"PYOAuthAPIUpdateClient";
NSString *const PYOAuthAPIRefreshToken = @"PYOAuthAPIRefreshToken";

@implementation PYDataManager (Token)

- (NSInteger)__indexForAPI:(NSString *)apiName
{
    if ( [apiName isEqualToString:PYOAuthAPIRegisterClient] ) return 0;
    if ( [apiName isEqualToString:PYOAuthAPIAuthClient] ) return 1;
    if ( [apiName isEqualToString:PYOAuthAPIUpdateClient] ) return 2;
    return 3;
}

/*!
 @brief The API Path for register client, default is "/oauth/client"
 */
@dynamic apiPathForRegisterClient;
- (NSString *)apiPathForRegisterClient
{
    return [self pathForAPI:PYOAuthAPIRegisterClient];
}

/*!
 @brief The API Path for auth client, default is "/oauth/token"
 */
@dynamic apiPathForAuthClient;
- (NSString *)apiPathForAuthClient
{
    return [self pathForAPI:PYOAuthAPIAuthClient];
}

/*!
 @brief The API Path for update client info, default is "/oauth/client", this request method in default to be a PUT
 */
@dynamic apiPathForUpdateClient;
- (NSString *)apiPathForUpdateClient
{
    return [self pathForAPI:PYOAuthAPIUpdateClient];
}

/*!
 @brief The API Path for refresh token, default is "/oauth/token"
 */
@dynamic apiPathForRefreshToken;
- (NSString *)apiPathForRefreshToken
{
    return [self pathForAPI:PYOAuthAPIRefreshToken];
}

/*!
 @brief To Change the default path for specified api.
 */
- (void)setPath:(NSString *)path forAPI:(NSString *)apiName
{
    [[PYKernel currentKernel]
     updateKernelObject:path
     forKey:[apiName stringByAppendingString:@"+path"]];
}

/*!
 @brief Get the URL Path for specified API.
 */
- (NSString *)pathForAPI:(NSString *)apiName
{
    static NSString *const _defaultPath[] = {
        @"/oauth/client",
        @"/oauth/token",
        @"/oauth/client",
        @"/oauth/token"
    };
    NSString *_path = (NSString *)[[PYKernel currentKernel]
                        kernelObjectForKey:[apiName stringByAppendingString:@"+path"]];
    if ( [_path length] == 0 ) {
        _path = _defaultPath[[self __indexForAPI:apiName]];
    }
    return _path;
}

/*!
 @brief Get the HTTP Method for specified api.
 */
- (NSString *)httpMethodForAPI:(NSString *)apiName
{
    static NSString *const _defaultMethod[] = {
        @"POST",
        @"POST",
        @"PUT",
        @"POST"
    };
    NSString *_method = (NSString *)[[PYKernel currentKernel]
                        kernelObjectForKey:[apiName stringByAppendingString:@"+method"]];
    if ( [_method length] == 0 ) {
        _method = _defaultMethod[[self __indexForAPI:apiName]];
    }
    return _method;
}

/*!
 @brief Set the HTTP Method for specified api.
 */
- (void)setHTTPMethod:(NSString *)method forAPI:(NSString *)apiName
{
    [[PYKernel currentKernel]
     updateKernelObject:method
     forKey:[apiName stringByAppendingString:@"+method"]];
}

/*!
 @brief Get all parameters to be sent to the server for specified api.
 */
- (NSDictionary *)parametersForAPI:(NSString *)apiName
{
    NSMutableDictionary *_params = (NSMutableDictionary *)[[PYKernel currentKernel]
                                    kernelObjectForKey:[apiName stringByAppendingString:@"+params"]];
    if ( _params == nil || [_params count] == 0 ) {
        _params = [NSMutableDictionary dictionary];
        if ( [apiName isEqualToString:PYOAuthAPIRegisterClient] ) {
            [_params setObject:@"ios" forKey:@"type"];
            [_params setObject:[UIDevice currentDevice].name forKey:@"deviceName"];
            [_params setObject:[PYKernel currentKernel].deviceId forKey:@"deviceIdentify"];
            [_params setObject:[PYKernel currentKernel].version forKey:@"version"];
            [_params setObject:@"http://pyoauth-with-zieglar" forKey:@"redirectURI"];
            [_params setObject:PYDEVICEMODELNAME forKey:@"deviceVersion"];
            [_params setObject:[UIDevice currentDevice].systemVersion forKey:@"deviceOsVersion"];
        } else if ( [apiName isEqualToString:PYOAuthAPIAuthClient] ) {
            [_params setObject:@"client_credentials" forKey:@"grant_type"];
            [_params setObject:@"clientresource" forKey:@"scope"];
        } else if ( [apiName isEqualToString:PYOAuthAPIUpdateClient] ) {
            [_params setObject:[UIDevice currentDevice].name forKey:@"deviceName"];
            [_params setObject:[UIDevice currentDevice].systemVersion forKey:@"deviceOsVersion"];
            [_params setObject:[PYKernel currentKernel].version forKey:@"version"];
        } else {
            [_params setObject:@"refresh_token" forKey:@"grant_type"];
            [_params setObject:@"resource" forKey:@"scope"];
        }
        [[PYKernel currentKernel] updateKernelObject:_params forKey:[apiName stringByAppendingString:@"+params"]];
    }
    return _params;
}

/*!
 @brief Set or Add a value with key for specified api.
 */
- (void)setValue:(NSString *)value forKey:(NSString *)key withAPI:(NSString *)apiName
{
    NSMutableDictionary *_params = (NSMutableDictionary *)[self parametersForAPI:apiName];
    [_params setObject:value forKey:key];
    [[PYKernel currentKernel] updateKernelObject:_params forKey:[apiName stringByAppendingString:@"+params"]];
}

/*!
 @brief Remove a key from the api's parameter list.
 */
- (void)removeValueForKey:(NSString *)key withAPI:(NSString *)apiName
{
    NSMutableDictionary *_params = (NSMutableDictionary *)[self parametersForAPI:apiName];
    [_params removeObjectForKey:key];
    [[PYKernel currentKernel] updateKernelObject:_params forKey:[apiName stringByAppendingString:@"+params"]];
}

/*!
 @brief The Client Id of current device
 */
@dynamic client_id;
- (NSString *)client_id
{
    //return [_dataCache objectForKey:@"client_id"];
    return (NSString *)[[PYKernel currentKernel] kernelObjectForKey:@"client_id"];
}
/*!
 @brief The secret key for current device
 */
@dynamic client_secret;
- (NSString *)client_secret
{
    //return [_dataCache objectForKey:@"client_secret"];
    return (NSString *)[[PYKernel currentKernel] kernelObjectForKey:@"client_secret"];
}

/*!
 @brief Related to current user, the access token's type
 */
@dynamic token_type;
- (NSString *)token_type
{
    return [_userCache objectForKey:@"token_type"];
}
/*!
 @brief Related to current user.
 */
@dynamic access_token;
- (NSString *)access_token
{
    return [_userCache objectForKey:@"access_token"];
}
/*!
 @brief Refresh token to get new access_token.
 */
@dynamic refresh_token;
- (NSString *)refresh_token
{
    return [_userCache objectForKey:@"refresh_token"];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
