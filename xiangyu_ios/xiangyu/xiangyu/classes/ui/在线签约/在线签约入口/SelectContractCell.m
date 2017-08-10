//
//  SelectContractCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectContractCell.h"

@implementation SelectContractCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];

    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    
    [self.lijiqianyue setTextColor:[ColorUtils colorWithHexString:text_color_purple]];
    [self.lineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.promptInfo setTextColor:[ColorUtils colorWithHexString:text_color_light_gray]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
