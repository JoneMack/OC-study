//
//  AliPay.h
//  xiangyu
//
//  Created by 冯聪智 on 16/8/9.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AliPay <NSObject>

@end

@interface AliPay : JSONModel



/**
 * 接口名称
 */
@property (nonatomic , strong) NSString<Optional> *service;

/**
 * 合作者身份ID
 */
@property (nonatomic , strong) NSString<Optional> *partner;

/**
 * 编码字符集
 */
@property (nonatomic , strong) NSString<Optional> *_input_charset;

/**
 * 服务器异步通知页面路径
 */
@property (nonatomic , strong) NSString<Optional> *notify_url;

/**
 * 商户网站唯一订单号
 */
@property (nonatomic , strong) NSString<Optional> *out_trade_no;

/**
 * 商品名称
 */
@property (nonatomic , strong) NSString<Optional> *subject;
/**
 * 商品描述
 */
@property (nonatomic , strong) NSString<Optional> *body;

/**
 * 支付类型
 */
@property (nonatomic , strong) NSString<Optional> *payment_type;

/**
 * 卖家支付宝账号
 */
@property (nonatomic , strong) NSString<Optional> *seller_id;

/**
 * 交易金额
 */
@property (nonatomic , strong) NSString<Optional> *total_fee;


/**
 * 签名
 */
@property (nonatomic , strong) NSString<Optional> *sign;
/**
 * 签名方式
 */
@property (nonatomic , strong) NSString<Optional> *sign_type;


@property (nonatomic , strong) NSString<Optional> *return_url;


@end
