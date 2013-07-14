//
//  SpiffyActionController.h
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpiffyActionController : NSObject

#pragma mark - Messaging Availability Checks

+ (BOOL)canSendEmail;
+ (BOOL)canSendText;

#pragma mark - Social Services Availability Checks

+ (BOOL)canUseTwitter;
+ (BOOL)canUseFacebook;
+ (BOOL)canUseSinaWeibo;

#pragma mark - Generalized Feature Availability Checks

+ (BOOL)canUseAtLeastOneSocialService;	//	True if one or more of the three above is true
+ (BOOL)canShare;												//	True if one of social or messaging services are enabled.

#pragma mark - Display a UIActivityViewController

+ (void)displayActivityViewController;

#pragma mark - Show Mail Composers

+ (void)showShareEmail;
+ (void)showSupportEmail;

@end
