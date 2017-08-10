//
//  WXPayResp.h
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  支付结果数据结构体
 */
@interface WXPayResp : NSObject

/** 财付通返回给商家的信息 */
@property (nonatomic, retain) NSString *returnKey;

@end
