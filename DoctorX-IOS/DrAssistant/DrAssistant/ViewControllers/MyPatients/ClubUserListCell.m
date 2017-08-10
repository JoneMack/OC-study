//
//  ClubUserListCell.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/24.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ClubUserListCell.h"

@implementation ClubUserListCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
