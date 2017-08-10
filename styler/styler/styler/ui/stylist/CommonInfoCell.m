//
//  CommonInfoCell.m
//  styler
//
//  Created by System Administrator on 14-1-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "CommonInfoCell.h"

@implementation CommonInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle]loadNibNamed:@"CommonInfoCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    return self;
}

-(void) renderContent:(NSString *)title content:(NSString *)content contentLine:(int)contentLine{
    [self.title setText:title];
    [self.title setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.title setFont:[UIFont systemFontOfSize:default_font_size]];
    [self.title setBackgroundColor:[UIColor clearColor]];
    
    [self.content setText:content];
    [self.content setNumberOfLines:contentLine];
    [self.content setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
    [self.content setFont:[UIFont systemFontOfSize:default_font_size]];
    [self.title setBackgroundColor:[UIColor clearColor]];
    
    self.spliteLine.frame = CGRectMake(0, self.frame.size.height - splite_line_height, screen_width, splite_line_height);
    self.spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
