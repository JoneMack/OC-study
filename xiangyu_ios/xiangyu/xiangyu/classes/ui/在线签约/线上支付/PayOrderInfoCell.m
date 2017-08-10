//
//  PayOrderInfoCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/21.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "PayOrderInfoCell.h"

@implementation PayOrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.infoLabel setFont:[UIFont systemFontOfSize:14]];
    [self.infoLabel setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    
    [self.lineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
