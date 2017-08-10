//
//  StylerTabbar.m
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "LeveyTabBarController.h"
#import "StylerTabbar.h"
#import "WorkListController.h"
#import "ContentNavController.h"
#import "UserCommonController.h"
#import "UserCenterController.h"
#import "ChatViewController.h"
#import "RewardActivityProcessor.h"
#import "OrganizationSpecialOfferListViewController.h"
#import "OrganizationFilter.h"
#import "WeiXinPayTestViewController.h"

@implementation StylerTabbar

-(id)init{
    self = [super init];
    if (self) {
        WorkListController *wlc = [[WorkListController alloc] initWithRequestURL:@"/works?orderType=9" title:@"全部发型" type:common_work];
        wlc.type = common_work;
        UINavigationController *hairStyleNC = [[UINavigationController alloc] initWithRootViewController:wlc];
        hairStyleNC.delegate = self;
        [hairStyleNC.navigationBar setHidden:YES];
        
        // TODO : 调试用.
        UINavigationController *classNC = [[UINavigationController alloc] initWithRootViewController:[[ContentNavController alloc] init]];
        classNC.delegate = self;
        [classNC.navigationBar setHidden:YES];
        
        //=========================================
        // TODO : 发版本时，这个可去掉了
//        UINavigationController *classNC = [[UINavigationController alloc] initWithRootViewController:[[WeiXinPayTestViewController alloc] init]];
//        classNC.delegate = self;
//        [classNC.navigationBar setHidden:YES];
        //=========================================
        
        UINavigationController *commonNC = [[UINavigationController alloc] initWithRootViewController:[[UserCommonController alloc] init]];
        commonNC.delegate = self;
        [commonNC.navigationBar setHidden:YES];
        
        
        UINavigationController * userNC = [[UINavigationController alloc] initWithRootViewController:[[UserCenterController alloc] init]];
        userNC.delegate = self;
        [userNC.navigationBar setHidden:YES];
        
        NSArray *imgArr = [NSArray arrayWithObjects:
                           [NSArray arrayWithObjects:[UIImage imageNamed:@"tabbar_house_default"],[UIImage imageNamed:@"tabbar_house_select"], nil],
                           [NSArray arrayWithObjects:[UIImage imageNamed:@"tabbar_look_default"],[UIImage imageNamed:@"tabbar_look_selected"], nil],
                           [NSArray arrayWithObjects:[UIImage imageNamed:@"tabbar_common_default"],[UIImage imageNamed:@"tabbar_common_selected"], nil],
                           [NSArray arrayWithObjects:[UIImage imageNamed:@"tabbar_me_default"],[UIImage imageNamed:@"tabbar_me_selected"], nil],
                           nil];
        NSArray *titleArray =[NSArray arrayWithObjects:@"优惠",@"发型", @"常用", @"我", nil];
        
        self.tabbarController = [[LeveyTabBarController alloc] initWithViewControllers:[NSArray arrayWithObjects:classNC,hairStyleNC,commonNC,userNC, nil] imageArray:imgArr andTitles:titleArray];
        
        self.tabbarController.delegate = self;
        [self.tabbarController setSelectedIndex:0];
    }
    return self;
}

# pragma mark - Tabbar相关
-(void)tabBarControllerChangedItoIndex:(int)toIndex
{
    [self.tabbarController hidesTabBar:NO animated:YES];
}

-(void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UIViewController *uc = [((UINavigationController *)viewController).viewControllers objectAtIndex:0];
    //对UserCenterController进行判断
    if ([uc isKindOfClass:[UserCenterController class]]) {
        AppStatus * as =[AppStatus sharedInstance];
        if (as.logined) {
            [((UINavigationController *)viewController) popToRootViewControllerAnimated:NO];
        }
    }else if([uc isKindOfClass:[ContentNavController class]]){
        ContentNavController *cnc = (ContentNavController*)uc;
        [cnc performSelector:@selector(initWebView) withObject:cnc afterDelay:1];
    }
    
    [((UINavigationController *)viewController) popToRootViewControllerAnimated:NO];
}



#pragma mark --- navigationController协议
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:NSClassFromString(@"ContentNavController")]
        ||[viewController isKindOfClass:NSClassFromString(@"UserCommonController")]
        ||[viewController isKindOfClass:NSClassFromString(@"UserCenterController")]) {
        [self.tabbarController hidesTabBar:NO animated:YES];
    }else if([viewController isKindOfClass:[WorkListController class]]){
        WorkListController *wlc = (WorkListController *)viewController;
        if (wlc.type == common_work ) {
            [self.tabbarController hidesTabBar:NO animated:YES];
        }else if (wlc.type == my_fav_work || wlc.type == tag_name_work){
            [self.tabbarController hidesTabBar:YES animated:YES];
        }
    }else if ([viewController isKindOfClass:NSClassFromString(@"UserLoginController")]&&[[viewController.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[UserCenterController class]]) {
        [self.tabbarController hidesTabBar:NO animated:YES];
    }else
    {
        [self.tabbarController hidesTabBar:YES animated:YES];
    }
    
    //记录页面访问日志
    if (self.currentPageName != nil) {
        [MobClick endLogPageView:self.currentPageName];
//                NSLog(@">>>>>> 转出:%@", self.currentPageName);
    }
    self.currentPageName = [viewController getPageName];
    [MobClick beginLogPageView:self.currentPageName];
//    NSLog(@">>>>>> 转入:%@", self.currentPageName);
}

-(void) goChatView{
    if (self.tabbarController.selectedIndex == tabbar_item_index_contact) {
        UINavigationController *currentNC = (UINavigationController *)self.tabbarController.selectedViewController;
        for (UIViewController *vc in currentNC.viewControllers) {
            if ([vc isKindOfClass:[ChatViewController class]]) {
                [currentNC popToViewController:vc animated:NO];
                return ;
            }
        }
    }else{
        [self.tabbarController setSelectedIndex:tabbar_item_index_contact];
    }
    
    UINavigationController *currentNC = (UINavigationController *)self.tabbarController.selectedViewController;
    [currentNC popToRootViewControllerAnimated:NO];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:@"support"];
    chatVC.title = page_name_feedback;
    [(UINavigationController *)self.tabbarController.selectedViewController pushViewController:chatVC animated:YES];
}

-(UINavigationController *) getSelectedViewController{
    return (UINavigationController *)self.tabbarController.selectedViewController;
}

-(UINavigationController *) getViewController:(int)index{
    return  (UINavigationController *)self.tabbarController.viewControllers[index];
}

-(int) getSelectedIndex{
    return self.tabbarController.selectedIndex;
}

-(void) setSelectedIndex:(int)selectedIndex{
    [self.tabbarController setSelectedIndex:selectedIndex];
}

-(NSString *) getCurrentPageName{
    return self.currentPageName;
}

@end
