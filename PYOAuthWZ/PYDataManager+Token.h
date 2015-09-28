//
//  PYDataManager+Token.h
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

#import "PYDataManager.h"

/*
 We have 4 auth api in this pod.
 When the application first time start, we need to register the client with the server,
 then use the client_secret and client_id to fetch the access_token from the server.
 For every time beside first time start the application, try to update the client info to server.
 When get an NSURLDomainError with code -1012, which means everything has been expired, 
 the error handler process will automatically log the user out and try to re-auth the client.
 If get a 403 from the server, means current access_token has been expired, then the process
 will invoke a refresh api to get the new access_token.
 */

// API Key
extern NSString *const PYOAuthAPIRegisterClient;
extern NSString *const PYOAuthAPIAuthClient;
extern NSString *const PYOAuthAPIUpdateClient;
extern NSString *const PYOAuthAPIRefreshToken;

@interface PYDataManager (Token)

/*!
 @brief The API Path for register client, default is "/oauth/client"
 */
@property (nonatomic, readonly) NSString        *apiPathForRegisterClient;

/*!
 @brief The API Path for auth client, default is "/oauth/token"
 */
@property (nonatomic, readonly) NSString        *apiPathForAuthClient;

/*!
 @brief The API Path for update client info, default is "/oauth/client", this request method in default to be a PUT
 */
@property (nonatomic, readonly) NSString        *apiPathForUpdateClient;

/*!
 @brief The API Path for refresh token, default is "/oauth/token"
 */
@property (nonatomic, readonly) NSString        *apiPathForRefreshToken;

/*!
 @brief To Change the default path for specified api.
 */
- (void)setPath:(NSString *)path forAPI:(NSString *)apiName;

/*!
 @brief Get the URL Path for specified API.
 */
- (NSString *)pathForAPI:(NSString *)apiName;

/*!
 @brief Get the HTTP Method for specified api.
 */
- (NSString *)httpMethodForAPI:(NSString *)apiName;

/*!
 @brief Set the HTTP Method for specified api.
 */
- (void)setHTTPMethod:(NSString *)method forAPI:(NSString *)apiName;

/*!
 @brief Get all parameters to be sent to the server for specified api.
 */
- (NSDictionary *)parametersForAPI:(NSString *)apiName;

/*!
 @brief Set or Add a value with key for specified api.
 */
- (void)setValue:(NSString *)value forKey:(NSString *)key withAPI:(NSString *)apiName;

/*!
 @brief Remove a key from the api's parameter list.
 */
- (void)removeValueForKey:(NSString *)key withAPI:(NSString *)apiName;

/*!
 @brief The Client Id of current device
 */
@property (nonatomic, readonly) NSString        *client_id;
/*!
 @brief The secret key for current device
 */
@property (nonatomic, readonly) NSString        *client_secret;

/*!
 @brief Related to current user, the access token's type
 */
@property (nonatomic, readonly) NSString        *token_type;
/*!
 @brief Related to current user.
 */
@property (nonatomic, readonly) NSString        *access_token;
/*!
 @brief Refresh token to get new access_token.
 */
@property (nonatomic, readonly) NSString        *refresh_token;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
