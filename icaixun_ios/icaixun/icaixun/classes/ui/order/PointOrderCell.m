//
//  UserPointLogCell.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/13.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "PointOrderCell.h"

@implementation PointOrderCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)initView
{
    self.frame = CGRectMake(0, 0, screen_width, 40);
    
    self.payLabel.frame = CGRectMake(20, 7, 100, 16);
    
    self.payTime.frame = CGRectMake(20, self.payLabel.bottomY, 80, 13);
    self.payTime.textColor = [ColorUtils colorWithHexString:gray_line_color];
    
    self.pointLabel.frame = CGRectMake(self.frame.size.width - 75, 13, 28, 16);
    self.pointLabel.textColor = [ColorUtils colorWithHexString:gray_line_color];
    
    self.addPoint.frame = CGRectMake(self.frame.size.width - 150, 13, 70, 16);
    self.addPoint.textColor = [ColorUtils colorWithHexString:orange_text_low_color];
    //    [self.costPoint setBackgroundColor:[UIColor orangeColor]];
    
}

- (void)renderData:(PointOrder *)pointOrder
{
    self.pointOrder = pointOrder;
    self.payLabel.text = self.pointOrder.addPointTypeTxt;
    self.payTime.text = [DateUtils stringFromLongLongIntAndFormat:self.pointOrder.createTime
                                                             dateFormat:@"yyyy-MM-dd"];
    
    self.addPoint.text = [NSString stringWithFormat:@"%@" , [self.pointOrder getPoint]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
