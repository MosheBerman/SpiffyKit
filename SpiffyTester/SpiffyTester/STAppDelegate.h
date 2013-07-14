//
//  STAppDelegate.h
//  SpiffyTester
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STViewController;

@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) STViewController *viewController;

@end
