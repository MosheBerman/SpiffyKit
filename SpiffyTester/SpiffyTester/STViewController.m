//
//  STViewController.m
//  SpiffyTester
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "STViewController.h"

@interface STViewController ()

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
		
		[[self showSpiffyViewButton] addTarget:self action:@selector(showSpiffyView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showSpiffyView
{
		SpiffyViewController *spiffyViewController = [SpiffyViewController sharedController];
		
		[self presentViewController:spiffyViewController animated:YES completion:nil];

}
@end
