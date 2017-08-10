//
//  AppleAssistantTableViewCell.m
//  DrAssistant
//
//  Created by 刘湘 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AppleAssistantTableViewCell.h"
#import "BaseEntity.h"

@implementation AppleAssistantTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _baseBtn.layer.cornerRadius=4.0;
    _baseBtn.layer.masksToBounds=YES;
    self.imageAndAssTypView.layer.cornerRadius = 10.0;
    self.imageAndAssTypView.layer.masksToBounds = YES;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
