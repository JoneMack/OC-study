//
//  CouponCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/11.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.title setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    
    [self.detail setTextColor:[ColorUtils colorWithHexString:text_color_light_gray]];
    
    [self.validDate setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [self.yuan setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    
    [self.price setTextColor:[ColorUtils colorWithHexString:text_color_purple]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
