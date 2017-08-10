//
//  ExpertSmallCardCell.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/26.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertSmallCardCell.h"

@implementation ExpertSmallCardCell

- (void)awakeFromNib {
    // Initialization code

    [self renderBaseUI];
    
}

/**
 *  初始化基础UI
 */
- (void) renderBaseUI
{
    self.expertAvatar.frame = CGRectMake( 10, 0, 60, 60);
    self.expertAvatar.layer.masksToBounds = YES;
    self.expertAvatar.layer.cornerRadius = 30;
    self.expertAvatar.layer.borderWidth = 2;
    self.expertAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:10 weight:5];
    self.statusLabel.frame = CGRectMake(0, 41, self.expertAvatar.frame.size.width,
                                        18);
    
    [self.expertAvatar addSubview:self.statusLabel];
}

/**
 * 渲染UI数据
 */
- (void)renderWithExpert:(Expert *)expert
{
    self.expert = expert;
    
    //头像
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:expert.avatarUrl]];
    UIImage *avatar = [[UIImage alloc] initWithData:data];
    [self.expertAvatar setImage:avatar];
    
    //专家名
    self.expertName.text = expert.name;
    
    self.statusLabel.hidden = NO;
    if ([self.expert.relationStatus isEqualToString:@"Follow"]) {
        [self.statusLabel setBackgroundColor:[ColorUtils colorWithHexString:@"ffffff" alpha:0.6] ];
        self.statusLabel.text = @"关注";
        self.statusLabel.textColor = [UIColor blackColor];
    }else if ([self.expert.relationStatus isEqualToString:@"Subscribe"]) {
        [self.statusLabel setBackgroundColor:[ColorUtils colorWithHexString:orange_red_line_color alpha:0.8] ];
        self.expertAvatar.layer.borderColor=[[ColorUtils colorWithHexString:orange_red_line_color] CGColor];
        self.statusLabel.text = @"订阅";
        self.statusLabel.textColor = [UIColor whiteColor];
    }
}


- (void)renderAddExpert
{
    self.expertAvatar.image = [UIImage imageNamed:@"add_pro"];
    self.expertName.text = @"添加关注";
    self.statusLabel.hidden = YES;
}


@end
