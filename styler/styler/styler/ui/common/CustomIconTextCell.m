//
//  CustomIconTextCell.m
//  styler
//
//  Created by wangwanggy820 on 14-3-6.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "CustomIconTextCell.h"
#import "CustomIconTextCell.h"
#import "UserSettingController.h"
#import "UserCenterController.h"


@implementation CustomIconTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.rightArrowImgView.frame = CGRectMake(290, (general_cell_height - 25)/2, 25, 25);
    }
    return self;
}


-(void) renderUI:(UIImage *)iconImg contentTxt:(NSString *)contentTxt{
    //渲染icon
    float y = (self.frame.size.height-iconImg.size.height)/2;
    CGRect iconFrame = CGRectMake(general_margin, y, iconImg.size.width, iconImg.size.height);
    self.icon.frame = iconFrame;
    self.icon.image = iconImg;
    
    //渲染文本
    self.content.text = contentTxt;
    self.content.numberOfLines = 0;
    self.content.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.content.font = [UIFont systemFontOfSize:default_font_size];
    CGRect contentFrame = self.content.frame;
    contentFrame.size.height = self.frame.size.height;
    contentFrame.origin.x = self.icon.frame.origin.x + self.icon.frame.size.width+10;
    self.content.frame = contentFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
