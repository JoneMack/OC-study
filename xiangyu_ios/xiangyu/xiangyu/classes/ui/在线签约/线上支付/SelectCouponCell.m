//
//  SelectCouponCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/21.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectCouponCell.h"

@implementation SelectCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.line1View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.line2View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self.couponBtn setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
