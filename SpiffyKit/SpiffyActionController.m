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
		
		NSString *shareMessage = [self _shareMessage];

		NSArray *items = @[shareMessage];
		
		UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
		
		[activityViewController setCompletionHandler:nil];

		if (![self canSendEmail]) {
				[self _addExclusionType:UIActivityTypeMail toActivityViewController:activityViewController];
		}
		if (![self canSendText])
		{
				[self _addExclusionType:UIActivityTypeMessage toActivityViewController:activityViewController];
		}
		if(![self canUseFacebook])
		{
				[self _addExclusionType:UIActivityTypePostToFacebook toActivityViewController:activityViewController];
		}
		if(![self canUseTwitter])
		{
				[self _addExclusionType:UIActivityTypePostToTwitter toActivityViewController:activityViewController];
		}
		if (![self canUseSinaWeibo])
		{
				[self _addExclusionType:UIActivityTypePostToWeibo toActivityViewController:activityViewController];
		}
		
		return activityViewController;
		
}

+ (void)_addExclusionType:(NSString *)type toActivityViewController:(UIActivityViewController *)activityViewController
{
		NSArray *excludedTypes = [@[type] arrayByAddingObjectsFromArray:activityViewController.excludedActivityTypes];
		activityViewController.excludedActivityTypes = excludedTypes;
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
		return [NSString stringWithFormat:@"Check out %@!", [AppDataManager appName]];
		
}

+ (NSString *)_shareMessage
{
		NSString *shareString = [NSString stringWithFormat:@"I think you'd like to check out %@ on the App Store. You can download it at %@.", [AppDataManager appName], kAppURL];
		return shareString;
}


#pragma mark - Support Subject and Message

+ (NSString *)_supportSubject
{
		return [NSString stringWithFormat:@"%@ Feedback", [AppDataManager appName]];
		
}

+ (NSString *)_supportMessage
{
		return [NSString stringWithFormat:@"I'm using %@ and I'd like to talk to you about it.\n\n", [AppDataManager appName]];
}

+ (NSDictionary *)_supportAttachments
{
		NSDictionary *attachments = @{@"Diagnostic": [AppDataManager appDataAsSingleFile]};
		return attachments;
}

@end
