//
//  ConfirmRentDateCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "ConfirmRentDateCell.h"

@implementation ConfirmRentDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.line1View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.line2View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.dateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
