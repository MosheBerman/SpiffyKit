//
//  SpiffySwitchCell.h
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SpiffyTableViewCell.h"

@interface SpiffySwitchCell : SpiffyTableViewCell


@property (strong, nonatomic) UILabel *switchLabel;
@property (strong, nonatomic) UISwitch *toggle;

@end
