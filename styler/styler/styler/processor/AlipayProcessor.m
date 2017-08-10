//
//  AlipayProcessor.m
//  styler
//
//  Created by System Administrator on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "AlipayProcessor.h"
#import "AlixPayResult.h"
#import "UserHdc.h"
#import "UserHdcController.h"
#import "LeveyTabBarController.h"
#import "UserCenterController.h"
#import "ConfirmHdcOrderController.h"
#import "OrganizationDetailInfoController.h"
#import "StylistProfileController.h"
#import "UserHdcController.h"
#import "HdcStore.h"
#import "UserStore.h"
#import "AlixPayOrder.h"
#import "StylistStore.h"
#import "AlixLibService.h"
#import "AlipayWebController.h"
#import "DataSigner.h"
#import "PartnerConfig.h"


@implementation AlipayProcessor

-(void) processPaymentResultFromApp:(NSString *)result nav:(UINavigationController *)nav{
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AlixPayResult *payResult = [[AlixPayResult alloc] initWithString:result];
    //支付成功跳转到我的美发卡列表页
    if (payResult.statusCode == 9000){
        if ([self.delegate respondsToSelector:@selector(paymentSuccess:)]) {
            [self.delegate paymentSuccess:nav];
        }
    }
    //支付失败
    else{
        if ([self.delegate respondsToSelector:@selector(paymentFail:)]) {
            [self.delegate paymentFail:nav];
        }
    }
}

-(void) processPaymentResultFromWeb:(NSString *)result nav:(UINavigationController *)nav{

    if ([result rangeOfString:@"result=success"].location>0) {
        if ([self.delegate respondsToSelector:@selector(paymentSuccess:)]) {
            [self.delegate paymentSuccess:nav];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(paymentFail:)]) {
            [self.delegate paymentFail:nav];
        }
    }
}

-(void)doAlipay:(AlixPayOrder *)payOrder paymentType:(PaymentType *)paymentType navigationController:(UINavigationController *)navigationController{
    
    [SVProgressHUD dismiss];
    AppStatus *as = [AppStatus sharedInstance];
    NSString *baseUrl = as.webPageUrl;
    if ([baseUrl rangeOfString:@"http://test.shishangmao.cn"].location == 0) {
        baseUrl = [baseUrl substringWithRange:NSMakeRange(0, [baseUrl rangeOfString:@"http://test.shishangmao.cn"].location+ @"http://test.shishangmao.cn".length)];
    }
    
    if ([paymentType isALIAPPPay]) {
        payOrder.notifyURL = [[NSString stringWithFormat:@"%@/alipay/mobileNotifications", baseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *appScheme = @"styler";
        NSString* orderInfo = [payOrder description];
        NSString* signedStr = [self doRsa:orderInfo];
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        [AlixLibService payOrder:orderString
                       AndScheme:appScheme
                         seletor:@selector(paymentResultDelegate:)
                          target:self];
    }else if([paymentType isALIWEBPay]){
        NSString *urlTemplate = @"%@/alipay/alipayapi.jsp?WIDseller_email=caiwu@meilizhuanjia.cn&WIDout_trade_no=%@&WIDsubject=%@&WIDtotal_fee=%@";
        NSString *orderSubject = [payOrder.productName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [NSString stringWithFormat:urlTemplate, baseUrl, payOrder.tradeNO, orderSubject, payOrder.amount];
        NSLog(@"web apy url:%@", url);
        AlipayWebController *awc = [[AlipayWebController alloc] initWithUrl:url];
        [navigationController pushViewController:awc animated:YES];
    }
}

-(AlixPayOrder *) buildAlixPayOrderByHdcOrder:(HdcOrder *)hdcOrder{
    AlixPayOrder *payOrder = [AlixPayOrder new];
    payOrder.tradeNO = [hdcOrder getOutTradeNo];
    payOrder.productName = [hdcOrder getOutTradeTitle];
    payOrder.productDescription = payOrder.productName;
    payOrder.amount = [NSString stringWithFormat:@"%.2f", [hdcOrder getPaymentTotalAmount]];
    
    payOrder.partner = PartnerID;
    payOrder.seller = SellerID;
    payOrder.showUrl = @"http://www.shishangmao.cn";
    payOrder.returnUrl = @"styler.shishangmao.cn/paymentOver";
    return payOrder;
}

-(AlixPayOrder *) buildAlixPayOrderByUserHdc:(UserHdc *)userHdc{
    
    AlixPayOrder *payOrder = [AlixPayOrder new];
    payOrder.tradeNO = [userHdc getAlipayOutTradeNo];
    payOrder.productName = [userHdc getAlipayOutTradeTitle];
    payOrder.productDescription = payOrder.productName;
    payOrder.amount = [NSString stringWithFormat:@"%.2f", [userHdc getUserHdcPaymentTotalPrice]];
    return payOrder;
}



-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    [[AlipayProcessor sharedInstance] processPaymentResultFromApp:result nav:self.navigationController];
}


+ (AlipayProcessor *) sharedInstance{
    static AlipayProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[AlipayProcessor alloc] init];
    }
    
    return sharedInstance;
}



@end
