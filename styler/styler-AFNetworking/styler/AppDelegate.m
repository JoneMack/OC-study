//
//  AppDelegate.m
//  iUser
//
//  Created by System Administrator on 13-4-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

/*
有两种方式接收到PUSH，一个是由系统推来的，一个是程序主动从服务器拉来的
 */
#import "AppDelegate.h"
#import "AppStatus.h"
#import "Constant.h"
#import "PushRecord.h"
#import "PushStore.h"
#import "HdcStore.h"
#import "Reminder.h"
#import "PushProcessor.h"
#import "GaodeMapProcessor.h"
#import "SVProgressHUD.h"
#import "StylistEvaluationsController.h"
#import "UserStore.h"
#import "URLDispatcher.h"
#import "MobClick.h"
#import "UserFirstLoginController.h"
#import "UserActiveNotifier.h"
#import "ConfirmHdcOrderController.h"
#import "UIViewController+Custom.h"
#import "WorkListController.h"
#import "EvaluationStore.h"
#import "EaseMobProcessor.h"
#import "ChatViewController.h"
#import "ShareSDKProcessor.h"
#import "StylerTabbar.h"
#import "UMengSDKProcessor.h"
#import "ASIHTTPRequestProcessor.h"
#import "AppClientStore.h"
#import "RewardActivityProcessor.h"
#import "NSStringUtils.h"
#import "AppActiveScene.h"
#import "WeiXinPayProcessor.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化状态栏
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    //初始化窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化ShareSDK用户分享
    [ShareSDKProcessor initShareSDK];
    
    //友盟打印log 调试时用
    //[MobClick setLogEnabled:YES];
    //初始化友盟用于统计、自动更新提示、在线参数
    [UMengSDKProcessor initUMengSDK];
    
    //注册联网状态的通知监听器
    self.asiProcessor = [ASIHTTPRequestProcessor new];
    [self.asiProcessor initAFN];
    
    //注册接收PUSH
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    //初始化环信IM
    [EaseMobProcessor init:application launchOptions:launchOptions];
    
    //初始化奖励活动的监听器
    [RewardActivityProcessor initRewardActivityProcessorObserver];
    
    //初始化App的底栏
    self.tabbar = [StylerTabbar new];
    self.window.rootViewController = self.tabbar.tabbarController;
    
    //初始化提示器
    self.reminder = [Reminder sharedInstance];
    [self.reminder alertEvaluationShishangmao];
    return YES;
}

#pragma mark -----链接跳转回调

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    NSLog(@"链接调到app啦。。。。。。。openURL:%@" , sourceApplication);
    
    UINavigationController *nav = [self.tabbar getSelectedViewController];
    BOOL result =  [URLDispatcher dispatch:url nav:nav];
    if(!result){
         [ShareSDK handleOpenURL:url
               sourceApplication:sourceApplication
                      annotation:annotation
                      wxDelegate:self];
    }
    if ([NSStringUtils isNotBlank:sourceApplication] ) {
        
        WeiXinPayProcessor *wxpayProcessor = [WeiXinPayProcessor sharedInstance];
        wxpayProcessor.navigationController = nav;
        [WXApi handleOpenURL:url delegate:wxpayProcessor];
        
        AppStatus *as = [AppStatus sharedInstance];
        as.appBecomeActiveScene = fromOtherAppAwake;  // 这个地方有可能是从别的app启动此app ,也有可能是从别的app切换到app
        [AppStatus saveAppStatus];
    }
    return result;
}

