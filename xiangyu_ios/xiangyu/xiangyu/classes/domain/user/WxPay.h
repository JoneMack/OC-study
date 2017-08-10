//
//  WxPay.h
//  xiangyu
//
//  Created by 冯聪智 on 16/8/9.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WxPay <NSObject>

@end

@interface WxPay : JSONModel


/**
 * 第三方用户唯一凭证
 */
@property (nonatomic , strong) NSString<Optional> *appid;

/** noncestr */
/**
 * 32位内的随机串，防重发
 */
@property (nonatomic , strong) NSString<Optional> *noncestr;
/**
 * 订单详情
 */
@property (nonatomic , strong) NSString<Optional> *packageValue;
/**
 * 商户号
 */
@property (nonatomic , strong) NSString<Optional> *partnerid;
/**
 * 预支付订单号
 */
@property (nonatomic , strong) NSString<Optional> *prepayid;
/**
 * 签名
 */
@property (nonatomic , strong) NSString<Optional> *sign;
/**
 * 时间戳
 */
@property (nonatomic , strong) NSString<Optional> *timestamp;



@end
