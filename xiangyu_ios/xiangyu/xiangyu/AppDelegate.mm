//
//  AppDelegate.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "AppDelegate.h"
#import "MMExampleCenterTableViewController.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMNavigationController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "LeftViewController.h"
#import "BaiDuMapProcessor.h"
#import "URLDispatcher.h"
#import "WXApi.h"
#import "WeiXinPayProcessor.h"
#import <QuartzCore/QuartzCore.h>
BMKMapManager* _mapManager;
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    LeftViewController * leftSideDrawerViewController = [[LeftViewController alloc] init];
    UINavigationController * leftSideNavController = [[MMNavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    
    Main2ViewController * centerViewController = [Main2ViewController new];
    
    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:centerViewController];
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideNavController];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:280];
    [self bindLeftMenuTouchSlideEvent];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_show_left_menu object:nil];
    
    // 关闭left menu
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_go_in_user_login_view object:nil];
    // 进入我的收藏约看
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_go_in_user_collection_look_view object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_go_in_my_contract_view object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_go_in_smart_lock_view object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_go_in_message_center_view object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_go_in_user_setting_view object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu) name:notification_name_go_in_coupon_view object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindLeftMenuTouchSlideEvent) name:notification_name_bind_left_menu_touch_slide_event object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unbindLeftMenuTouchSlideEvent) name:notification_name_unbind_left_menu_touch_slide_event object:nil];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window setRootViewController:self.drawerController];
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"7xdlP6rSQiG8v2N0Hw8LzMGo9DmTLv2p" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    [WXApi registerApp:@"wx5e78de73aebd6cdd"];
    
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = [UIColor whiteColor];

    return YES;
}

#pragma mark -----链接跳转回调

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result =  [URLDispatcher dispatch:url nav:self.window.rootViewController.navigationController];
    if(!result){
//                [ShareSDK handleOpenURL:url
//                      sourceApplication:sourceApplication
//                             annotation:annotation
//                             wxDelegate:self];
    }
    if ([NSStringUtils isNotBlank:sourceApplication] ) {
        
        
    }
    
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    BOOL result =  [URLDispatcher dispatch:url nav:self.window.rootViewController.navigationController];
    NSLog(@">>>>>>H5跳转>>>>>>%d",result);
    if(!result){
        NSLog(@">>>>>>H5跳转>>>>>>%d",result);
        WeiXinPayProcessor *wxpayProcessor = [WeiXinPayProcessor sharedInstance];
        return  [WXApi handleOpenURL:url delegate:wxpayProcessor];
    }
    
    return  result;
}

#pragma mark -notification相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *aDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"获取并设置deviceToken: %@", aDeviceToken);
//    if (![[AppStatus sharedInstance].deviceToken isEqualToString:aDeviceToken]) {
//        
//    }
//    
//    [AppStatus sharedInstance].deviceToken = aDeviceToken;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"开始获取 百度的经纬度");
    [[BaiDuMapProcessor sharedInstance] startLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}



// 当点击首页的头部左侧的按钮时触发该方法
-(void) showLeftMenu
{
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

-(void) bindLeftMenuTouchSlideEvent{
    
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

-(void) unbindLeftMenuTouchSlideEvent{
    
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}


@end
