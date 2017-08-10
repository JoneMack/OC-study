//
//  SubscribeHistoryCell.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/13.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "SubscribeHistoryCell.h"

@implementation SubscribeHistoryCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)initView
{
    self.frame = CGRectMake(0, 0, screen_width, 40);
    self.subscribeLabel.frame = CGRectMake(20, 7, 30, 16);
    self.expertName.frame = CGRectMake(self.subscribeLabel.rightX, 7, 130, 16);
    
    self.subscribeTime.frame = CGRectMake(20, self.subscribeLabel.bottomY, 80, 13);
    self.subscribeTime.textColor = [ColorUtils colorWithHexString:gray_line_color];
    
    self.pointLabel.frame = CGRectMake(self.frame.size.width - 75, 13, 28, 16);
    self.pointLabel.textColor = [ColorUtils colorWithHexString:gray_line_color];
    
    self.costPoint.frame = CGRectMake(self.frame.size.width - 150, 13, 70, 16);
    self.costPoint.textColor = [ColorUtils colorWithHexString:orange_text_low_color];
    
}

- (void)renderData:(SubscribeExpertLog *)subscribeExpertLog
{
    self.subscribeExpertLog = subscribeExpertLog;
    
    self.expertName.text = [NSString stringWithFormat:@"%@ (%@)" , self.subscribeExpertLog.expertName ,self.subscribeExpertLog.subscribePriceTypeTxt];
    
    self.subscribeTime.text = [DateUtils stringFromLongLongIntAndFormat:self.subscribeExpertLog.createTime
                                                             dateFormat:@"yyyy-MM-dd"];
    
    self.costPoint.text = [self.subscribeExpertLog getCostPoint];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
