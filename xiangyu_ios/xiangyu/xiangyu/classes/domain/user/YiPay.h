//
//  YiPay.h
//  xiangyu
//
//  Created by 冯聪智 on 16/8/9.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol YiPay <NSObject>

@end

@interface YiPay : JSONModel


/**
 * 返回状态
 */
@property (nonatomic , strong) NSString<Optional> *status;

/**
 * 返回状态描述
 */
@property (nonatomic , strong) NSString<Optional> *statusdesc;

/**
 * 商户号
 */
@property (nonatomic , strong) NSString<Optional> *mid;

/**
 * 订单号
 */
@property (nonatomic , strong) NSString<Optional> *oid;

/**
 * 订单生成时间
 */
@property (nonatomic , strong) NSString<Optional> *orderdate;

/**
 * 商户名称
 */
@property (nonatomic , strong) NSString<Optional> *mername;

/**
 * 操作员编号
 */
@property (nonatomic , strong) NSString<Optional> *merdata;

/**
 * 订单金额
 */
@property (nonatomic , strong) NSString<Optional> *orderamount;

/**
 * 服务类型
 */
@property (nonatomic , strong) NSString<Optional> *servicetype;

/**
 * 数字签名
 */
@property (nonatomic , strong) NSString<Optional> *sign;

/**
 * 返回URL
 */
@property (nonatomic , strong) NSString<Optional> *url;

/**
 * 内部流水号
 */
@property (nonatomic , strong) NSString<Optional> *billNo;

@end
