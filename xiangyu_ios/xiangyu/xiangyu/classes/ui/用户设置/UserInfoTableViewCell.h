//
//  UserInfoTableViewCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *title;


@property (strong, nonatomic) IBOutlet UITextField *content;

@property (strong, nonatomic) IBOutlet UIImageView *avatarView;

@property (strong, nonatomic) IBOutlet UIImageView *rightArrow;

@property (strong, nonatomic) IBOutlet UIView *topLine;

@property (strong, nonatomic) IBOutlet UIView *bottomLine;

@end
