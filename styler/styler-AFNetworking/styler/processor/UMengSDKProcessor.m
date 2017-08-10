//
//  UMengSDKProcessor.m
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UMengSDKProcessor.h"
#import "UserActiveNotifier.h"


@implementation UMengSDKProcessor

+(void) initUMengSDK
{
    AppStatus *as = [AppStatus sharedInstance];
    //友盟初始化
    [MobClick startWithAppkey:as.umengAppKey reportPolicy:SEND_INTERVAL channelId:nil];
    
    //检查版本更新
    [MobClick checkUpdateWithDelegate:[UMengSDKProcessor sharedInstance] selector:@selector(displayUpdateNote:)];
    
    //注册在线参数更新的通知
    [[NSNotificationCenter defaultCenter] addObserver:[UMengSDKProcessor sharedInstance] selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

+ (UMengSDKProcessor *) sharedInstance{
    static UMengSDKProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[UMengSDKProcessor alloc] init];
    }
    
    return sharedInstance;
}

-(void) checkUpdate{
    [MobClick checkUpdateWithDelegate:self selector:@selector(displayUpdateNote:)];
}

//在线参数更新后的回调方法
- (void)onlineConfigCallBack:(NSNotification *)notification {
    //NSLog(@"online config has fininshed and params = %@", notification.userInfo);
    AppStatus *as = [AppStatus sharedInstance];
    
    NSString *param = [NSString stringWithFormat:@"apiUrl_%@", as.appVersion];
    NSString *apiUrl = [MobClick getConfigParams:param];
    
    param = [NSString stringWithFormat:@"webPageUrl_%@", as.appVersion];
    NSString *webPageUrl = [MobClick getConfigParams:param];
    
    param = [NSString stringWithFormat:@"searcherUrl_%@", as.appVersion];
    NSString *searcherUrl = [MobClick getConfigParams:param];
    if(apiUrl && ![apiUrl isEqualToString:@""]){
        as.apiUrl = apiUrl;
    }
    if (webPageUrl && ![webPageUrl isEqualToString:@""]) {
        as.webPageUrl = webPageUrl;
    }
    if (searcherUrl && ![searcherUrl isEqualToString:@""]) {
        as.searcherUrl = searcherUrl;
    }
    
    [UserActiveNotifier sendActiveNotify:@"index"];
}

-(void) displayUpdateNote:(NSDictionary *)dict{
    NSString *update = (NSString*)[dict objectForKey:@"update"];
    NSString *updateLog = (NSString*)[dict objectForKey:@"update_log"];
    
    if ([update isEqualToString:@"YES"]) {
        UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                              message:updateLog
                                                             delegate:[UMengSDKProcessor sharedInstance]
                                                    cancelButtonTitle:@"立刻更新"
                                                    otherButtonTitles:nil, nil];
        [alertUpdate show];
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
        NSURL *appUrl = [[NSURL alloc] initWithString:@"https://itunes.apple.com/cn/app/shi-shang-mao/id673935108?mt=8"];
        [[UIApplication sharedApplication] openURL:appUrl];
    }
}

@end
