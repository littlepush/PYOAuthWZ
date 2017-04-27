//
//  PYDataManager+Auth.m
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

#import <PYCore/PYCore.h>
#import <PYNetwork/PYNetwork.h>
#import <PYData/PYData.h>
#import "PYDataManager+Auth.h"
#import "PYKernel+PYData.h"
#import "PYApiManager+Auth.h"
#import "PYDataManager+Token.h"

NSString *kPYActionFailedNotification = @"kPYActionFailedNotification";
NSString *kPYFirstTimeOpenFlag = @"com.ipy.kernel.open.flag";
NSString *kPYNeedUpdateClientFlag = @"com.ipy.kernel.needupdate";
NSString *kPYInitializeStatusFlag = @"kPYInitializeStatusFlag";

static NSMutableArray *_errorPendingActions = nil;
static BOOL _errorHandlerIsRefreshingToken = NO;

@implementation PYDataManager (Auth)

- (void)PYErrorHandler:(NSError *)error shouldRedoAction:(PYActionDone)done;
{
    if ( error.code == 403 ) {
        @try {
            @synchronized([PYDataManager shared]) {
                if ( _errorPendingActions == nil ) {
                    _errorPendingActions = [NSMutableArray object];
                }
                if ( done != nil ) {
                    [_errorPendingActions addObject:done];
                }
                if ( _errorHandlerIsRefreshingToken ) return;
                _errorHandlerIsRefreshingToken = YES;
            }
            // forbiddon. refresh token
            [PYApiManager
             invokeRefreshTokenWithParameters:@{}
             onInit:^(PYApiRequest *request) {
                 // nothing
             } onSuccess:^(id response) {
                 RefreshTokenResponse *_resp = (RefreshTokenResponse *)response;
                 [[PYDataManager shared].userCache setObject:_resp.access_token forKey:@"access_token"];
                 [[PYDataManager shared].userCache setObject:_resp.token_type forKey:@"token_type"];
                 @synchronized([PYDataManager shared]) {
                     for ( PYActionDone _done in _errorPendingActions ) {
                         _done();
                     }
                     [_errorPendingActions removeAllObjects];
                     _errorHandlerIsRefreshingToken = NO;
                 }
             } onFailed:^(NSError *revoke_error) {
                 DUMPObj(revoke_error);
                 // Force to logout and refresh the client info
                 @synchronized([PYDataManager shared]) {
                     // Clear all pending actions
                     [_errorPendingActions removeAllObjects];
                     _errorHandlerIsRefreshingToken = NO;
                 }
                 [[PYDataManager shared] PYLogoutAndRefreshToken:nil];
             }];
        } @catch ( NSException *ex ) {
            DUMPObj(ex);
            [NF_CENTER postNotificationName:kPYActionFailedNotification object:nil userInfo:@{@"error":error}];
        }
    } else if ( error.code == -1012 ) {
        // Force to re-login
        @synchronized([PYDataManager shared]) {
            // Clear all pending actions
            [_errorPendingActions removeAllObjects];
            _errorHandlerIsRefreshingToken = NO;
        }
        [[PYDataManager shared] PYLogoutAndRefreshToken:nil];
    } else {
        DUMPObj(error);
        [NF_CENTER postNotificationName:kPYActionFailedNotification object:nil userInfo:@{@"error":error}];
    }
}

