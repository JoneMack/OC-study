//
//  MessageCenterCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/3.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MessageCenterCell.h"

@implementation MessageCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
