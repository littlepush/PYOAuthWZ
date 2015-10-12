//
//  PYApiRequest+Auth.m
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

#import "PYApiRequest+Auth.h"
#import "PYDataManager+Token.h"
#import "PYApiManager+ApiVersion.h"

@implementation PYBasicAuthRequest

- (NSMutableURLRequest *)generateRequest
{
    NSMutableDictionary *_new_params = [NSMutableDictionary dictionaryWithDictionary:_parameters];
    [_new_params setObject:[PYApiManager apiVersion] forKey:[PYApiManager apiVersionKey]];
    _parameters = _new_params;
    

    NSMutableURLRequest *_req = [super generateRequest];
    if ( _req == nil ) return nil;
    
    NSString *_basicAuth = [[NSString stringWithFormat:@"%@:%@",
                             [PYDataManager shared].client_id,
                             [PYDataManager shared].client_secret]
                            base64EncodeString];
    [_req
     addValue:[NSString stringWithFormat:@"Basic %@", _basicAuth]
     forHTTPHeaderField:@"Authorization"];

    return _req;
}

@end

@implementation PYAuthRequest

- (NSMutableURLRequest *)generateRequest
{
    NSMutableDictionary *_new_params = [NSMutableDictionary dictionaryWithDictionary:_parameters];
    [_new_params setObject:[PYApiManager apiVersion] forKey:[PYApiManager apiVersionKey]];
    _parameters = _new_params;
    
    NSMutableURLRequest *_req = [super generateRequest];
    if ( _req == nil ) return nil;
    
    [_req
     addValue:[NSString stringWithFormat:@"%@ %@",
               [PYDataManager shared].token_type,
               [PYDataManager shared].access_token]
     forHTTPHeaderField:@"Authorization"];
    
    return _req;
}

@end

@implementation PYAuthJsonRequest

- (NSMutableURLRequest *)generateRequest
{
    NSMutableURLRequest *_req = [super generateRequest];
    if ( _req == nil ) return nil;
    
    [_req addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return _req;
}

- (void)setJsonBody:(NSDictionary *)bodyDict inReq:(NSMutableURLRequest *)req
{
    NSData *_data = [NSJSONSerialization
                     dataWithJSONObject:bodyDict
                     options:0 error:nil];
    [req setHTTPBody:_data];
    [req addValue:PYIntToString(_data.length) forHTTPHeaderField:@"Content-Length"];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
