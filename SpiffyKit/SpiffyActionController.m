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

#import "AppDataManager.h"

@interface SpiffyActionController ()

@end

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

#pragma mark - Present a UIActivityViewController

+ (UIActivityViewController *)activityViewController
{
		
		NSString *shareString = [self _shareMessage];
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
		
		UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityTypes applicationActivities:activityData];
		
		[activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
				if (completed) {
						
				}
		}];

		return activityViewController;
		
}

+ (MFMailComposeViewController *)supportEmailComposer
{
		return [self showMailComposerWithSubject:[self _supportSubject] andMessage:[self _supportMessage] andAttachments:[self _supportAttachments]];
}

+ (MFMailComposeViewController *)shareEmailComposer
{
		return [self showMailComposerWithSubject:[self _shareSubject] andMessage:[self _shareMessage] andAttachments:nil];
}

#pragma mark - Present an MFMailComposer

+ (MFMailComposeViewController *)showMailComposerWithSubject:(NSString *)subject andMessage:(NSString *)message andAttachments:(NSDictionary *)attachments
{
		MFMailComposeViewController *mailComposeViewController;
		
		if ([MFMailComposeViewController canSendMail])
		{
				
				
				mailComposeViewController = [[MFMailComposeViewController alloc] init];
				
				[mailComposeViewController setToRecipients:@[kSupportEmailAddress]];
				
				[mailComposeViewController setSubject:subject];
				
				[mailComposeViewController setMessageBody:message isHTML:NO];
				
				for (NSString *attachmentKey in [attachments allKeys]) {
						
						NSString *filename = [NSString stringWithFormat:@"%@.txt", attachmentKey];
						
						[mailComposeViewController addAttachmentData:attachments[attachmentKey] mimeType:@"text/plain" fileName:filename];
				}
		}
				return mailComposeViewController;		
}

#pragma mark - Share Subject and Message

+ (NSString *)_shareSubject
{
		return [NSString stringWithFormat:@"Check out %@!", kAppName];
		
}

+ (NSString *)_shareMessage
{
		NSString *shareString = [NSString stringWithFormat:@"I think you'd like to check out %@ on the App Store. You can download it at %@.", kAppName, kAppURL];
		return shareString;
}

#pragma mark - Support Subject and Message

+ (NSString *)_supportSubject
{
		return [NSString stringWithFormat:@"%@ Support Request", kAppName];
		
}

+ (NSString *)_supportMessage
{
		return [NSString stringWithFormat:@"I'm using %@ and I'd like to talk to you about it.\n\n", kAppName];
}

+ (NSDictionary *)_supportAttachments
{
		NSDictionary *attachments = @{@"Device": [AppDataManager deviceData],
																@"Defaults": [AppDataManager defaultsData],
																@"Locale": [AppDataManager localeData],
																@"AppBundle" : [AppDataManager appData]};
		return attachments;
}

@end
