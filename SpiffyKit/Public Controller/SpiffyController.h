//
//  SpiffyController.h
//  SpiffyKit
//
//  Created by Moshe Berman on 7/16/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class UISwitch;

@interface SpiffyController : NSObject

@property (nonatomic, strong) NSString *appStoreIdentifier;
@property (nonatomic, strong) NSString *appURL;
@property (nonatomic, strong) NSString *websiteURL;
@property (nonatomic, strong) NSString *moreAppsURL;

@property (nonatomic, strong) NSString *supportEmailAddress;
@property (nonatomic, strong) NSString *twitterHandle;

+ (SpiffyController *)sharedController;

- (void)presentInViewController:(UIViewController *)viewController;

#pragma mark - Diagnostics

- (void)toggleDiagnostics:(UISwitch *)sender;
- (BOOL)diagnosticsEnabled;

#pragma mark - Analytics

- (void)toggleAnalytics:(UISwitch *)sender;
- (BOOL)analyticsEnabled;

@end
