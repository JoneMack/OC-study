//
//  EaseMobProcessor.m
//  styler
//
//  Created by System Administrator on 14-8-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "EaseMobProcessor.h"
#import "UserStore.h"


@interface  EaseMobProcessor()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation EaseMobProcessor

+(void) init:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{
    //注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
	NSString *apnsCertName = [AppStatus sharedInstance].easemobApnsCertName;
    //NSLog(@">>>>>>ease mob config: %@, %@", apnsCertName, [AppStatus sharedInstance].easemobAppKey);
	[[EaseMob sharedInstance] registerSDKWithAppKey:[AppStatus sharedInstance].easemobAppKey apnsCertName:apnsCertName];
	[[EaseMob sharedInstance] enableBackgroundReceiveMessage];
	[[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager addDelegate:[EaseMobProcessor sharedInstance] delegateQueue:nil];
}


+(void) login:(BOOL)delay{
    double delayInSeconds = delay?0:2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[EaseMobProcessor sharedInstance] doLogin];
    });
}

-(void) doLogin{
    AppStatus *as = [AppStatus sharedInstance];
    if (![as logined] || as.easeMobLogined) {
        return ;
    }
    if (as.user.easemobUserUuid != nil && ![as.user.easemobUserUuid isEqual:[NSNull null]]
        && ![as.user.easemobUserUuid isEqualToString:@""]) {
        //NSLog(@">>>> easemob username:%@, pwd:%@", as.user.userCode, as.user.accessToken);
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:as.user.userCode
                                                            password:as.user.accessToken
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             if (error) {
                 NSLog(@"登录环信失败:%@", error);
                 [EaseMobProcessor login:YES];
             }else {
                 NSLog(@"登录环信成功");
                 as.easeMobLogined = YES;
                 [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_im_message_status_update object:nil];
                 [[AppStatus sharedInstance] updateBadge];
             }
         } onQueue:nil];
    }else{
        [UserStore getMyUserInfo:^(User *user, NSError *err) {
            as.user.easemobUserUuid = user.easemobUserUuid;
            [EaseMobProcessor login:YES];
        }];
    }
}

+(void) logout{
    AppStatus *as = [AppStatus sharedInstance];
    [[EaseMob sharedInstance].chatManager asyncLogoff];
    as.easeMobLogined = NO;
    [AppStatus saveAppStatus];
}

+(int) unreadSupportMessageCount{
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"support" isGroup:NO];
    return conversation.unreadMessagesCount;
}

+(void) clearUnreadMessage:(EMConversation *)conversation{
    [conversation markMessagesAsRead:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_im_message_status_update object:nil];
    [[AppStatus sharedInstance] updateBadge];
}

-(void) didReceiveMessage:(EMMessage *)message{
    //NSLog(@">>>>>>>>> receive message:%@", message);
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = @"您有一条新消息";
        notification.alertAction = @"打开";
        [notification setUserInfo:@{@"nt": @"im_new_msg"}];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber += 1;
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_im_message_status_update object:nil];
}

+(void) registeDeviceToken:(UIApplication *)application deviceToken:(NSData *)deviceToken{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

+(void) applicationWillResignActive:(UIApplication *)application{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillResignActive:application];
}

+(void) applicationDidEnterBackground:(UIApplication *)application{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

+(void) applicationWillEnterForeground:(UIApplication *)application{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

+(void) applicationDidBecomeActive:(UIApplication *)application{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationDidBecomeActive:application];
    [EaseMobProcessor login:NO];
}

+(void) applicationWillTerminate:(UIApplication *)application{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
	[[EaseMob sharedInstance] applicationWillTerminate:application];
}

+ (EaseMobProcessor *) sharedInstance{
    static EaseMobProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[EaseMobProcessor alloc] init];
        sharedInstance.queue = [[NSOperationQueue alloc]init];
    }
    
    return sharedInstance;
}

@end
