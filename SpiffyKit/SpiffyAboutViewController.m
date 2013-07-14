//
//  SpiffyAboutViewController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyAboutViewController.h"

#import "SpiffyViewController.h"

#import "Constants.h"

@interface SpiffyAboutViewController ()

@property (nonatomic, strong) UIColor *originalColor;

@end

@implementation SpiffyAboutViewController

- (id)init
{
		SpiffyViewController *spiffyViewController = [[SpiffyViewController alloc] init];
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
		[[UINavigationBar appearance] setTintColor:kAppColor];
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

@end