#pragma mark -notification相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *aDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    aDeviceToken=[aDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
//    NSLog(@"获取并设置deviceToken: %@", aDeviceToken);
    if (![[AppStatus sharedInstance].deviceToken isEqualToString:aDeviceToken]) {
        [AppClientStore updateAppClient];
    }
    [AppStatus sharedInstance].deviceToken = aDeviceToken;
    [EaseMobProcessor registeDeviceToken:application deviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"获取deviceToken失败：%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息 ： %@, nt:%@", userInfo, [userInfo objectForKey:@"nt"]);
    if([userInfo objectForKey:@"nt"] != nil){
        PushRecord *pushRecord = [PushRecord readFromNotification:userInfo];
        PushProcessor *pushProcessor = [PushProcessor sharedInstance];
    
        if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
            if ([pushRecord isOrderPush] && [self.tabbar getSelectedIndex] != tabbar_item_index_me) {
                [self.tabbar setSelectedIndex:tabbar_item_index_me];
            }else if(pushRecord.pushType == push_type_system_feedback && [self.tabbar getSelectedIndex] != tabbar_item_index_contact){
                [self.tabbar setSelectedIndex:tabbar_item_index_contact];
            }
            pushProcessor.hasReceivePush = YES;
            [pushProcessor processPush:pushRecord comingFrom:push_from_jump_from_sys_notification naviagtionController:[self.tabbar getSelectedViewController]];
            [[self.tabbar getViewController:tabbar_item_index_special_offer] popToRootViewControllerAnimated:NO];
        }else{
            if ([pushRecord isOrderPush] && [self.tabbar getSelectedIndex] != tabbar_item_index_me){
                [self.tabbar setSelectedIndex:tabbar_item_index_me];
            }else if(pushRecord.pushType == push_type_system_feedback && [self.tabbar getSelectedIndex] != tabbar_item_index_contact){
                [self.tabbar setSelectedIndex:tabbar_item_index_contact];
            }
            [pushProcessor processPush:pushRecord comingFrom:push_from_receive_from_active_app naviagtionController:[self.tabbar getSelectedViewController]];
        }
    }else{
        [self.tabbar goChatView];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"收到本地推送：%@", notification);
    if ([[notification.userInfo objectForKey:@"nt"] isEqualToString:@"im_new_msg"]) {
        [self.tabbar goChatView];
    }
}

# pragma mark -System method
- (void)applicationWillResignActive:(UIApplication *)application
{
    [EaseMobProcessor applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [AppStatus saveAppStatus];
    [EaseMobProcessor applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [[UMengSDKProcessor sharedInstance] checkUpdate];
    [EaseMobProcessor applicationWillEnterForeground:application];
    //程序进入后台后，再次打开后会发出此通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    debugMethod();
    AppStatus *as = [AppStatus sharedInstance];
    if (as.appBecomeActiveScene == fromOtherAppAwake) {  // 如果是从其它app唤醒本app，则不提醒系统默认提醒的事件
        as.appBecomeActiveScene = fromBackgroundAwake;
        [AppStatus saveAppStatus];
        return;
    }

    
    [[PushStore sharedStore] getUnreadPush:^(NSArray *pushRecords, NSError *err) {
        NSLog(@"unread push from server:%@",pushRecords);
        if (err == nil && pushRecords.count > 0) {
                NSNotification *updateNotifi = [NSNotification notificationWithName:UIApplicationDidBecomeActiveNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:updateNotifi];
            for (PushRecord *pushRecord in pushRecords) {
                if([pushRecord isOrderPush] && [self.tabbar getSelectedIndex] != 3){
                    [self.tabbar setSelectedIndex:3];
                }
            }
            [[PushProcessor sharedInstance] processPushes:pushRecords comingFrom:[PushProcessor sharedInstance].hasReceivePush?push_from_pull_from_server_with_jump_sys_notification:push_from_pull_from_server naviagtionController:[self.tabbar getSelectedViewController]];
        }
     }];
    [self.reminder checkNeedReminded];
    [[RewardActivityProcessor sharedInstance] checkoutRedEnvelopeActivity];
    [[GaodeMapProcessor sharedInstance] startLocation];
    [MobClick updateOnlineConfig];
    [EaseMobProcessor applicationDidBecomeActive:application];
    [AppClientStore updateAppClient];

    // TODO: 这几句是防止app crash后不能及时的改变 appActiveScene的状态，所以在这里补了一句，之后加了crash的处理后，这个方法可以删除。
    as.appBecomeActiveScene = fromBackgroundAwake;
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    [AppStatus saveAppStatus];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [EaseMobProcessor applicationWillTerminate:application];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iUser" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iUser.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
