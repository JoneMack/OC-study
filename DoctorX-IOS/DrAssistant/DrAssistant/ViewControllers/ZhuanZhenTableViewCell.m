//
//  ZhuanZhenTableViewCell.m
//  DrAssistant
//
//  Created by Seiko on 15/10/12.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ZhuanZhenTableViewCell.h"

@implementation ZhuanZhenTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.headPic_image.layer.masksToBounds = YES;
    self.headPic_image.layer.cornerRadius = self.headPic_image.frame.size.width/2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
