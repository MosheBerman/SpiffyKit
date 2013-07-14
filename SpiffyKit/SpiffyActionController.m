//
//  SpiffyActionController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyActionController.h"
#import "Constants.h"

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

+ (BOOL)canUseAtLeastOneMessagingService
{
		return [self canSendText] || [self canSendEmail];
}

+ (BOOL)canShare
{
		return [self canUseAtLeastOneSocialService] || [self canUseAtLeastOneMessagingService];
}

#pragma mark - Display a UIActivityViewController

+ (void)displayActivityViewController
{
		
		NSString *shareString = [NSString stringWithFormat:@"I think you'd like to check out %@ on the App Store. You can download it at %@.", kAppName, kAppURL];
		NSArray *activityData = @[shareString];
		NSMutableArray *activityTypes = [[NSMutableArray alloc] init];
		
		if ([self canSendEmail])
		{
				[activityTypes addObject:UIActivityTypeMail];
		}
		if ([self canSendText])
		{
				[activityTypes addObject:UIActivityTypeMessage];
		}
		if ([self canUseFacebook])
		{
				[activityTypes addObject:UIActivityTypePostToFacebook];
		}
		if ([self canUseTwitter])
		{
				[activityTypes addObject:UIActivityTypePostToTwitter];
		}
		if ([self canUseSinaWeibo])
		{
				[activityTypes addObject:UIActivityTypePostToWeibo];
		}

		UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityData applicationActivities:activityTypes];
		
		[activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
				if (completed) {
						
				}
		}];
		
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:activityViewController animated:YES completion:nil];
}

@end
