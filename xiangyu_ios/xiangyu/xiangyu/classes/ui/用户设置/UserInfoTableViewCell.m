//
//  UserInfoTableViewCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.title setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.topLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.bottomLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
