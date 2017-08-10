//
//  UMengSDKProcessor.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/9.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "UMengSDKProcessor.h"
#import "UMSocial.h"
//#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
@implementation UMengSDKProcessor
+(void) initUMengSDK
{
    [UMSocialData setAppKey:umeng_app_key];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:wx_appid appSecret:wx_appSecret url:umeng_share_url];
    
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:qq_appid appKey:qq_app_key url:umeng_share_url];
}

+ (UMengSDKProcessor *) sharedInstance{
    static UMengSDKProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[UMengSDKProcessor alloc] init];
    }
    
    return sharedInstance;
}

@end
