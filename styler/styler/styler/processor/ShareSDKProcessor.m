//
//  ShareSDKProcessor.m
//  styler
//
//  Created by wangwanggy820 on 14-8-8.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ShareSDKProcessor.h"
#import "WeiboApi.h"
#import "WXApi.h"

@implementation ShareSDKProcessor


- (void)share:(ShareContent *)shareContent hideShareTypes:(NSMutableArray *)hideShareTypes shareViewDelegate:(id)shareViewDelegate sender:(id)sender shareSuccessBlock:(void (^)(ShareSceneType *shareSceneType))shareSuccessBlock{
    if(shareContent == nil){
        return ;
    }
    
    [self convertSpecialSymbol:shareContent];
   
    id<ISSCAttachment> shareImg;
    id<ISSCAttachment> wxShareImg;


    if (shareContent.image) {
        shareImg = [ShareSDK imageWithData:UIImagePNGRepresentation(shareContent.image) fileName:shareContent.title mimeType:@"image/png"];
        UIImage *cropedImg = [self imageWithImage:shareContent.image];
        wxShareImg = [ShareSDK imageWithData:UIImagePNGRepresentation(cropedImg) fileName:shareContent.title mimeType:@"image/png"];
    }else{
        shareImg = [ShareSDK imageWithUrl:shareContent.imageUrl];
    }

   
    
        id<ISSContent> publishContent = [ShareSDK content:shareContent.content
                            defaultContent:nil
                                     image:shareImg
                                     title:shareContent.title
                                       url:shareContent.url
                               description:nil
                                 mediaType:SSPublishContentMediaTypeNews];
    
        [publishContent addSinaWeiboUnitWithContent:shareContent.sinaWeiBoContent image:shareImg];

        NSString *smsContent = [NSString stringWithFormat:@"%@ %@" ,  shareContent.content , shareContent.url];
        [publishContent addSMSUnitWithContent:smsContent];
    
        //        [publishContent addTencentWeiboUnitWithContent:[self getShareWithUrlContent] image:[self getShareIamge]];
        //定制微信好友信息
        [publishContent addWeixinSessionUnitWithType:@(SSPublishContentMediaTypeNews)
                                             content:shareContent.content
                                               title:shareContent.title
                                                 url:shareContent.url
                                          thumbImage:wxShareImg
                                               image:wxShareImg
                                        musicFileUrl:nil
                                             extInfo:nil
                                            fileData:nil
                                        emoticonData:nil];
        
        //定制微信朋友圈信息
        [publishContent addWeixinTimelineUnitWithType:[[NSNumber alloc] initWithInt:SSPublishContentMediaTypeApp]
                                              content:nil
                                                title:shareContent.content
                                                  url:shareContent.url
                                           thumbImage:wxShareImg
                                                image:wxShareImg
                                         musicFileUrl:nil
                                              extInfo:shareContent.content
                                             fileData:nil
                                         emoticonData:nil];
    

        //定制微信收藏信息
        [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
                                         content:shareContent.content
                                           title:shareContent.title
                                             url:shareContent.url
                                      thumbImage:wxShareImg
                                           image:wxShareImg
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];

    
        
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                         viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"时尚猫官方微博"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    nil]];
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:shareViewDelegate
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //定义需要显示的分享媒介
    NSMutableArray *shareList = [[ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeWeixiFav,
                          ShareTypeSMS,
                          nil] mutableCopy];
    
    if (hideShareTypes != nil && hideShareTypes.count > 0) {
        for (int i=0 ; i<hideShareTypes.count ; i++) {
            [shareList removeObject:hideShareTypes[i]];
        }
    }
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                NSString *shareResultTxt = state == SSPublishContentStateSuccess?@"成功":@"失败";
                                switch (type) {
                                    case ShareTypeSinaWeibo:
                                       
                                        [MobClick event:log_event_name_share_to_sina_weibo attributes:[NSDictionary dictionaryWithObjectsAndKeys:shareResultTxt, @"分享结果", nil]];
                                        break;
                                    case ShareTypeWeixiFav:
                                        [MobClick event:log_event_name_share_to_wechat_Fav attributes:[NSDictionary dictionaryWithObjectsAndKeys:shareResultTxt, @"分享结果", nil]];
                                        break;
                                    case ShareTypeWeixiSession:
                                        [MobClick event:log_event_name_share_to_wechat_session attributes:[NSDictionary dictionaryWithObjectsAndKeys:shareResultTxt, @"分享结果", nil]];
                                        break;
                                    case ShareTypeWeixiTimeline:
                                        [MobClick event:log_event_name_share_to_wechat_time_line attributes:[NSDictionary dictionaryWithObjectsAndKeys:shareResultTxt, @"分享结果", nil]];
                                        break;
                                    case ShareTypeSMS:
                                        [MobClick event:log_event_name_share_to_sms attributes:[NSDictionary
                                            dictionaryWithObjectsAndKeys:shareResultTxt, @"分享结果", nil]];
                                        break;
                                    default:
                                        break;
                                }
                                
                                if (state == SSPublishContentStateSuccess)
                                {
//                                     NSLog(@"__________________分享成功");
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                    // 这个地方先注释了，因为它与获取到奖励活动的提示有冲突
                                    [SVProgressHUD showSuccessWithStatus:@"分享成功" duration:0.5];
                                    if (![[NSUserDefaults standardUserDefaults] boolForKey:binding_sina_weibo_key]) {
                                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:binding_sina_weibo_key];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                    }
                                    
