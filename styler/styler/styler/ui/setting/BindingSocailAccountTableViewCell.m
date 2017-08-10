//
//  BindingSocailAccountTableViewCell.m
//  styler
//
//  Created by aypc on 13-11-25.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "BindingSocailAccountTableViewCell.h"

@implementation BindingSocailAccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"BindingSocialAccountTableViewCell" owner:self options:nil]objectAtIndex:0];
        
        self.isBingding.textColor = [ColorUtils colorWithHexString:gray_text_color];
        self.isBingding.font = [UIFont systemFontOfSize:default_font_size];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
