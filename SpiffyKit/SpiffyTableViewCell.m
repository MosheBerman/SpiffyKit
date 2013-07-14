//
//  SpiffyTableViewCell.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyTableViewCell.h"

#import "Constants.h"

@implementation SpiffyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
		
		UIColor *backgroundColor = kAppColor;
		NSTimeInterval interval = 0.3;
		
		if (!selected) {
				backgroundColor = [UIColor whiteColor];
		}
		
		if (!animated) {
				interval = 0;
		}
		
		[UIView animateWithDuration:interval animations:^{
				[self setBackgroundColor:backgroundColor];
		}];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
		
}

@end
