//
//  CityDistrictCell.m
//  styler
//
//  Created by System Administrator on 14-2-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "CityDistrictCell.h"

@implementation CityDistrictCell

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

    if (self.selected) {
        [self.textLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }else{
        [self.textLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        [self.textLabel setFont:[UIFont systemFontOfSize:16]];
    }

}

@end
