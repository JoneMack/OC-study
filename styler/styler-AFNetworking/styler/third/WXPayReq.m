//
//  WXPayReq.m
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WXPayReq.h"
#import "WXPrePay.h"

@implementation WXPayReq

-(id) initWithWXPrePay:(WXPrePay *)wxprePay{
    
    self = [super init];
    self.partnerId = wxprePay.partnerid;
    self.prepayId = wxprePay.prepayid;
    self.package = wxprePay.package;
    self.nonceStr = wxprePay.noncestr;
    self.timeStamp = wxprePay.timestamp;
    self.sign = wxprePay.sign;
    
    return self;
}

@end
