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

#import "Flurry.h"


@interface SpiffyController () <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) SpiffyViewController *spiffyViewController;

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

- (id)init
{
    self = [super init];
    if (self) {
        _shouldPresentAnalytics = NO;
        [self setDefaultsIfNecessary];
    }
    return self;
}
#pragma mark - Presentation

- (void)presentInViewController:(UIViewController *)viewController fromRectWhereApplicable:(CGRect)rect
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [[self popover] presentPopoverFromRect:rect inView:viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [viewController presentViewController:[self spiffyViewController] animated:YES completion:nil];
    }
}

#pragma mark - Spiffy

- (SpiffyViewController *)spiffyViewController
{
    if (!_spiffyViewController) {
        _spiffyViewController = [[SpiffyViewController alloc] init];
    }
    return _spiffyViewController;
}

#pragma mark - Popover


- (UIPopoverController *)popover
{
    if (!_popover) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:[self spiffyViewController]];
        [_popover setDelegate:self];
    }
    return _popover;
}

#pragma mark - Diagnostics

- (void)toggleDiagnostics:(UISwitch *)sender
{
    BOOL enabled = [sender isOn];
    
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"SpiffyKitDiagnosticsEnabled"];
    
    /** Log event if analytics are enabled. */
    if([[SpiffyController sharedController] analyticsEnabled]) {
        
        NSDictionary *parameters = @{@"Enabled" : @(enabled)};
        [Flurry logEvent:@"Toggling Diagnostics" withParameters:parameters];
    }
    
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
    
    /** Log event if analytics are enabled. */
    if([[SpiffyController sharedController] analyticsEnabled]) {
        
        NSDictionary *parameters = @{@"Enabled" : @(enabled)};
        [Flurry logEvent:@"Toggling Analytics" withParameters:parameters];
    }
}

- (BOOL)analyticsEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SpiffyKitAnalyticsEnabled"];
}

#pragma mark - Defaults

- (void)setDefaultsIfNecessary
{
    if (![self userDefaultsContainsKey:@"SpiffyKitDiagnosticsEnabled"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SpiffyKitDiagnosticsEnabled"];
    }
    
    if (![self userDefaultsContainsKey:@"SpiffyKitAnalyticsEnabled"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SpiffyKitAnalyticsEnabled"];
    }
}

- (BOOL)userDefaultsContainsKey:(NSString *)key
{
    return [[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:key];
}

@end
