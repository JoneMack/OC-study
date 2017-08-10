//
//  UMengProcessor.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/7.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "UMengProcessor.h"

@implementation UMengProcessor

/**
 * 初始化 umeng
 */
+(void) initUMengSDK
{
    AppStatus *as = [AppStatus sharedInstance];
    //友盟初始化
    
    NSLog(@"友盟初始化---appKey:%@" , as.umengAppKey);
    [MobClick startWithAppkey:as.umengAppKey reportPolicy:BATCH channelId:nil];
    // 日志发送间隔
//    [MobClick setLogSendInterval:2];
    
    //检查在线参数
    [MobClick updateOnlineConfig];
    
    //注册在线参数更新的通知
    [[NSNotificationCenter defaultCenter] addObserver:[UMengProcessor sharedInstance]
                                             selector:@selector(onlineConfigCallBack:)
                                                 name:UMOnlineConfigDidFinishedNotification
                                               object:nil];
}

+ (UMengProcessor *) sharedInstance{
    static UMengProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[UMengProcessor alloc] init];
    }
    
    return sharedInstance;
}

-(void) checkUpdate{
    [MobClick checkUpdateWithDelegate:[UMengProcessor sharedInstance] selector:@selector(displayUpdateNote:)];
}

-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}


//在线参数更新后的回调方法
- (void)onlineConfigCallBack:(NSNotification *)notification {
    NSLog(@"注册在线参数更新提醒》》》》》》》》》》》%@",notification.userInfo);
    NSDictionary *userInfo = notification.userInfo;
    self.forcedToUpdate = [[userInfo objectForKey:@"forcedToUpdate"] intValue];
    
    [AppStatus sharedInstance].myAccount = [[userInfo objectForKey:@"myAccount"] intValue];
    [AppStatus sharedInstance].orderRecord = [[userInfo objectForKey:@"orderRecord"] intValue];
    [AppStatus sharedInstance].recommend = [[userInfo objectForKey:@"recommend"] intValue];
//    AppStatus *as = [AppStatus sharedInstance];
    
//    NSString *param = [NSString stringWithFormat:@"apiUrl_%@", as.appVersion];
//    NSString *apiUrl = [MobClick getConfigParams:param];
//    if(apiUrl && ![apiUrl isEqualToString:@""]){
//        as.apiUrl = apiUrl;
//    }

    //检查版本更新
    [MobClick checkUpdateWithDelegate:[UMengProcessor sharedInstance] selector:@selector(displayUpdateNote:)];
}

-(void) displayUpdateNote:(NSDictionary *)dict{
    NSString *update = (NSString*)[dict objectForKey:@"update"];
    NSString *updateLog = (NSString*)[dict objectForKey:@"update_log"];
    NSLog(@">>>>>>>>>>友盟检查版本更新>>>>>%@>>>>>>>%@------", dict, update);
    if ([update isEqualToString:@"YES"]) {
        
        if (self.forcedToUpdate == 0) {  // 提示更新
            UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                                  message:updateLog
                                                                 delegate:[UMengProcessor sharedInstance]
                                                        cancelButtonTitle:@"立即更新"
                                                        otherButtonTitles:@"暂不更新", nil];
            [alertUpdate show];
        }else{ // 强制更新
            UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                                  message:updateLog
                                                                 delegate:[UMengProcessor sharedInstance]
                                                        cancelButtonTitle:@"立刻更新"
                                                        otherButtonTitles:nil, nil];
            [alertUpdate show];
        }
        
        
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    for( UIView * view in alertView.subviews )
    {
        if( [view isKindOfClass:[UILabel class]] )
        {
            UILabel* label = (UILabel*) view;
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *appUrl = [[NSURL alloc] initWithString:@"https://itunes.apple.com/us/app/ai-cai-xun/id1033452434?l=zh&ls=1&mt=8"];
        [[UIApplication sharedApplication] openURL:appUrl];
    }
}


@end
