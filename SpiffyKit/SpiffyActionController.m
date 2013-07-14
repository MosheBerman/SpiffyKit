//
//  SpiffyActionController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyActionController.h"

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@implementation SpiffyActionController

#pragma mark - Messaging Availability Checks

+ (BOOL)canSendEmail
{
		return [MFMailComposeViewController canSendMail];
}

+ (BOOL)canSendText
{
		return [MFMessageComposeViewController canSendText];
}

#pragma mark - Social Services Availability Checks

+ (BOOL)canUseTwitter
{
		return [self _canUseSocialService:SLServiceTypeTwitter];
}

+ (BOOL)canUseFacebook
{
		return [self _canUseSocialService:SLServiceTypeFacebook];
}

+ (BOOL)canUseSinaWeibo
{
		return [self _canUseSocialService:SLServiceTypeSinaWeibo];
}


+ (BOOL)_canUseSocialService:(NSString *)serviceType
{
		return [SLComposeViewController isAvailableForServiceType:serviceType];
}

#pragma mark - Generalized Feature Availability Checks

+ (BOOL)canUseAtLeastOneSocialService
{
		return [self canUseTwitter] || [self canUseFacebook] || [self canUseSinaWeibo];
}

+ (BOOL)canShare
{
		
}
@end
