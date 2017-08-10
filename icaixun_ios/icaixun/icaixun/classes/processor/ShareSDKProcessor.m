//
//  ShareSDKProcessor.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/17.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ShareSDKProcessor.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@implementation ShareSDKProcessor

+(ShareSDKProcessor *) sharedInstance{
    static ShareSDKProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[ShareSDKProcessor alloc] init];
    }
    
    return sharedInstance;
}

+(void) initShareSDK
{
    [ShareSDK registerApp:[AppStatus sharedInstance].shareSDKKey
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeTencentWeibo),
//                            @(SSDKPlatformTypeMail),
//                            @(SSDKPlatformTypeSMS),
//                            @(SSDKPlatformTypeCopy),
//                            @(SSDKPlatformTypeFacebook),
//                            @(SSDKPlatformTypeTwitter),
                            @(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformTypeQQ),
//                            @(SSDKPlatformTypeDouBan)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
//                         case SSDKPlatformTypeQQ:
//                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
//                  case SSDKPlatformTypeSinaWeibo:
//                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                              redirectUri:@"http://www.sharesdk.cn"
//                                                 authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeTencentWeibo:
//                      //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
//                      [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
//                                                   appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                                 redirectUri:@"http://www.sharesdk.cn"];
//                      break;
//                  case SSDKPlatformTypeFacebook:
//                      //设置Facebook应用信息，其中authType设置为只用SSO形式授权
//                      [appInfo SSDKSetupFacebookByAppKey:@"107704292745179"
//                                               appSecret:@"38053202e1a5fe26c80c753071f0b573"
//                                                authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeTwitter:
//                      [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
//                                              consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
//                                                 redirectUri:@"http://mob.com"];
//                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:[AppStatus sharedInstance].wxAppId
                                            appSecret:[AppStatus sharedInstance].wxAppSecret];
                      break;
//                  case SSDKPlatformTypeQQ:
//                      [appInfo SSDKSetupQQByAppId:@"100371282"
//                                           appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                         authType:SSDKAuthTypeBoth];
//                  case SSDKPlatformTypeDouBan:
//                      [appInfo SSDKSetupDouBanByApiKey:@"02e2cbe5ca06de5908a863b15e149b0b"
//                                                secret:@"9f1e7b4f71304f2f"
//                                           redirectUri:@"http://www.sharesdk.cn"];
//                      break;
                  default:
                      break;
              }
              
          }];

}

-(void) share:(UIView *)view title:(NSString *)titleStr
{
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo_108"]];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ai-cai-xun/id1033452434?l=zh&ls=1&mt=8"]
                                          title:titleStr
                                           type:SSDKContentTypeApp];
        
        [shareParams SSDKSetupWeChatParamsByText:titleStr title:@"爱财讯" url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ai-cai-xun/id1033452434?l=zh&ls=1&mt=8"] thumbImage:[UIImage imageNamed:@"logo_108"] image:[UIImage imageNamed:@"logo_108"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeApp forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        
        
        [shareParams SSDKSetupWeChatParamsByText:titleStr title:titleStr url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ai-cai-xun/id1033452434?l=zh&ls=1&mt=8"] thumbImage:[UIImage imageNamed:@"logo_108"] image:[UIImage imageNamed:@"logo_108"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeApp forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    
        [ShareSDK showShareActionSheet:view
                                 items:  @[@(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformSubTypeQQFriend)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                               
                           case SSDKResponseStateBegin:
                           {
//                               [theController showLoadingView:YES];
                               break;
                           }
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               else
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
    }

}

@end
