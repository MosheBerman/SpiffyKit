//
//  SpiffyAboutViewController.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyAboutViewController.h"

#import "SpiffyViewController.h"

@interface SpiffyAboutViewController ()

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
		
		[[self navigationBar] setTintColor:[UIColor orangeColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
