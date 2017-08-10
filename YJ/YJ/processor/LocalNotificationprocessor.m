//
//  LocalNotificationprocessor.m
//  CrazyDoctor
//
//  Created by xubojoy on 16/5/23.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "LocalNotificationprocessor.h"
#import "BHZhiBoTabbar.h"
#import "AppDelegate.h"
@implementation LocalNotificationprocessor

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification naviagtionController:(UINavigationController *)nav{
    self.navigationController = nav;
    NSLog(@">>>>>>>notification.alertBody>>>>%@",notification.alertBody);
    self.bodyName = notification.alertBody;
    [AppStatus sharedInstance].acupointName = self.bodyName;
    [AppStatus saveAppStatus];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:notification.alertBody delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确认",nil];
    [alert show];
    NSLog(@"接收本地通知啦！！！");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新穴位" object:self.bodyName];
    if (buttonIndex == 1) {
        [self jumpDetailWithName:self.bodyName navigationController:self.navigationController];
    }
}

- (void)jumpDetailWithName:(NSString *)bodyName navigationController:(UINavigationController *)navigationController{
}

+ (LocalNotificationprocessor *) sharedInstance{
    static LocalNotificationprocessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[LocalNotificationprocessor alloc] init];
    }
    
    return sharedInstance;
}


@end
