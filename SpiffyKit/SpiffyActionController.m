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

@interface SpiffyActionController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation SpiffyActionController

#pragma mark - Singleton

- (SpiffyActionController *)sharedController
{
		
		SpiffyActionController *actionController = nil;
		
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
				actionController = [[SpiffyActionController alloc] init];
		});
		
		return actionController;
}

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

+ (void)showActivityViewController
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
		
		[[[self sharedController] targetViewController] presentViewController:activityViewController animated:YES completion:nil];
}

+ (void)showSupportEmail
{
		[self showMailComposerWithSubject:[self _supportSubject] andMessage:[self _supportMessage] andAttachments:[self _supportAttachments]];
}

+ (void)showShareEmail
{
		[self showMailComposerWithSubject:[self _shareSubject] andMessage:[self _shareMessage] andAttachments:nil];
}

#pragma mark - Present an MFMailComposer

+ (void)showMailComposerWithSubject:(NSString *)subject andMessage:(NSString *)message andAttachments:(NSDictionary *)attachments
{
		if ([MFMailComposeViewController canSendMail])
		{
				
				MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
				
				[mailComposeViewController setToRecipients:@[kSupportEmailAddress]];
				
				[mailComposeViewController setSubject:subject];
				
				[mailComposeViewController setMessageBody:message isHTML:NO];
				
				[mailComposeViewController setMailComposeDelegate:[self targetViewController]];
				
				for (NSString *attachmentKey in [attachments allKeys]) {
						
						NSString *filename = [NSString stringWithFormat:@"%@.txt", attachmentKey];
						
						[mailComposeViewController addAttachmentData:attachments[attachmentKey] mimeType:@"text/plain" fileName:filename];
				}
				
				[[self targetViewController] presentViewController:mailComposeViewController animated:YES completion:nil];
		}
}

#pragma mark - Share Subject and Message

+ (NSString *)_shareSubject
{
		return [NSString stringWithFormat:@"Check out %@!", kAppName];
		
}

+ (NSString *)_shareMessage
{
		#warning Unimplemented share method
		return @"";
}

#pragma mark - Support Subject and Message

+ (NSString *)_supportSubject
{
		return [NSString stringWithFormat:@"%@ Support Request", kAppName];
		
}

+ (NSString *)_supportMessage
{
		
		#warning Unimplemented support method
		
		return @"";
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
