//
//  SpiffyAboutViewController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyViewController.h"

#import "SpiffyInternalViewController.h"

#import "Constants.h"

#import "AppDataManager.h"

@interface SpiffyViewController ()

@property (nonatomic, strong) UIColor *originalColor;

@end

@implementation SpiffyViewController

- (id)init
{	
    SpiffyInternalViewController *spiffyViewController = [[SpiffyInternalViewController alloc] init];
    self = [super initWithRootViewController:spiffyViewController];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
		
}

- (void)viewWillAppear:(BOOL)animated
{
		[super viewWillAppear:animated];
		
		[self setOriginalColor:[[UINavigationBar appearance] tintColor]];
		[[UINavigationBar appearance] setTintColor:[AppDataManager appColor]];
}

- (void)viewDidDisappear:(BOOL)animated
{
		[super viewDidDisappear:animated];
		
		[[UINavigationBar appearance] setTintColor:[self originalColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Popover

- (BOOL)modalInPopover
{
		return YES;
}

- (CGSize)contentSizeForViewInPopover
{
		return CGSizeMake(320, 568);
}

@end
