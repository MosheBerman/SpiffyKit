//
//  SpiffyController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/16/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyController.h"

#import "SpiffyViewController.h"

#import <UIKit/UIKit.h>

@interface SpiffyController ()

@end

@implementation SpiffyController

+ (SpiffyController *)sharedController
{
		static SpiffyController *controller = nil;
		
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
				controller = [[SpiffyController alloc] init];
		});
		
		return controller;
}

#pragma mark - Presentation

- (void)presentInViewController:(UIViewController *)viewController
{
		SpiffyViewController *spiffyViewController = [[SpiffyViewController alloc] init];
		
		[viewController presentViewController:spiffyViewController animated:YES completion:nil];
}

#pragma mark - Diagnostics

- (void)toggleDiagnostics:(UISwitch *)sender
{
		BOOL enabled = [sender isOn];
		
		[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"SpiffyKitDiagnosticsEnabled"];
}

- (BOOL)diagnosticsEnabled
{
		return [[NSUserDefaults standardUserDefaults] boolForKey:@"SpiffyKitDiagnosticsEnabled"];
}


#pragma mark - Analytics

- (void)toggleAnalytics:(UISwitch *)sender
{
		BOOL enabled = [sender isOn];
		
		[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"SpiffyKitAnalyticsEnabled"];
}

- (BOOL)analyticsEnabled
{
		return [[NSUserDefaults standardUserDefaults] boolForKey:@"SpiffyKitAnalyticsEnabled"];
}

@end
