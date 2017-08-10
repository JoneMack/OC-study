//
//  AppDelegate.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/3.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IcxTabbar.h"
#import "LoginViewController.h"
#import "IcxTabbar.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate , UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *rootController;
@property (strong, nonatomic) UINavigationController *rootNavigationController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) Reachability *reachability;
@property (assign, nonatomic) NetworkStatus *networkStatus;
@property (strong, nonatomic)IcxTabbar *tabbar;


@end

