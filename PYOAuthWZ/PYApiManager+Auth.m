//
//  PYApiManager+Auth.m
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

#import "PYApiManager+Auth.h"
#import "PYDataManager+Token.h"

PY_API_IMPL(RegisterClientDevice)
PY_BEGIN_OVERWRITE_REQUEST(RegisterClientDevice)
PY_SET_URLSCHEMA([PYDataManager shared].apiPathForRegisterClient)
- (NSMutableURLRequest *)generateRequest
{
    NSMutableURLRequest *_req = [super generateRequest];
    if ( _req == nil ) return nil;
    
    [self beginOfSettingPostData:_req];
    
    NSDictionary *_params = [[PYDataManager shared] parametersForAPI:PYOAuthAPIRegisterClient];
    for ( NSString *_key in _params ) {
        NSString *_value = _params[_key];
        [self addPostValue:_value forKey:_key];
    }
    
    [self endOfSettingPostData:_req];
    
    [_req setHTTPMethod:[[PYDataManager shared] httpMethodForAPI:PYOAuthAPIRegisterClient]];
    return _req;
}
PY_END_OVERWRITE_REQUEST
PY_BEGIN_OVERWRITE_RESPONSE(RegisterClientDevice)
- (BOOL)parseBodyWithJSON:(id)jsonObject
{
    [jsonObject mustBeTypeOrFailed:[NSDictionary class]];
    NSDictionary *_dict = (NSDictionary *)jsonObject;
    self.client_id = [_dict stringObjectForKey:@"client_id"];
    self.client_secret = [_dict stringObjectForKey:@"client_secret"];
    return YES;
}
PY_END_OVERWRITE_RESPONSE

PY_API_IMPL(AuthClient)
PY_BEGIN_OVERWRITE_REQUEST(AuthClient)
PY_SET_URLSCHEMA([PYDataManager shared].apiPathForAuthClient)
- (NSMutableURLRequest *)generateRequest
{
    NSMutableURLRequest *_req = [super generateRequest];
    if ( _req == nil ) return nil;
    
    [self beginOfSettingPostData:_req];
    
    NSDictionary *_params = [[PYDataManager shared] parametersForAPI:PYOAuthAPIAuthClient];
    for ( NSString *_key in _params ) {
        NSString *_value = _params[_key];
        [self addPostValue:_value forKey:_key];
    }
    
    [self endOfSettingPostData:_req];
    
    // Add Auth Value
    NSString *_basicAuth = [[NSString stringWithFormat:@"%@:%@",
                             [PYDataManager shared].client_id,
                             [PYDataManager shared].client_secret]
                            base64EncodeString];
    [_req
     addValue:[NSString stringWithFormat:@"Basic %@", _basicAuth]
     forHTTPHeaderField:@"Authorization"];
    
    [_req setHTTPMethod:[[PYDataManager shared] httpMethodForAPI:PYOAuthAPIAuthClient]];
    return _req;
}
PY_END_OVERWRITE_REQUEST
PY_BEGIN_OVERWRITE_RESPONSE(AuthClient)
- (BOOL)parseBodyWithJSON:(id)jsonObject
{
    [jsonObject mustBeTypeOrFailed:[NSDictionary class]];
    NSDictionary *_dict = (NSDictionary *)jsonObject;
    self.access_token = [_dict stringObjectForKey:@"access_token"];
    self.token_type = [_dict stringObjectForKey:@"token_type"];
    return YES;
}
PY_END_OVERWRITE_RESPONSE

PY_API_IMPL(RefreshToken)
PY_BEGIN_OVERWRITE_REQUEST(RefreshToken)
PY_SET_URLSCHEMA([PYDataManager shared].apiPathForRefreshToken)
- (NSMutableURLRequest *)generateRequest
{
    NSMutableURLRequest *_req = [super generateRequest];
    if ( _req == nil ) return nil;
    
    [self beginOfSettingPostData:_req];
    
    NSDictionary *_params = [[PYDataManager shared] parametersForAPI:PYOAuthAPIRefreshToken];
    for ( NSString *_key in _params ) {
        NSString *_value = _params[_key];
        [self addPostValue:_value forKey:_key];
    }
    // refresh token
    [self addPostValue:[PYDataManager shared].refresh_token forKey:@"refresh_token"];
    
    [self endOfSettingPostData:_req];
    
    // Add Auth Value
    NSString *_basicAuth = [[NSString stringWithFormat:@"%@:%@",
                             [PYDataManager shared].client_id,
                             [PYDataManager shared].client_secret]
                            base64EncodeString];
    [_req
     addValue:[NSString stringWithFormat:@"Basic %@", _basicAuth]
     forHTTPHeaderField:@"Authorization"];
    
    [_req setHTTPMethod:[[PYDataManager shared] httpMethodForAPI:PYOAuthAPIRefreshToken]];
    return _req;
}
PY_END_OVERWRITE_REQUEST
PY_BEGIN_OVERWRITE_RESPONSE(RefreshToken)
- (BOOL)parseBodyWithJSON:(id)jsonObject
{
    [jsonObject mustBeTypeOrFailed:[NSDictionary class]];
    NSDictionary *_dict = (NSDictionary *)jsonObject;
    self.access_token = [_dict stringObjectForKey:@"access_token"];
    self.refresh_token = [_dict stringObjectForKey:@"refresh_token"];
    NSInteger _expires = [_dict intObjectForKey:@"expires_in"];
    self.expires_in = [((PYDate *)[PYDate date]) dateMinuterAfter:(_expires / 60)];
    self.token_type = [_dict stringObjectForKey:@"token_type"];
    return YES;
}
PY_END_OVERWRITE_RESPONSE

PY_API_IMPL(UpdateClientInfo)
PY_BEGIN_OVERWRITE_REQUEST(UpdateClientInfo)
PY_SET_URLSCHEMA([PYDataManager shared].apiPathForUpdateClient)
- (NSMutableURLRequest *)generateRequest
{
    NSMutableURLRequest *_req = [super generateRequest];
    if ( _req == nil ) return nil;
    [_req
     addValue:[NSString stringWithFormat:@"%@ %@",
               [PYDataManager shared].token_type,
               [PYDataManager shared].access_token]
     forHTTPHeaderField:@"Authorization"];
    
    [self beginOfSettingPostData:_req];
    
    NSDictionary *_params = [[PYDataManager shared] parametersForAPI:PYOAuthAPIUpdateClient];
    for ( NSString *_key in _params ) {
        NSString *_value = _params[_key];
        [self addPostValue:_value forKey:_key];
    }
    
    [self endOfSettingPostData:_req];
    
    [_req setHTTPMethod:[[PYDataManager shared] httpMethodForAPI:PYOAuthAPIUpdateClient]];
    return _req;
}
PY_END_OVERWRITE_REQUEST
PY_BEGIN_OVERWRITE_RESPONSE(UpdateClientInfo)
- (BOOL)parseBodyWithData:(NSData *)data
{
    return YES;
}
// This api need no response, just return YES for any body data.
//- (BOOL)parseBodyWithJSON:(id)jsonObject
//{
//    return YES;
//}
PY_END_OVERWRITE_RESPONSE

// @littlepush
// littlepush@gmail.com
// PYLab
