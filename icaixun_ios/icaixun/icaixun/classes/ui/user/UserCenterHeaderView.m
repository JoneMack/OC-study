//
//  UserCenterHeaderView.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define USER_CENTER_HEADER_HEIGHT 140
#define USER_AVATAR_WIDTH 90
#define USER_NAME_MARGIN_WITH_AVATAR 15
#define USER_NAME_HEIGHT 10

#import "UserCenterHeaderView.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "UserStore.h"

@implementation UserCenterHeaderView

-(id) initWithFrame:(CGRect)frame navigationController:(UINavigationController *)navigationController
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"UserCenterHeaderView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        
        // 渲染 header
        self.frame = frame;
        self.userAvatar.layer.masksToBounds = YES;
        self.userAvatar.layer.cornerRadius = 47.5;
        self.userAvatar.layer.borderWidth = 2;
        self.userAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        [self renderUserInfo];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renderUserInfo) name:notification_name_update_user_info object:nil];
        
    }
    return self;
}

- (IBAction)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认退出登录？" message:@"" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"退出", nil];
    [alert show];
}

-(void) renderUserInfo
{
    self.user = [AppStatus sharedInstance].user;
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:self.user.avatarUrl]
                       placeholderImage:[UIImage imageNamed:@"icon_user_gray"]];
    // 渲染用户名
    [self.userName setText:self.user.name];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // 退出
        [[UserStore sharedStore] removeSession:^(NSError *err) {
            
            //返回tabbar第一个view
//            [((AppDelegate *)[UIApplication sharedApplication].delegate).rootNavigationController popToRootViewControllerAnimated:YES];
//            [ setSelectedIndex:1];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar = [IcxTabbar new];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar.tabbarController;
            AppStatus *appStatus = [AppStatus sharedInstance];
            [appStatus initBaseData];
            [AppStatus saveAppStatus];
        }];
        
        
    }
}

@end