- (void)PYInitializeClient:(PYActionDone)done;
{
    NSNumber *_isFirstTimeOpen = (NSNumber *)[[PYKernel currentKernel] kernelObjectForKey:kPYFirstTimeOpenFlag];
    // If No Refresh Token, force to be the first time open.
    if ( [self.refresh_token length] == 0 ) _isFirstTimeOpen = @(YES);
    
    if ( _isFirstTimeOpen == nil ) _isFirstTimeOpen = @(YES);
    if ( [_isFirstTimeOpen boolValue] == NO ) {
        // Not first time open
        // Check if need to update the client info for an update version
        NSNumber *_needUpdate = (NSNumber *)[[PYKernel currentKernel] kernelObjectForKey:kPYNeedUpdateClientFlag];
        if ( _needUpdate == nil ) _needUpdate = @(NO);
        if ( [_needUpdate boolValue] || [PYKernel currentKernel].isFirstTimeInstall ) {
            [PYApiManager
             invokeUpdateClientInfoWithParameters:@{}
             onInit:^(PYApiRequest *request) {
                 // nothing
             } onSuccess:^(id response) {
                 [[PYKernel currentKernel] updateKernelObject:@(NO) forKey:kPYNeedUpdateClientFlag];
                 [[PYKernel currentKernel] updateKernelObject:@"success" forKey:kPYInitializeStatusFlag];
                 if ( done ) done();
             } onFailed:^(NSError *error) {
                 // Mask to update client info next time the application start.
                 [[PYKernel currentKernel] updateKernelObject:@(YES) forKey:kPYNeedUpdateClientFlag];
                 
                 // Update initialize status flag
                 if ( [PYReachability reachabilityForInternetConnection].reachableStatus == PYNetworkStatusNotReachable ) {
                     [[PYKernel currentKernel] updateKernelObject:@"broken" forKey:kPYInitializeStatusFlag];
                 }
             }];
        } else {
            if ( done ) done();
        }
    } else {
        [[PYKernel currentKernel] updateKernelObject:@(NO) forKey:kPYFirstTimeOpenFlag];
        [PYApiManager
         invokeRegisterClientDeviceWithParameters:@{}
         onInit:^(PYApiRequest *request) {
             //
         } onSuccess:^(id response) {
             RegisterClientDeviceResponse *_deviceResp = (RegisterClientDeviceResponse *)response;
             //[[PYDataManager shared].dataCache setObject:_deviceResp.client_id forKey:@"client_id"];
             //[[PYDataManager shared].dataCache setObject:_deviceResp.client_secret forKey:@"client_secret"];
             [[PYKernel currentKernel] updateKernelObject:_deviceResp.client_id forKey:@"client_id"];
             [[PYKernel currentKernel] updateKernelObject:_deviceResp.client_secret forKey:@"client_secret"];
             
             PYLog(@"\nclient_id: %@", _deviceResp.client_id);
             PYLog(@"\nclient_secret: %@", _deviceResp.client_secret);
             
             [PYApiManager
              invokeAuthClientWithParameters:@{}
              onInit:^(PYApiRequest *request) {
                  // Nothing
              } onSuccess:^(id response) {
                  
                  AuthClientResponse *_authResp = (AuthClientResponse *)response;
                  [[PYDataManager shared].userCache setObject:_authResp.access_token forKey:@"access_token"];
                  [[PYDataManager shared].userCache setObject:_authResp.token_type forKey:@"token_type"];
                  
                  PYLog(@"\naccess_token: %@", _authResp.access_token);
                  PYLog(@"\ntoken_type: %@", _authResp.token_type);
                  
                  [[PYKernel currentKernel] updateKernelObject:@"success" forKey:kPYInitializeStatusFlag];
                  
                  if ( done ) done();
              } onFailed:^(NSError *error) {
                  [[PYKernel currentKernel] updateKernelObject:@(YES) forKey:kPYFirstTimeOpenFlag];
                  
                  // Update initialize status flag
                  if ( [PYReachability reachabilityForInternetConnection].reachableStatus == PYNetworkStatusNotReachable ) {
                      [[PYKernel currentKernel] updateKernelObject:@"broken" forKey:kPYInitializeStatusFlag];
                  }
              }];
             
         } onFailed:^(NSError *error) {
             [[PYKernel currentKernel] updateKernelObject:@(YES) forKey:kPYFirstTimeOpenFlag];
             
             // Update initialize status flag
             if ( [PYReachability reachabilityForInternetConnection].reachableStatus == PYNetworkStatusNotReachable ) {
                 [[PYKernel currentKernel] updateKernelObject:@"broken" forKey:kPYInitializeStatusFlag];
             } else {
                 NSTimer *_reTimer = [NSTimer
                                      timerWithTimeInterval:10.f
                                      target:[PYDataManager shared]
                                      selector:@selector(_pyTimerToReInitializeClient:)
                                      userInfo:@{@"done": done}
                                      repeats:NO];
                 [[NSRunLoop currentRunLoop] addTimer:_reTimer forMode:NSRunLoopCommonModes];
             }
         }];
    }
}

- (void)_pyTimerToReInitializeClient:(NSTimer *)timer
{
    NSDictionary *_ui = timer.userInfo;
    PYActionDone _done = [_ui objectForKey:@"done"];
    [self PYInitializeClient:_done];
}

- (void)PYLogoutAndRefreshToken:(PYActionDone)done
{
    [PYApiManager
     invokeAuthClientWithParameters:@{}
     onInit:^(PYApiRequest *request) {
         // Nothing
     } onSuccess:^(id response) {
         
         // Now can logout current user.
         [[PYDataManager shared] logout];
         
         AuthClientResponse *_authResp = (AuthClientResponse *)response;
         [[PYDataManager shared].userCache setObject:_authResp.access_token forKey:@"access_token"];
         [[PYDataManager shared].userCache setObject:_authResp.token_type forKey:@"token_type"];
         
         PYLog(@"\naccess_token: %@", _authResp.access_token);
         PYLog(@"\ntoken_type: %@", _authResp.token_type);
         
         if ( done ) done();
     } onFailed:^(NSError *error) {
         [[PYDataManager shared] PYErrorHandler:error shouldRedoAction:nil];
     }];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
