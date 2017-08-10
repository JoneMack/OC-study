//
//  AlipayProceessor.m
//  CrazyDoctor
//
//  Created by xubojoy on 16/7/13.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "AlipayProceessor.h"
#import "AlixPayResult.h"
#import "UserStore.h"
#import "AlixPayOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PartnerConfig.h"
#import "MyContractViewController.h"
@implementation AlipayProceessor
-(void) processPaymentResultFromApp:(NSURL *)result nav:(UINavigationController *)nav{
    //跳转支付宝钱包进行支付，处理支付结果
    self.navigationController = nav;
    NSLog(@"self.navigationController = %@",self.navigationController);
    [[AlipaySDK defaultService] processOrderWithPaymentResult:result standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result22222222222 = %@",resultDic);
        if (resultDic != nil) {
            int resultStatus = [resultDic[@"resultStatus"] intValue];
            //支付成功跳转到我的美发卡列表页
            if (resultStatus == 9000){
                [SVProgressHUD showSuccessWithStatus:@"支付成功！"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"跳转到我的合同" object:nil];
            }
            //支付失败
            else{
               [SVProgressHUD showErrorWithStatus:@"订单未支付"];
                
            }
        }
    }];
}

-(void)doAlipay:(AlixPayOrder *)payOrder alipaySign:(NSString *)alipaySign paymentType:(NSString *)paymentType navigationController:(UINavigationController *)navigationController{
    self.navigationController = navigationController;
    [SVProgressHUD dismiss];
    if ([paymentType isEqualToString:ALI_PAY]) {
        payOrder.notifyURL = [payOrder.notifyURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *appScheme = @"xiangyu";
        NSString *orderInfo = [payOrder description];
        
        alipaySign = (__bridge_transfer  NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)alipaySign, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
        
        orderInfo = [NSString stringWithFormat:@"_input_charset=utf-8&body=%@&notify_url=%@&out_trade_no=%@&partner=%@&payment_type=1&return_url=%@&seller_id=%@&service=mobile.securitypay.pay&subject=%@&total_fee=%@&sign=%@&sign_type=RSA",payOrder.body, payOrder.notifyURL , payOrder.outTradeNO ,payOrder.partner , payOrder.returnURL , payOrder.sellerID , payOrder.subject , payOrder.totalFee , alipaySign];
        
        [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut1111111111111111 = %@",resultDic);
            NSLog(@"error msg:%@",[resultDic valueForKey:@"memo"]);
            if (resultDic != nil) {
                int resultStatus = [resultDic[@"resultStatus"] intValue];
                if (resultStatus == 9000){
                    [SVProgressHUD showSuccessWithStatus:@"支付成功！"];
                    MyContractViewController *mcvc = [[MyContractViewController alloc] init];
                    mcvc.pushTypeStr = push_from_fill_user_vc;
                    [self.navigationController pushViewController:mcvc animated:YES];
                }
                //支付失败
                else{
                   [SVProgressHUD showErrorWithStatus:@"订单未支付"];
                }
            }
        }];
    }
}


-(AlixPayOrder *) buildAlixPayOrder:(AliPay *)projectOrder{
    AlixPayOrder *payOrder = [AlixPayOrder new];
    payOrder.partner = projectOrder.partner;
    payOrder.sellerID = projectOrder.seller_id;
    payOrder.outTradeNO = [NSString stringWithFormat:@"%@",projectOrder.out_trade_no];
    payOrder.totalFee = [NSString stringWithFormat:@"%.2f", [projectOrder.total_fee floatValue]];
    payOrder.service = @"mobile.securitypay.pay";
    payOrder.inputCharset = @"utf-8";
    payOrder.notifyURL = [projectOrder.notify_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    payOrder.returnURL = [projectOrder.return_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    payOrder.subject = projectOrder.subject;
    payOrder.body = projectOrder.body;
    NSLog(@">>>>>>>>>>payOrderpayOrderpayOrder>>>>>>%@",payOrder);
    return payOrder;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

//-(void)paymentResultDelegate:(NSURL *)result
//{
//    [[AlipayProceessor sharedInstance] processPaymentResultFromApp:result nav:self.navigationController];
//}


+ (AlipayProceessor *) sharedInstance{
    static AlipayProceessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[AlipayProceessor alloc] init];
    }
    
    return sharedInstance;
}

@end
