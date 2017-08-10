//
//  SmartLockCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SmartLockCell.h"

@implementation SmartLockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.line1View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self.line2View setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self.name setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray4]];
    [self.status setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray4]];
    
    
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];

}

@end
