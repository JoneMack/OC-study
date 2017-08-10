//
//  WXPayProcessor.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/11.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "WXPayProcessor.h"
#import "WXApi.h"
#import "PayStore.h"
#import "DataMD5.h"
#import "User.h"

@implementation WXPayProcessor


+ (WXPayProcessor *) sharedInstance{
    static WXPayProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[WXPayProcessor alloc] init];
    }
    
    return sharedInstance;
}


-(void) payPoint:(void (^)(NSError *err))completionBlock
          userId:(NSString *)userId
         orderNo:(NSString *)orderNo
       payAmount:(NSString *)payAmount
{
    
    [PayStore genPrePay:^(NSDictionary *weixinPrePay, NSError *err) {
        
        if (weixinPrePay != nil) {
            NSLog(@"生成预订单成功");
            if ([WXApi isWXAppInstalled]) {
                
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = [weixinPrePay valueForKey:@"mch_id"];
                request.prepayId= [weixinPrePay valueForKey:@"prepay_id"];
                request.package = @"Sign=WXPay";
                request.nonceStr= [weixinPrePay valueForKey:@"nonce_str"];
                request.timeStamp = [[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] intValue];
                DataMD5 *md5 = [[DataMD5 alloc] init];
                request.sign=[md5 createMD5SingForPay:[weixinPrePay valueForKey:@"appid"]
                                            partnerid:request.partnerId
                                             prepayid:request.prepayId
                                              package:request.package
                                             noncestr:request.nonceStr
                                            timestamp:request.timeStamp];
                if(![WXApi sendReq:request]){
                    [SVProgressHUD showErrorWithStatus:@"调用微信支付app失败"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"未安装微信客户端" duration:3];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"生成微信支付预订单失败"];
        }
        
        
    } userId:userId orderNo:orderNo payAmount:payAmount];
}

-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
//        NSLog(@">>>>>>>支付失败>>>>>>>>>%d>>>>%@",response.errCode,response.errStr);
        switch (response.errCode) {
            case WXSuccess:
                NSLog(@">>>>>>>>>response point:%@" , self.point);
                [self paySuccess];
                [SVProgressHUD showSuccessWithStatus:@"支付成功" duration:2.0];
                break;
            default:
                [SVProgressHUD showErrorWithStatus:@"订单未支付" duration:2.0];
                break;
        }
    }
}

-(void) onReq:(BaseReq *)req
{
    
}

-(void) paySuccess
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_pay_success object:nil];

}


@end
