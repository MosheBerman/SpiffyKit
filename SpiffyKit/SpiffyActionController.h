//
//  SpiffyActionController.h
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MFMailComposeViewControllerDelegate;
@protocol MFMessageComposeViewControllerDelegate;

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

+ (UIActivityViewController *)activityViewController;

#pragma mark - Show Mail Composers

+ (UIViewController *)supportEmailComposer;
+ (UIViewController *)shareEmailComposer;

#pragma mark - Diagnostics

+ (void)toggleDiagnostics:(UISwitch *)sender;
+ (BOOL)diagnosticsEnabled;

#pragma mark - Analytics

+ (void)toggleAnalytics:(UISwitch *)sender;
+ (BOOL)analyticsEnabled;

@end
