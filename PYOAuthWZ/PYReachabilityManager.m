//
//  PYReachabilityManager.m
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

#import <PYNetwork/PYNetwork.h>
#import "PYReachabilityManager.h"

static PYReachabilityManager *_gReach = nil;

@interface PYReachabilityManager ()
{
    PYReachability      *_networkReachability;
    BOOL                _isMonitoring;
}
@end

@implementation PYReachabilityManager

- (id)init
{
    self = [super init];
    if ( self ) {
        _networkReachability = [PYReachability reachabilityForInternetConnection];
        [_networkReachability
         addTarget:self
         action:@selector(_networkReachable)
         forEvent:PYReachabilityNetworkReachable];
        [_networkReachability
         addTarget:self
         action:@selector(_networkNotReachable)
         forEvent:PYReachabilityNetworkNotReachable];
    }
    return self;
}

+ (instancetype)shared
{
    PYSingletonLock
    if ( _gReach == nil ) {
        _gReach = [PYReachabilityManager object];
    }
    return _gReach;
    PYSingletonUnLock
}

PYSingletonAllocWithZone(_gReach)
PYSingletonDefaultImplementation

- (BOOL)startService
{
    _isMonitoring = [_networkReachability startMonitor];
    return _isMonitoring;
}

- (BOOL)stopService
{
    [_networkReachability stopMonitor];
    _isMonitoring = NO;
    return YES;
}

- (BOOL)restartService
{
    [self stopService];
    return [self startService];
}

@dynamic isRunning;
- (BOOL)isRunning
{
    return _isMonitoring;
}

- (void)_networkReachable
{
    [self invokeTargetWithEvent:kPYNetworkOnline];
}

- (void)_networkNotReachable
{
    [self invokeTargetWithEvent:kPYNetworkUnreachable];
}

@dynamic currentNetworkStatus;
- (PYNetworkStatus)currentNetworkStatus
{
    return _networkReachability.reachableStatus;
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