//                                    ShareSceneType *sceneType = [[ShareSceneType alloc] initWithType:shareContent.shareContentType sharedChannelType:type];
//                                    shareSuccessBlock(sceneType);
                                    
                                    if ([self.delegate respondsToSelector:@selector(sharedSuccess)]) {
                                        [self.delegate sharedSuccess];
                                    }
                                    
                                }
                                else if (state == SSPublishContentStateFail)
                                {
//                                    NSLog(@"__________________分享失败");
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [SVProgressHUD showErrorWithStatus:@"分享失败" duration:0.5];
                                    if ([self.delegate respondsToSelector:@selector(sharedFail)]) {
                                        [self.delegate sharedFail];
                                    }
                                }else if(state == SSResponseStateCancel){
                                    if ([self.delegate respondsToSelector:@selector(sharedCancel)]) {
                                        [self.delegate sharedCancel];
                                    }
                                }
    }];
}

+(void)customShareView:(UIViewController *)viewController shareType:(ShareType)shareType{
//    NSLog(@">>> view on will display");
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
    //修改左右按钮的文字颜色
    UIBarButtonItem *leftBtn = viewController.navigationItem.leftBarButtonItem;
    [leftBtn setTitle:@"取消"];
    [leftBtn setTintColor:[ColorUtils colorWithHexString:black_text_color]];
    
    UIBarButtonItem *rightBtn = viewController.navigationItem.rightBarButtonItem;
    [rightBtn setTitle:@"发布"];
    [rightBtn setTintColor:[ColorUtils colorWithHexString:black_text_color]];
    
    //修改标题颜色和文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [ColorUtils colorWithHexString:black_text_color];
    label.text = viewController.title;
    
    label.font = [UIFont boldSystemFontOfSize:bigger_font_size];
    [label sizeToFit];
    viewController.navigationItem.titleView = label;
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image
{
    if (image.size.width == image.size.height) {
        return image;
    }
    CGSize size = image.size;
    float ratio = size.width/size.height;
    float newRatio = 1;
    float x = 0;
    float y = 0;
    float cropedWidth = 0;
    float cropedHeight = 0;
    if (ratio > newRatio) {
        cropedHeight = size.height;
        cropedWidth = cropedHeight*newRatio;
        x = (size.width - cropedWidth)/2;
    }else{
        cropedWidth = size.width;
        cropedHeight = cropedWidth/newRatio;
        y = (size.height - cropedHeight)/2;
    }
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(x, y, cropedWidth, cropedHeight));
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    
    CGSize newSize = CGSizeMake(200, 200);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [smallImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+(void)followSinaWeiBo{

    //关注用户
    [ShareSDK followUserWithType:ShareTypeSinaWeibo                         //平台类型
                           field:@"1986740625"                              //关注用户的名称或ID
                       fieldType:SSUserFieldTypeUid                         //字段类型，用于指定第二个参数是名称还是ID
                     authOptions:nil                                        //授权选项
                    viewDelegate:nil                                        //授权视图委托
                          result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {                                             //返回回调
                              if (state == SSResponseStateSuccess)
                              {
//                                  NSLog(@"关注成功");
                              }
                              else if (state == SSResponseStateFail)
                              {
//                                  NSLog(@"%@", [NSString stringWithFormat:@"关注失败:%@", error.errorDescription]);
                              }
     }];
}

-(void)followWeiXinTimeLine:(id)sender
               shareContent:(ShareContent *)shareContent
          shareSuccessBlock:(void(^)())shareSuccessBlock{
    
    id<ISSCAttachment> shareImg;
    id<ISSCAttachment> wxShareImg;
    
    
    if (shareContent.image) {
        shareImg = [ShareSDK imageWithData:UIImagePNGRepresentation(shareContent.image) fileName:shareContent.title mimeType:@"image/png"];
        UIImage *cropedImg = [self imageWithImage:shareContent.image];
        wxShareImg = [ShareSDK imageWithData:UIImagePNGRepresentation(cropedImg) fileName:shareContent.title mimeType:@"image/png"];
    }else if (shareContent.imageUrl){
        wxShareImg = [ShareSDK imageWithPath:shareContent.imageUrl];
    }
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@""
                                       defaultContent:nil
                                                image:wxShareImg
                                                title:shareContent.content
                                                  url:shareContent.url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                          container:container
                            content:publishContent
                      statusBarTips:NO
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 if (state == SSPublishContentStateSuccess) {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
//                                     [SVProgressHUD showSuccessWithStatus:@"分享成功" duration:0.5];
                                     shareSuccessBlock();
                                 }else if (state == SSPublishContentStateFail){
                                     NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                 
                                 }
                             }];
}

-(void) convertSpecialSymbol:(ShareContent *)shareContent{
    shareContent.title = [shareContent.title stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    shareContent.content = [shareContent.content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    shareContent.sinaWeiBoContent = [shareContent.sinaWeiBoContent stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}

+(void) initShareSDK{
    [ShareSDK registerApp:@"28cddc5a2c90"];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"4128349648"
                               appSecret:@"734f562feb2ff01b35aba445bb9a2457"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    //    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    //    [ShareSDK connectTencentWeiboWithAppKey:@"801528473"
    //                                  appSecret:@"9101e92b599a40712212547be6977c2a"
    //                                redirectUri:@"http://www.meilizhuanjia.cn"
    //                                   wbApiCls:[WeiboApi class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx8216675fb452a3d6"
                           wechatCls:[WXApi class]];
    
    [ShareSDK connectSMS];
    //激活SSO
    [ShareSDK ssoEnabled:YES];
}
@end
