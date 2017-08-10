//
//  FindHouseMoreConditionTableViewCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "FindHouseMoreConditionTableViewCell.h"

@implementation FindHouseMoreConditionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorLine = [[UIView alloc] init];
    [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color ]];
    self.separatorLine.frame = CGRectMake(0, 0, screen_width, splite_line_height);
    [self addSubview:self.separatorLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
