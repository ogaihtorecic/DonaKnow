//
//  DetailTableCell.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 04/10/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "DetailTableCell.h"

@implementation DetailTableCell

@synthesize titleLabel = _titleLabel;
@synthesize actionButton = _actionButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
