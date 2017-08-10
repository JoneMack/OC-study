//
//  UserCenterHeaderView.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterHeaderView : UIView <UIAlertViewDelegate>

@property (nonatomic , strong) User *user;
@property (nonatomic , strong) UINavigationController *navigationController;

@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;

@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;


-(id) initWithFrame:(CGRect)frame navigationController:(UINavigationController *)navigationController;

- (IBAction)logout:(id)sender;

@end
