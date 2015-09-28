//
//  PYOAuthWZ.m
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

#import "PYOAuthWZ.h"
#import "PYKernel+PYData.h"

static PYOAuthWZ *_gauth = nil;

@interface PYOAuthWZ ()
{
    PYActionDone            _callbackBlock;
}

@end

@implementation PYOAuthWZ

PYSingletonAllocWithZone(_gauth);
PYSingletonDefaultImplementation
+ (instancetype)shared
{
    PYSingletonLock
    if ( _gauth == nil ) {
        _gauth = [PYOAuthWZ object];
    }
    return _gauth;
    PYSingletonUnLock
}

+ (void)InitializeClient:(PYActionDone)done
{
    if ( [PYOAuthWZ shared]->_callbackBlock != NULL ) return;
    
    // Copy the callback block
    [PYOAuthWZ shared]->_callbackBlock = done;
    
    // Start to monitor the network status.
    [[PYReachabilityManager shared] startService];
    
    // Register the reachability manager callback
    [[PYReachabilityManager shared]
     addTarget:[PYOAuthWZ shared]
     action:@selector(_action_OnLoading_NetworkTurnedOn)
     forEvent:kPYNetworkOnline];
    
    // Try to initialize the client.
    [[PYOAuthWZ shared] _action_Initialize_Client];
}

- (void)_action_Initialize_Client
{
    if ( [PYReachabilityManager shared].currentNetworkStatus == PYNetworkStatusNotReachable ) {
        PYLog(@"The network is not on.");
    }
    
    [[PYDataManager shared] PYInitializeClient:^{
        if ( [PYOAuthWZ shared]->_callbackBlock != nil ) {
            [PYOAuthWZ shared]->_callbackBlock();
            // Remove the callback
            [PYOAuthWZ shared]->_callbackBlock = nil;
        }
        // We dont need to monitor the network status anymore for this component
        [[PYReachabilityManager shared]
         removeTarget:[PYOAuthWZ shared]
         action:@selector(_action_OnLoading_NetworkTurnedOn)
         forEvent:kPYNetworkOnline];
    }];
    
}

- (void)_action_OnLoading_NetworkTurnedOn
{
    // Get initialize status flag
    NSString *_initStatus = (NSString *)[[PYKernel currentKernel] kernelObjectForKey:kPYInitializeStatusFlag];
    
    // If the status is broken, then try to re-initialize
    if ( [_initStatus isEqualToString:@"broken"] ) {
        [self _action_Initialize_Client];
    }
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
