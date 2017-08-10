//
//  MessageLsiCell.m
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ChatListCell.h"

@implementation ChatListCell

- (void)awakeFromNib {
    // Initialization code
    self.unreadBtn.hidden = YES;
    self.unreadBtn.layer.cornerRadius = 10.0;
    self.avtarImageView.layer.cornerRadius = self.avtarImageView.frame.size.width/2;
    self.avtarImageView.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];

}
-(void)setName:(NSString *)name{
    
    _name = name;
    _nameLabel.text = name;
}

- (void)setDetailMsg:(NSString *)detailMsg
{
    _detailMsg = detailMsg;
    _detailLabel.text = detailMsg;
}

- (void)setTime:(NSString *)time
{
    _time = time;
    _dateLabel.text = time;
}

- (void)setUnreadCount:(NSInteger)unreadCount
{
    _unreadCount = unreadCount;
     _unreadBtn.hidden = !unreadCount;
    
     NSString *text = nil;
    if (unreadCount) {
       text = [NSString stringWithFormat:@"%zi", _unreadCount];
    }
    
    [_unreadBtn setTitle:text forState:UIControlStateNormal];
}

@end
