//
//  SpiffyTableViewCell.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffyTableViewCell.h"

#import "Constants.h"

#import "AppDataManager.h"

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
		
		UIColor *backgroundColor = [AppDataManager appColor];
		UIColor *textColor = kCellHighlightedColor;
		
		if (!selected) {
				backgroundColor = [UIColor whiteColor];
				textColor = [UIColor blackColor];
		}
				
		[UIView animateWithDuration:0.3 animations:^{
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
		
		UIColor *backgroundColor = [AppDataManager appColor];
		UIColor *textColor = kCellHighlightedColor;
		
		if (!highlighted) {
				backgroundColor = [UIColor whiteColor];
				textColor = [UIColor blackColor];
		}
		
		[UIView animateWithDuration:0.3 animations:^{
				[self setBackgroundColor:backgroundColor];
				[[self textLabel] setTextColor:textColor];
				
		}];
}

@end
