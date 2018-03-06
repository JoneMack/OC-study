//
//  AppDelegate.m
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/17.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "AppDelegate.h"
#import <JPFPSStatus/JPFPSStatus.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *appKey = @"b0d86231c03dfca479daacef";
static NSString *channel = @"Publish channel";
static BOOL isProduction = NO;
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 第一种办法：为了避免push和pop时导航条出现的黑块，给window设置一个背景色
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        //可以添加自定义categories
        if (@available(iOS 10.0, *)) {
            UNNotificationAction *closeAction = [UNNotificationAction actionWithIdentifier:@"close" title:@"关闭" options:UNNotificationActionOptionDestructive];
            UNNotificationAction *enterAction = [UNNotificationAction actionWithIdentifier:@"enter" title:@"进入" options:UNNotificationActionOptionForeground];
            UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"myNotificationCategory" actions:@[enterAction,closeAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
            NSSet<UNNotificationCategory *> *categories = [NSSet setWithObject:category];;
            entity.categories = categories;
        }
        else {
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"add";
            action1.title=@"增加";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
            
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"edit";
            action2.title=@"修改";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
            
            UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
            categorys.identifier = @"myNotificationCategory";//这组动作的唯一标示
            [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            
            NSSet<UIUserNotificationCategory *> *categories = [NSSet setWithObject:categorys];
            entity.categories = categories;
        }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.viewController = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    
#if defined(DEBUG)||defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
#endif
    return YES;
}


//#pragma mark 获取Wifi信息
//+ (id)fetchSSIDInfo
//{
//    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
//
//    id info = nil;
//    for (NSString *ifnam in ifs) {
//        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//
//        if (info && [info count]) {
//            break;
//        }
//    }
//    return info;
//}
//#pragma mark 获取WIFI名字
//+ (NSString *)getWifiSSID
//{
//    return (NSString *)[self fetchSSIDInfo][@"SSID"];
//}
//#pragma mark 获取WIFI的MAC地址
//+ (NSString *)getWifiBSSID
//{
//    return (NSString *)[self fetchSSIDInfo][@"BSSID"];
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        UNNotificationRequest *request = response.notification.request;
        // 收到推送的请求
        UNNotificationContent *content = request.content; // 收到推送的消息内容
        
        NSNumber *badge = content.badge;  // 推送消息的角标
        NSString *body = content.body;    // 推送消息体
        UNNotificationSound *sound = content.sound;  // 推送消息的声音
        NSString *subtitle = content.subtitle;  // 推送消息的副标题
        NSString *title = content.title;  // 推送消息的标题
        
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            
            // Required
            NSString *identifier = response.actionIdentifier;
            if ([identifier isEqualToString:@"close"]) {
                //对输入的文字作处理
                NSLog(@"close");
            }else if ([identifier isEqualToString:@"input"]){
                //
                NSLog(@"input");
            }else if ([identifier isEqualToString:@"enter"]){
                //enter
                NSLog(@"enter");
            }else if ([identifier isEqualToString:@"unLock"]){
                //enter
                NSLog(@"unLock");
            }
            NSLog(@"didReceiveNotificationResponse:response == %@",response);
            NSLog(@"didReceiveNotificationResponse:center == %@",center);
            NSDictionary * userInfo = response.notification.request.content.userInfo;
            //    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //      [JPUSHService handleRemoteNotification:userInfo];
            //    }
            
            [JPUSHService handleRemoteNotification:userInfo];
            NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
            
            
        }
        else {
            // 判断为本地通知
            NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        }
        completionHandler();  // 系统要求执行这个方法

    } else {
        // Fallback on earlier versions
    }
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if (@available(iOS 10.0, *)) {
        UNNotificationRequest *request = notification.request;
        // 收到推送的请求
        UNNotificationContent *content = request.content; // 收到推送的消息内容
        
        NSNumber *badge = content.badge;  // 推送消息的角标
        NSString *body = content.body;    // 推送消息体
        UNNotificationSound *sound = content.sound;  // 推送消息的声音
        NSString *subtitle = content.subtitle;  // 推送消息的副标题
        NSString *title = content.title;  // 推送消息的标题
        
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
            
            
            
        }
        else {
            // 判断为本地通知
            NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        }
         completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
   
}



// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}




@end
