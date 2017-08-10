//
//  WeiXinPayProcessor.m
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WeiXinPayProcessor.h"
#import "PayProcessor.h"
#import <objc/runtime.h>
#import "DataMD5.h"
#import "PayStore.h"
#import "MyContractViewController.h"

@implementation WeiXinPayProcessor
/**
 获取支付参数
 调起微信支付
 */
-(void)doWeixinpay:(NSString *)payAmount payInfoDtoList:(NSMutableArray *)payInfoDtoList navigationController:(UINavigationController *)navigationController{
    self.navigationController = navigationController;
    [[PayStore sharedStore] payWxOrder:^(NSDictionary *weixinPayInfo, NSError *err) {
        NSLog(@">>>>>>>wx:%@" , weixinPayInfo);
            if (weixinPayInfo != nil) {
                if ([WXApi isWXAppInstalled]) {
                    PayReq *request = [[PayReq alloc] init];
                    request.partnerId = [weixinPayInfo valueForKey:@"partnerid"];
                    request.prepayId= [weixinPayInfo valueForKey:@"prepayid"];
                    request.package = @"Sign=WXPay";
                    request.nonceStr= [weixinPayInfo valueForKey:@"noncestr"];
                    //发起微信支付，设置参数
                    //将当前事件转化成时间戳
                    NSDate *datenow = [NSDate date];
                    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                    UInt32 timeStamp =[timeSp intValue];
                    request.timeStamp= timeStamp;
                    request.sign=[weixinPayInfo valueForKey:@"sign"];
                    NSLog(@">>>>>>>request:%@" , request);
                    //            调用微信
                    if(![WXApi sendReq:request]){
                        [SVProgressHUD showErrorWithStatus:@"调用微信支付app失败"];
                    }
                }else if(![WXApi isWXAppInstalled]){
                    [SVProgressHUD showErrorWithStatus:@"未安装微信客户端"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"生成微信支付预订单失败"];
            }
        
    } orderType:@"1" type:@"1000200250003" payChannel:@"1000200420001" openId:@"" payAmount:payAmount payInfoDtoList:payInfoDtoList];
}
/**
 WXApiDelegate 微信支付回调代理方法
 */
-(void)onResp:(BaseResp*)resp{

    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        NSLog(@">>>>>>>支付结果>>>>>>>>>%d>>>>%@",response.errCode,response.errStr);
        switch (response.errCode) {
            case WXSuccess:
                {
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    MyContractViewController *mcvc = [[MyContractViewController alloc] init];
                    mcvc.pushTypeStr = push_from_fill_user_vc;
                    [self.navigationController pushViewController:mcvc animated:YES];
                }
                break;
            default:
                {
                    [SVProgressHUD showErrorWithStatus:@"订单未支付"];
                }
                break;
        }
    }
}

+ (WeiXinPayProcessor *) sharedInstance{
    static WeiXinPayProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[WeiXinPayProcessor alloc] init];
    }
    return sharedInstance;
}

@end
