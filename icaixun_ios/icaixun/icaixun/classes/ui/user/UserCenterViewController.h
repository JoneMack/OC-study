//
//  UserCenterViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/5.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterHeaderView.h"
#import "UserMainView.h"
#import "User.h"

@interface UserCenterViewController : UIViewController


@property (nonatomic , strong) UserCenterHeaderView *headerView;
@property (nonatomic , strong) UserMainView *mainView;
@property (nonatomic , strong) User *user;


@end
