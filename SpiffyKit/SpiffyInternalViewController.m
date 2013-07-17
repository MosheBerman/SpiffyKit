//
//  SpiffyViewController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyInternalViewController.h"

#import "Constants.h"
#import "AppDataManager.h"

#import "SpiffyActionController.h"
#import "SpiffyController.h"

#import "SpiffyTableViewCell.h"
#import "SpiffySwitchCell.h"

#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface SpiffyInternalViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SpiffyInternalViewController

+ (SpiffyInternalViewController *)sharedController
{
		static SpiffyInternalViewController *controller = nil;
		
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
				controller = [[SpiffyInternalViewController alloc] init];
		});
		return controller;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
				// Transition
				[self setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
				
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
		
		//	Title
		NSString *name = [AppDataManager appName];
		
		[[self navigationItem] setTitle:name];
		
		//
		NSString *localizedTwitterFormat = NSLocalizedString(@"Follow @%@", @"A label for a button which allows users to follow you on Twitter.");
		
		NSString *twitterHandle = [[SpiffyController sharedController] twitterHandle];
		NSString *twitterPhrase = [twitterHandle length] ? [NSString stringWithFormat:localizedTwitterFormat, twitterHandle] : nil;
		
		
		//	Table labels
		NSArray *localizedLabelsForSectionZero = @[NSLocalizedString(@"Tell a Friend", @"A label which allows users to share apps via social media and email."),
																						 NSLocalizedString(@"Review", @"A label for a button which allows users to review the app on the store."),
																						 NSLocalizedString(@"More Apps", @"A label for a button which shows more apps from the same developer.")];
		
		NSArray *localizedLabelsForSectionOne = @[NSLocalizedString(@"Say Hello", @"A button which allows the user to contact the developer via email.")];
		
		
		NSArray *localizedLabelsForSectionTwo = @[NSLocalizedString(@"Send Diagnostics", @"A button which allows the user to toggle diagnostics."),
																						NSLocalizedString(@"Analytics", @"A button which allows the user to toggle analytics.")];
		
		if (twitterHandle) {
				localizedLabelsForSectionOne = [localizedLabelsForSectionOne arrayByAddingObject:twitterPhrase];
		}
		
		NSArray *localizedLabels = @[localizedLabelsForSectionZero, localizedLabelsForSectionOne, localizedLabelsForSectionTwo];
		
		[self setLabels:localizedLabels];
		
		//	Table Cell
		[[self tableView] registerClass:[SpiffyTableViewCell class] forCellReuseIdentifier:@"Cell"];
		[[self tableView] registerClass:[SpiffySwitchCell class] forCellReuseIdentifier:@"SwitchCell"];
		
		
		//	Table Font
		[self setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:16.0f]];
		
		//	Done Button
		UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
		[[self navigationItem] setLeftBarButtonItem:done animated:NO];
		
		//	Image View
		NSString *imageName = [AppDataManager appIconName];
		UIImage *appIcon = [UIImage imageNamed: imageName];
		UIImageView *appIconView = [[UIImageView alloc] initWithImage:appIcon];
		
		CGRect bounds = [appIconView bounds];
		bounds.size = CGSizeMake(57, 57);
		[appIconView setFrame:bounds];
		
		//	Image radius
		CGFloat radius = (10.0f/57.0f)*appIconView.frame.size.height;
		[[appIconView layer] setCornerRadius:radius];
		[appIconView setClipsToBounds:YES];
		
		[self setImageView:appIconView];
		
		//	Header View
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, bounds.size.height + 10)];
		[self setHeaderView:headerView];
		
		//	Center the image in the header...
		bounds = [appIconView bounds];
		bounds.origin = CGPointMake(headerView.frame.size.width/2 - bounds.size.width/2, headerView.frame.size.height/2 - bounds.size.height/2);
		[appIconView setFrame:bounds];
		
		//	...even on rotation
		[appIconView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
		
		//	Install the image in the header
		[headerView addSubview:appIconView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
		
    // Return the number of sections.
    return [[self labels] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
		
    // Return the number of rows in the section.
    return [[self labels][section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
		NSString *text = [self labels][[indexPath section]][[indexPath row]];
		
		if (2 == [indexPath section])
		{
				SpiffySwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
				
				[[switchCell switchLabel] setText:text];
				
				if (0 == [indexPath row])
				{
						[switchCell.toggle addTarget:[SpiffyController sharedController] action:@selector(toggleDiagnostics:) forControlEvents:UIControlEventValueChanged];
						[switchCell.toggle setEnabled:[[SpiffyController sharedController] diagnosticsEnabled]];
				}
				else if (1 == [indexPath row])
				{
						[switchCell.toggle addTarget:[SpiffyController sharedController] action:@selector(toggleAnalytics:) forControlEvents:UIControlEventValueChanged];
						[switchCell.toggle setEnabled:[[SpiffyController sharedController] analyticsEnabled]];
				}
				cell = switchCell;
		}
		else
		{
				SpiffyTableViewCell *spiffyCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
				// Configure the cell...
				
				[[spiffyCell textLabel] setText:text];
				[[spiffyCell textLabel] setFont:[self font]];
				[spiffyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
				
				[spiffyCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
				
				cell = spiffyCell;
		}
		return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		if (0 == [indexPath section])
		{
				if (0 == [indexPath row]) {
						if ([SpiffyActionController canShare]) {
								UIActivityViewController *activityController = [SpiffyActionController activityViewController];
								[self presentViewController:activityController animated:YES completion:nil];
						}
						else
						{
								
								NSString *title = NSLocalizedString(@"Sharing Disabled", @"A title for an alert explaining that sharing is unavaialable");
								NSString *message = NSLocalizedString(@"Sharing isn't enabled. Set up email or a social media account on this device to enable sharing.", @"A message for when sharing is disabled.");
								NSString *cancelButtonTitle = NSLocalizedString(@"Dismiss", @"A title to dismiss an error message.");
								UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
								[alert show];
						}
				}
				else if (1 == [indexPath row])
				{
						
						// Relevant SO Link: http://stackoverflow.com/questions/3374050/url-for-sending-a-user-to-the-app-review-page-on-devices-app-store
						
						NSString *reviewURLFormat = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=%@", [[SpiffyController sharedController] appStoreIdentifier]];
						
						NSURL *url = [NSURL URLWithString:reviewURLFormat];
						[self openURL:url];
				}
				else if(2 == [indexPath row])
				{
						NSURL *url= [NSURL URLWithString:[[SpiffyController sharedController] moreAppsURL]];
						[self openURL:url];
						
				}
		}
		else if (1 == [indexPath section])
		{
				if(0 == indexPath.row)
				{
						MFMailComposeViewController *composer = (MFMailComposeViewController *)[SpiffyActionController supportEmailComposer];
						[composer setMailComposeDelegate:self];
						[self presentViewController:composer animated:YES completion:nil];
				}
				else if (1 == indexPath.row)
				{
						NSString *urlFormat = [NSString stringWithFormat:@"http://twitter.com/%@", [[SpiffyController sharedController] twitterHandle]];
						NSURL *url = [NSURL URLWithString:urlFormat];
						[self openURL:url];
				}
				else if (2 == indexPath.row)
				{
						
				}
		}
}

- (void)openURL:(NSURL *)url
{
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
				[[UIApplication sharedApplication] openURL:url];
		}
		else
		{
				NSString *title = NSLocalizedString(@"Invalid Address", @"A title for an alert explaining that a given URL is unavaialable");
				NSString *message = NSLocalizedString(@"This app is trying to open a web address that your %@ doesn't know how to handle.", @"A message for when sharing is disabled.");
				NSString *messageFormat = [NSString stringWithFormat:message, [[UIDevice currentDevice] localizedModel]];
				NSString *cancelButtonTitle = NSLocalizedString(@"Dismiss", @"A title to dismiss an error message.");
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageFormat delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
				[alert show];
		}
}

#pragma mark - Table Header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
		
		CGFloat height = 0;
		if (0 == section)
		{
				
				NSString *imageName = [AppDataManager appIconName];
				
				if (imageName) {
						
						height = [[self headerView] frame].size.height;
				}
		}
		
		return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
		if (0 == section) {
				return [self headerView];
		}
		return nil;
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
		[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
		[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Done

- (void)dismiss
{
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
