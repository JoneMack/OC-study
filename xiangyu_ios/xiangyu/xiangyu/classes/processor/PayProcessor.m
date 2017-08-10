//
//  PayProcessor.m
//  CrazyDoctor
//
//  Created by xubojoy on 16/6/27.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "PayProcessor.h"

#import "WXApi.h"
#import "AppDelegate.h"
//-------------------------------------------
//  支付类型的数据结构
//-------------------------------------------
@implementation PaymentType

-(id) initWithName:(NSString *)paymentTypeName paymentTypeIcon:(NSString *)paymentTypeIcon subName:(NSString *)subName{
    self = [super init];
    _paymentTypeName = paymentTypeName;
    _paymentTypeIcon = paymentTypeIcon;
    _subName = subName;
    return self;
}


-(BOOL) isTenPay{
    if ([self.paymentTypeName isEqualToString:TEN_PAYMENT]) {
        return YES;
    }
    return NO;
}

-(BOOL) isALIAPPPay{
    if ([self.paymentTypeName isEqualToString:ALI_APP_PAYMENT]) {
        return YES;
    }
    return NO;
}

@end

//-------------------------------------------
//  支付处理器
//-------------------------------------------

@implementation PayProcessor

/**
 *  获取支付方式
 */
-(NSMutableArray *) getPaymentTypes{
    if (self.paymentTypes == nil ) {
        self.paymentTypes = [[NSMutableArray alloc] init];
    }else{
        [self.paymentTypes removeAllObjects];
    }
    if ([WXApi isWXAppInstalled]) {
        PaymentType *paymentType = [[PaymentType alloc] initWithName:TEN_PAYMENT paymentTypeIcon:@"icon_wechat_payment" subName:@"推荐已安装微信客户端的用户使用"];
        [self.paymentTypes addObject:paymentType];
    }
    
    return self.paymentTypes;
}

/**
 *  获取默认的支付类型
 */
-(PaymentType *) getDefaultPaymentType{
    if (self.paymentTypes == nil) {
        [self getPaymentTypes];
    }
    return self.paymentTypes[0];
}

+(PayProcessor *) sharedInstance{
    static PayProcessor *sharedInstance = nil;
    if (sharedInstance == nil) {
        if (sharedInstance == nil) {
            sharedInstance = [PayProcessor new];
        }
    }
    return sharedInstance;
}

@end
