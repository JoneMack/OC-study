//
//  AppDelegate.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/3.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "AppDelegate.h"
#import "UMengProcessor.h"
#import "WXApi.h"
#import "WXPayProcessor.h"
#import "UserStore.h"
#import "ShareSDKProcessor.h"
#import "AppClientStore.h"
#import "PushRecord.h"
#import "PushProcessor.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //初始化状态栏
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    //初始化窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
//    self.loginViewController = [[LoginViewController alloc] init];
//    self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
//    [self.rootNavigationController setNavigationBarHidden:YES];
//    [self.window setRootViewController:self.rootNavigationController];
    
    //初始化App的底栏
    self.tabbar = [IcxTabbar new];
    self.window.rootViewController = self.tabbar.tabbarController;

    // 初始化友盟用于统计、自动更新提示、在线参数
    [UMengProcessor initUMengSDK];
    
    // 初始化微信开放平台
    [WXApi registerApp:[AppStatus sharedInstance].wxAppId];
    
    // 初始化share sdk
    [ShareSDKProcessor initShareSDK];
    
    /**
     * 注册接收PUSH
     *
     *  @param respondsToSelector:@selectorisRegisteredForRemoteNotifications
     *
     *  @return ios8 之后以下方法有所调整，这里是判断版本，从而使用相应的注册远程通知方法。
     */
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    // 监听网络变化
    [self checkReachability];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"handleOPenUrl");
    WXPayProcessor *wxPayprocessor = [WXPayProcessor sharedInstance];
    return [WXApi handleOpenURL:url delegate:wxPayprocessor];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"open url");
    if (sourceApplication != nil && ![sourceApplication isEqualToString:@""]) {
        WXPayProcessor *wxPayprocessor = [WXPayProcessor sharedInstance];
        return [WXApi handleOpenURL:url delegate:wxPayprocessor];
    }
    return YES;
}

#pragma mark -notification相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *aDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"获取并设置deviceToken: %@", aDeviceToken);
    NSLog(@"[[AppStatus sharedInstance].deviceToken:%@" , [AppStatus sharedInstance].deviceToken);
//    if (![[AppStatus sharedInstance].deviceToken isEqualToString:aDeviceToken]) {
        [AppClientStore updateAppClient];
//    }
    
    [AppStatus sharedInstance].deviceToken = aDeviceToken;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"获取deviceToken失败：%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息 ： %@", userInfo);
    if(![[AppStatus sharedInstance] logined]){
        return;
    }

    if([userInfo objectForKey:@"notificationType"] != nil){
        PushRecord *pushRecord = [[PushRecord alloc] initFromDict:userInfo];
        PushProcessor *pushProcessor = [PushProcessor sharedInstance];
//        if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){  // 如果是不活跃状态
            NSLog(@">>>>>>>>>>>>>>>>>>>>>收到消息准备跳转");
//            pushProcessor.hasReceivePush = YES;
////            [pushProcessor processPush:pushRecord comingFrom:push_from_jump_from_sys_notification naviagtionController:self.navigationController];
////            [self.navigationController popToRootViewControllerAnimated:NO];
//        }else{
            [pushProcessor processPush:pushRecord
                            comingFrom:push_from_receive_from_active_app
                  naviagtionController:[self.loginViewController.icxTabbar getSelectedViewController]];
//        }
    }
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"收到本地推送：%@", notification);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [AppStatus saveAppStatus];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([[AppStatus sharedInstance] logined]) {
        [[UserStore sharedStore] myUserInfo:^(User *user, NSError *err) {
        }];
        [AppClientStore updateAppClient];
    }
    [AppStatus saveAppStatus];
}

#pragma mark 监听网络变化
-(void) checkReachability
{
    //注册联网状态的通知监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    self.reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self.reachability startNotifier];
}

-(void)reachabilityChanged:(NSNotification *) note{
    NSLog(@">>>>>>> reachability changed");
    Reachability *curReachability = [note object];
    NetworkStatus status = [curReachability currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"网络不通");
        [SVProgressHUD showErrorWithStatus:@"网络不通" duration:10];
    }else if(status == ReachableViaWiFi){
        NSLog(@"WIFI联网");
    }else if(status == ReachableViaWWAN){
        NSLog(@"3G/GPRS联网");
    }
    
    if (self.networkStatus == nil) {
        self.networkStatus = &(status);
        return;
    }
    
    if(status != NotReachable){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_network_not_reachable
                                                            object:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
