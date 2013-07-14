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

#pragma mark - Feature Availability Checks

+ (BOOL)canSendEmail
{
		return [MFMailComposeViewController canSendMail];
}

+ (BOOL)canSendText
{
		return [MFMessageComposeViewController canSendText];
}

+ (BOOL)canUseTwitter
{
		return [self canUseSocialService:SLServiceTypeTwitter];
}

+ (BOOL)canUseFacebook
{
		return [self canUseSocialService:SLServiceTypeFacebook];
}

+ (BOOL)canUseSinaWeibo
{
		return [self canUseSocialService:SLServiceTypeSinaWeibo];
}

+ (BOOL)canUseSocialService:(NSString *)serviceType
{
		return [SLComposeViewController isAvailableForServiceType:serviceType];
}

@end
