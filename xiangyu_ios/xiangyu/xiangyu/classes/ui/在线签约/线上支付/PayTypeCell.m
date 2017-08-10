//
//  PayTypeCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/21.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "PayTypeCell.h"

@implementation PayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.line1View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.line2View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
