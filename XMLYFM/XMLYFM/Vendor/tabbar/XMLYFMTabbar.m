//
//  XMLYFMTabbar.m
//  XMLYFM
//
//  Created by xubojoy on 2017/8/22.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "XMLYFMTabbar.h"
#import "HomeController.h"
#import "MyListenController.h"
#import "DiscoveryController.h"
#import "UserCenterController.h"
@implementation XMLYFMTabbar
-(id)init{
    self = [super init];
    if (self) {
        UIViewController *homeViewController = [[HomeController alloc] init];
        UINavigationController *homeNavigationController = [[UINavigationController alloc]
                                                             initWithRootViewController:homeViewController];
        homeNavigationController.delegate = self;
        homeNavigationController.title = @"首页";
//        [homeNavigationController.navigationBar setHidden:YES];
        
        
        UIViewController *myListenViewController = [[MyListenController alloc] init];
        UINavigationController *myListenNavigationController = [[UINavigationController alloc]
                                                             initWithRootViewController:myListenViewController];
        myListenNavigationController.delegate = self;
        myListenNavigationController.title = @"我听";
//        [myListenNavigationController.navigationBar setHidden:YES];
        
        UIViewController *discoverController = [[DiscoveryController alloc] init];
        UINavigationController *discoverNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:discoverController];
        discoverNavigationController.delegate = self;
        discoverNavigationController.title = @"发现";
//        [discoverNavigationController.navigationBar setHidden:YES];
        
        
        UIViewController *userViewController = [[UserCenterController alloc] init];
        UINavigationController *userNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:userViewController];
        userNavigationController.delegate = self;
        userNavigationController.title = @"未登录";
//        [userNavigationController.navigationBar setHidden:YES];
        
        self.tabBarController = [[RDVTabBarController alloc] init];
        [self.tabBarController setViewControllers:@[homeNavigationController,
                                                    myListenNavigationController,discoverNavigationController,userNavigationController]];
        self.tabBarController.delegate = self;
        //设置各个item的图像
        [self customizeTabBarForController:self.tabBarController];
        
    }
    return self;
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    NSArray *tabBarItemImages = @[@"hole_in_one_icon",@"tabbar_discover_icon",@"tabbar_game_icon",@"tabbar_user_icon"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
//        item.backgroundColor = [UIColor purpleColor];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    return YES;
}

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //记录页面访问日志
    //    if (self.currentPageName != nil) {
    //        NSLog(@">>>>>> 转出:%@", self.currentPageName);
    //    }
    //    self.currentPageName = [viewController getPageName];
    //    NSLog(@">>>>>> 转入:%@", self.currentPageName);
    
    [((UINavigationController *)viewController) popToRootViewControllerAnimated:NO];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:NSClassFromString(@"HomeController")]
        ||[viewController isKindOfClass:NSClassFromString(@"MyListenController")]
        ||[viewController isKindOfClass:NSClassFromString(@"DiscoveryController")] || [viewController isKindOfClass:NSClassFromString(@"UserCenterController")]) {
        [self.tabBarController setTabBarHidden:NO animated:YES];
    }
    else{
        [self.tabBarController setTabBarHidden:YES animated:YES];
    }
    
    //记录页面访问日志
    if (self.currentPageName != nil) {
        NSLog(@">>>>>> 转出:%@", self.currentPageName);
        
    }
//    self.currentPageName = [viewController getPageName];
    NSLog(@">>>>>> 转入:%@", self.currentPageName);
    
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//}

//# pragma mark - Tabbar相关
-(void)tabBarControllerChangedItoIndex:(int)toIndex
{
    [self.tabBarController setTabBarHidden:NO animated:YES];
}

-(UINavigationController *) getSelectedViewController{
    return (UINavigationController *)self.tabBarController.selectedViewController;
}

-(UINavigationController *) getViewController:(int)index{
    return  (UINavigationController *)self.tabBarController.viewControllers[index];
}

-(NSInteger) getSelectedIndex{
    return self.tabBarController.selectedIndex;
}

-(void) setSelectedIndex:(int)selectedIndex{
    [self.tabBarController setSelectedIndex:selectedIndex];
}

-(NSString *) getCurrentPageName{
    return self.currentPageName;
}

@end
