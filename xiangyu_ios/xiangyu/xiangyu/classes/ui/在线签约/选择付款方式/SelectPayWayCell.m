//
//  SelectPayWayCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectPayWayCell.h"

@implementation SelectPayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.line1View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.line2View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self.payType setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.payType setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
}

@end
