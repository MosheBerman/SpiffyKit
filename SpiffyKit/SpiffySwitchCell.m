//
//  SpiffySwitchCell.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "SpiffySwitchCell.h"

#import "Constants.h"

#define kLabelLeftOffset 20.0f

@implementation SpiffySwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
				_switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
				_toggle = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 77, 27)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
		
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
		
}

- (void)layoutSubviews
{
		[super layoutSubviews];
		
		CGRect labelBounds = [[self switchLabel] bounds];
		labelBounds.size = CGSizeMake(self.frame.size.width-self.toggle.frame.size.width-kLabelLeftOffset, 27);
		labelBounds.origin.y = self.frame.size.height/2 - labelBounds.size.height/2;
		labelBounds.origin.x = kLabelLeftOffset;
		[[self switchLabel] setFrame:labelBounds];
		
		//	Set the label font
		[[self switchLabel] setFont:[self labelFont]];
		
		//	Clear the label background
		[[self switchLabel] setBackgroundColor:[UIColor clearColor]];
		
		[self addSubview:[self switchLabel]];
		
		//	Configure the toggle
		CGRect toggleBounds = [[self toggle] bounds];
		toggleBounds.origin = CGPointMake(labelBounds.size.width, labelBounds.origin.y);
		[[self toggle] setFrame:toggleBounds];
		
		[self addSubview:[self toggle]];
		
		[self setBackgroundColor:[UIColor whiteColor]];
		[[self toggle] setOnTintColor:kAppColor];
		
}

- (UIFont *)labelFont
{
		static UIFont *font = nil;
		
		if (!font)
		{
				font = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0];
		}
		
		return font;
}

@end
