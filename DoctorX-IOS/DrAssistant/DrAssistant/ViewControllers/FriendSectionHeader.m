//
//  FriendSectionHeader.m
//  多级列表
//
//  Created by ap2 on 15/9/15.
//  Copyright (c) 2015年 ap2. All rights reserved.
//

#import "FriendSectionHeader.h"

@implementation FriendSectionHeader

+ (instancetype)friendSectionHeader
{
    FriendSectionHeader *header =  [[[NSBundle mainBundle] loadNibNamed:@"FriendSectionHeader" owner:nil options:nil] lastObject];
    header.contentView.backgroundColor = [UIColor whiteColor];
    return header;
}

- (void)awakeFromNib
{
    self.avatarBtn.userInteractionEnabled = NO;
    [self.avatarBtn setImage: [UIImage imageNamed:@"group_arrow_Up"] forState:UIControlStateSelected];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
