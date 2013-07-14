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

- (void)setSelected:(BOOL)selected
{
		[self setSelected:selected animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
		
		UIColor *backgroundColor = kAppColor;
		UIColor *textColor = kCellHighlightedColor;
		NSTimeInterval interval = 1;
		
		if (!selected) {
				backgroundColor = [UIColor whiteColor];
				textColor = kCellColor;
		}
				
		[UIView animateWithDuration:interval animations:^{
				[self setBackgroundColor:backgroundColor];
				[[self textLabel] setTextColor:textColor];
		}];
}

- (void)setHighlighted:(BOOL)highlighted
{
		[self setHighlighted:highlighted animated:YES];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
		
    // Configure the view for the selected state
		
		UIColor *backgroundColor = kAppColor;
		UIColor *textColor = kCellHighlightedColor;
		NSTimeInterval interval = 1;
		
		if (!highlighted) {
				backgroundColor = [UIColor whiteColor];
				textColor = kCellColor;
		}
		
		[UIView animateWithDuration:interval animations:^{
				[self setBackgroundColor:backgroundColor];
				[[self textLabel] setTextColor:textColor];
				
		}];
}

@end
