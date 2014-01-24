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
        controller = [[SpiffyInternalViewController alloc] initWithStyle:UITableViewStyleGrouped];
    });
    return controller;
}

- (void)viewDidLoad
{
    [self setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    
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
                                               NSLocalizedString(@"Write a Review", @"A label for a button which allows users to review the app on the store."),
                                               NSLocalizedString(@"See More Apps", @"A label for a button which shows more apps from the same developer.")];
    
    NSArray *localizedLabelsForSectionOne = @[NSLocalizedString(@"Say Hello", @"A button which allows the user to contact the developer via email.")];
    
    
    NSArray *localizedLabelsForSectionTwo = @[NSLocalizedString(@"Send Diagnostics", @"A button which allows the user to toggle diagnostics."),];
    
    if (twitterHandle) {
        localizedLabelsForSectionOne = [localizedLabelsForSectionOne arrayByAddingObject:twitterPhrase];
    }
    
    if ([[SpiffyController sharedController] shouldPresentAnalytics]) {
        NSString *analytics = NSLocalizedString(@"Send Analytics", @"A button which allows the user to toggle analytics.");
        localizedLabelsForSectionTwo =[localizedLabelsForSectionTwo arrayByAddingObject:analytics];
    }
    
    NSArray *localizedLabels = @[localizedLabelsForSectionZero, localizedLabelsForSectionOne, localizedLabelsForSectionTwo];
    
    [self setLabels:localizedLabels];
    
    //	Table Cell
//    [[self tableView] registerClass:[SpiffyTableViewCell class] forCellReuseIdentifier:@"Cell"];
//    [[self tableView] registerClass:[SpiffySwitchCell class] forCellReuseIdentifier:@"SwitchCell"];
    
    
    //	Table Font
    [self setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:16.0f]];
    
    //	Done Button
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
        [[self navigationItem] setLeftBarButtonItem:done animated:NO];
    }
    
    //	Image View

    //  By default, attempt to access the Xcode 5 asset catelog
    UIImage *appIcon = [UIImage imageNamed:@"AppIcon"];
    
    //  If that fails, try pulling an icon name from Info.plist.
    if (!appIcon) {
        NSString *imageName = [AppDataManager appIconName];
        appIcon = [UIImage imageNamed: imageName];
    }
    
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
        SpiffySwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        if (!switchCell) {
            switchCell = [[SpiffySwitchCell alloc] init];
        }
        
        
        [[switchCell switchLabel] setText:text];
        
        if (0 == [indexPath row])
        {
            [switchCell.toggle addTarget:[SpiffyController sharedController] action:@selector(toggleDiagnostics:) forControlEvents:UIControlEventValueChanged];
            [switchCell.toggle setOn:[[SpiffyController sharedController] diagnosticsEnabled]];
        }
        else if (1 == [indexPath row])
        {
            [switchCell.toggle addTarget:[SpiffyController sharedController] action:@selector(toggleAnalytics:) forControlEvents:UIControlEventValueChanged];
            [switchCell.toggle setOn:[[SpiffyController sharedController] analyticsEnabled]];
        }
        cell = switchCell;
    }
    else
    {
        SpiffyTableViewCell *spiffyCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        
        if (!spiffyCell) {
            spiffyCell = [[SpiffyTableViewCell alloc] init];
        }
        
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
            
            if([SpiffyActionController isLegacyOS]) {
                if ([SpiffyActionController canSendEmail]) {
                    [SpiffyActionController shareEmailComposer];
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
            else if ([SpiffyActionController canShare]) {
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
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                reviewURLFormat = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", [[SpiffyController sharedController] appStoreIdentifier]];
            }
            
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
            if(composer)
            {
                [composer setMailComposeDelegate:self];
                [self presentViewController:composer animated:YES completion:nil];
            }
            else
            {
                NSString *title = NSLocalizedString(@"No Email Support", @"A title for alerts that are related to email.");
                NSString *message = NSLocalizedString(@"It looks like email isn't set up on this device.", @"A message for when email isn't set up.");
                [self alertWithTitle:title andMessage:message];
            }
        }
        else if (1 == indexPath.row)
        {
            
            
            NSString *urlFormat = [NSString stringWithFormat:@"twitter://user?screen_name=%@",[[SpiffyController sharedController] twitterHandle]];
            NSURL *url = [NSURL URLWithString:urlFormat];
            if(![[UIApplication sharedApplication] canOpenURL:url]) {
                urlFormat = [NSString stringWithFormat:@"http://twitter.com/%@", [[SpiffyController sharedController] twitterHandle]];
                url = [NSURL URLWithString:urlFormat];
            }
            [self openURL:url];
        }
        else if (2 == indexPath.row)
        {
            
        }
    }
    else if (2 == [indexPath section])
    {
        
        SpiffySwitchCell *cell = (SpiffySwitchCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.toggle setOn:!cell.toggle.isOn animated:YES];
        
        if (0 == [indexPath row])
        {
            [[SpiffyController sharedController] toggleDiagnostics:cell.toggle];
        }
        else if (1 == [indexPath row])
        {
            [[SpiffyController sharedController] toggleAnalytics:cell.toggle];
        }
        
        
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if (2 == section) {
        
        NSString *appFormat = [NSString stringWithFormat:@"%@ %@ (%@)", [AppDataManager appName], [AppDataManager appVersion], [AppDataManager appBuild]];
        
        title = appFormat;
    }
    
    return title;
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

#pragma mark - Utility Methods

- (void)openURL:(NSURL *)url
{
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if(![[UIApplication sharedApplication] openURL:url])
        {
            NSString *title = @"";
            NSString *message = NSLocalizedString(@"It looks like your %@ doesn't have Safari enabled. Is there a restriction enabled in Settings?", @"A message for when safari is disabled.");
            [self alertWithTitle:title andMessage:message];
        }
        
    }
    else
    {
        NSString *title = NSLocalizedString(@"Invalid Address", @"A title for an alert explaining that a given URL is unavaialable");
        NSString *message = NSLocalizedString(@"This app is trying to open a web address that your %@ doesn't know how to handle.", @"A message for when sharing is disabled.");
        [self alertWithTitle:title andMessage:message];
    }
}

- (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    NSString *messageFormat = [NSString stringWithFormat:message, [[UIDevice currentDevice] localizedModel]];
    NSString *cancelButtonTitle = NSLocalizedString(@"Dismiss", @"A title to dismiss an error message.");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageFormat delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    [alert show];
}

- (void)dismiss
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}



@end
