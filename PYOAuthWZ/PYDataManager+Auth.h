//
//  PYDataManager+Auth.h
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

#import <PYData/PYData.h>

/*!
 @brief On any action failed, will send this notification
 */
extern NSString * kPYActionFailedNotification;

/*!
 @brief The initialize status flag.
 If the network is broken duration launching, this flag will be
 set to @"broken", and when network resume, the server should
 try to re-auth the client.
 The status flag is stored in kernel cache
 */
extern NSString *kPYInitializeStatusFlag;

@interface PYDataManager (Auth)

/*!
 @brief The global initialization method.
 */
- (void)PYInitializeClient:(PYActionDone)done;

/*!
 @brief Logout
 */
- (void)PYLogoutAndRefreshToken:(PYActionDone)done;

/*!
 @brief The error handler
 */
- (void)PYErrorHandler:(NSError *)error shouldRedoAction:(PYActionDone)done;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
