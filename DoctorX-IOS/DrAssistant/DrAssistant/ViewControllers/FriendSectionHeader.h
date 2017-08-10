//
//  FriendSectionHeader.h
//  多级列表
//
//  Created by ap2 on 15/9/15.
//  Copyright (c) 2015年 ap2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendSectionHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;


@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UILabel *content;

+ (instancetype)friendSectionHeader;

@end
