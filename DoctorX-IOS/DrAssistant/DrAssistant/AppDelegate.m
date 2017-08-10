/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate.h"
//#import "LoginViewController.h"
//
#import "AppDelegate+EaseMob.h"
//#import "AppDelegate+UMeng.h"
//#import "AppDelegate+Parse.h"
#import "UMengSDKProcessor.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*消除警告*/
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }

    _connectionState = eEMConnectionConnected;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
//

//
//    // 环信UIdemo中有用到友盟统计crash，您的项目中不需要添加，可忽略此处。
//    //[self setupUMeng];
//
//    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
//
//    // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
//    //[self parseApplication:application didFinishLaunchingWithOptions:launchOptions];

    
    [self loginStateChange:nil];
//    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    if (_mainController) {
//        [_mainController jumpToChatList];
//    }
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
////    if (_mainController) {
////        [_mainController didReceiveLocalNotification:notification];
////    }
//}

#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    UINavigationController *nav = nil;
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
//        //加载申请通知的数据
//        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
//        if (_mainController == nil) {
//            _mainController = [[MainViewController alloc] init];
//            [_mainController networkChanged:_connectionState];
//            nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
//        }else{
//            nav  = _mainController.navigationController;
//        }
//        
//        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
//        [self initParse];
    }else{//登陆失败加载登陆页面控制器
//        _mainController = nil;
//        LoginViewController *loginController = [[LoginViewController alloc] init];
//        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
//        loginController.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
//        
//        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
//        [self clearParse];
    }
    
}

@end
