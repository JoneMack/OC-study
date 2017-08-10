//
//  WXPayReq.h
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
@class WXPrePay;

/**
 *  支付请求数据结构体
 */

@interface WXPayReq : BaseReq

/** 商家向财付通申请的商家 id */
@property (nonatomic, retain) NSString *partnerId;
/** 预支付订单 */
@property (nonatomic, retain) NSString *prepayId;
/** 随机串,防重发 */
@property (nonatomic, retain) NSString *nonceStr;
/** 时间戳,防重发 */
@property (nonatomic, assign) UInt32 timeStamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, retain) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, retain) NSString *sign;

-(id) initWithWXPrePay:(WXPrePay *)wxprePay;

@end
