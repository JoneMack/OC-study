//
//  LeftViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end


@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:[ColorUtils colorWithHexString:bg_deep_gray_color]];
    self.drawerController = [(AppDelegate*)[UIApplication sharedApplication].delegate drawerController];
    self.bodyView = [[LeftBodyView alloc] initWithNavigationController:self.navigationController];
    self.bodyView.frame = CGRectMake(0, 0, 280, screen_height);
    [self.view addSubview:self.bodyView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:notification_name_user_login object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:notification_name_log_out object:nil];
    
}


- (void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_show_left_menu_event object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_close_left_menu_event object:nil];
}

-(void) userLogin
{
    [self.bodyView renderUserInfo];
}

-(void) userLogout
{
    [self.bodyView renderUserInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
