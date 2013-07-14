//
//  SpiffyViewController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyViewController.h"

#import "SpiffyActionController.h"

#import <MessageUI/MessageUI.h>

#import "Constants.h"

@interface SpiffyViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *labels;

@end

@implementation SpiffyViewController

+ (SpiffyViewController *)sharedController
{
		static SpiffyViewController *controller = nil;
		
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
				controller = [[SpiffyViewController alloc] init];
		});
		return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
		
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
		
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
		
		
		NSArray *localizedLabelsForSectionZero = @[NSLocalizedString(@"Share", @"A label which allows users to share apps via social media and email."),
																						 NSLocalizedString(@"Review", @"A label for a button which allows users to review the app on the store."),
																						 NSLocalizedString(@"More Apps", @"A label for a button which shows more apps from the same developer.")];
		
		NSArray *localizedLabelsForSectionOne = @[NSLocalizedString(@"Say Hello", @"A button which allows the user to contact the developer via email.")];
		
		NSArray *localizedLabels = @[localizedLabelsForSectionZero, localizedLabelsForSectionOne];
		
		[self setLabels:localizedLabels];
		
		[[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
		
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
		
		NSString *text = [self labels][[indexPath section]][[indexPath row]];
		[[cell textLabel] setText:text];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
						
						NSString *reviewURLFormat = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=%@", kAppStoreIdentifier];
						
						NSURL *url = [NSURL URLWithString:reviewURLFormat];
						[self openURL:url];
				}
				else if(2 == [indexPath row])
				{
						NSURL *url= [NSURL URLWithString:kMoreAppsURL];
						[self openURL:url];
						
				}
		}
		else if (1 == [indexPath section])
		{
				MFMailComposeViewController *composer = (MFMailComposeViewController *)[SpiffyActionController supportEmailComposer];
				[composer setMailComposeDelegate:self];
				[self presentViewController:composer animated:YES completion:nil];
		}
}

- (void)openURL:(NSURL *)url
{
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
				[[UIApplication sharedApplication] openURL:url];
		}
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

@end
