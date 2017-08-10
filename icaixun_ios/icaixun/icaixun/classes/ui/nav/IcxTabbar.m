//
//  IcxTabbar.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/31.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "IcxTabbar.h"
#import "IndexController.h"
#import "UserCenterViewController.h"
#import "ArticleListViewController.h"
#import "LoginViewController.h"
@implementation IcxTabbar

-(instancetype) init
{
    self = [super init];
    if (self) {
        IndexController *indexController = [[IndexController alloc] init];
        UINavigationController *indexNc = [[UINavigationController alloc] initWithRootViewController:indexController];
        indexNc.delegate = self;
        [indexNc.navigationBar setHidden:YES];
        

        ArticleListViewController *articleListController = [[ArticleListViewController alloc] init];
        
        UINavigationController *articleListNc = [[UINavigationController alloc] initWithRootViewController:articleListController];
        articleListNc.delegate = self;
        [articleListNc.navigationBar setHidden:YES];

        UserCenterViewController *userCenterController = [[UserCenterViewController alloc] init];
        UINavigationController *userCenterNc = [[UINavigationController alloc] initWithRootViewController:userCenterController];
        userCenterNc.delegate = self;
        [userCenterNc.navigationBar setHidden:YES];
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNc = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginNc.delegate = self;
        [loginNc.navigationBar setHidden:YES];
        

        NSArray *imgArr = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_index_gray"],[UIImage imageNamed:@"icon_index_red"], nil],
                            [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_foud_gray"],[UIImage imageNamed:@"icon_foud_red"], nil],
                            [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_user_gray"],[UIImage imageNamed:@"icon_user_red"], nil],
                           nil];
        if (![AppStatus sharedInstance].logined) {
            self.tabbarController = [[LeveyTabBarController alloc] initWithViewControllers:[NSArray arrayWithObjects:loginNc , articleListNc , loginNc, nil] imageArray:imgArr andTitles:nil];
        }else{
            self.tabbarController = [[LeveyTabBarController alloc] initWithViewControllers:[NSArray arrayWithObjects:indexNc , articleListNc , userCenterNc, nil] imageArray:imgArr andTitles:nil];
        }
        self.tabbarController.delegate = self;
        [self.tabbarController setSelectedIndex:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabbarController:) name:notification_name_change_tabbar_controller object:nil];
    }
    return self;
}

# pragma mark - Tabbar相关
-(void)tabBarControllerChangedItoIndex:(int)toIndex
{
    [self.tabbarController hidesTabBar:NO animated:YES];
}

#pragma mark --- navigationController协议
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:NSClassFromString(@"IndexController")] ||
        [viewController isKindOfClass:NSClassFromString(@"ArticleListViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"UserCenterViewController")]) {
        NSLog(@"主菜单");
        [self.tabbarController hidesTabBar:NO animated:YES];
    }
//    else if (([viewController isKindOfClass:[IndexController class]] || [viewController isKindOfClass:NSClassFromString(@"UserCenterViewController")]) && ![AppStatus sharedInstance].logined){
//        [self.tabbarController hidesTabBar:YES animated:YES];
//       LoginViewController *loginViewController = [[LoginViewController alloc] init];
//        [self.tabbarController.navigationController pushViewController:loginViewController animated:YES];
//
//    }
    else if([viewController isKindOfClass:NSClassFromString(@"HasNotAttentionExpertViewController")]){
        NSLog(@"进入 HasNotAttentionExpertViewController");
        [self.tabbarController hidesTabBar:NO animated:YES];
    }else if ([viewController isKindOfClass:[LoginViewController class]]){
        [self.tabbarController hidesTabBar:NO animated:YES];
    }
    else{
        [self.tabbarController hidesTabBar:YES animated:YES];
    }
}


-(void) setSelectedIndex:(int)selectedIndex{
    [self.tabbarController setSelectedIndex:selectedIndex];
}


-(UINavigationController *) getSelectedViewController{
    return (UINavigationController *)self.tabbarController.selectedViewController;
}


-(void) changeTabbarController:(NSNotification *)notification
{
    int selectedIndex = [notification.object intValue];
    [self setSelectedIndex:selectedIndex];
}


@end
