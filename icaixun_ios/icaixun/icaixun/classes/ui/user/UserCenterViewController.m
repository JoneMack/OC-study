//
//  UserCenterViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/5.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define BIG_HEADER_HEIGHT 140

#import "UserCenterViewController.h"
#import "LoginViewController.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppStatus *appStatus = [AppStatus sharedInstance];
    if (![appStatus logined]) {
        LoginViewController *loginController = [[LoginViewController alloc] initWithAccountSessionFrom:account_session_from_user_center];
        [self.navigationController pushViewController:loginController animated:YES];
        return;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // header
    CGRect headerFrame = CGRectMake(0 , 0 , screen_width , BIG_HEADER_HEIGHT );
    if (CURRENT_SYSTEM_VERSION >= 7) {
        headerFrame.size.height =BIG_HEADER_HEIGHT + status_bar_height;
    }
    self.headerView = [[UserCenterHeaderView alloc] initWithFrame:headerFrame
                                            navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    
    // main
    CGRect mainFrame = CGRectMake(0,
                                  headerFrame.origin.y + headerFrame.size.height,
                                  screen_width,
                                  screen_height - headerFrame.size.height - tabbar_height);
    self.mainView = [[UserMainView alloc] initWithNavigationController:self.navigationController frame:mainFrame];
    [self.view addSubview:self.mainView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
