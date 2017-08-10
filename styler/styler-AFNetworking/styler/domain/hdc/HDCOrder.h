//
//  HDCOrder.h
//  styler
//
//  Created by wangwanggy820 on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHdc.h"

@protocol HdcOrder
@end

@interface HdcOrder : JSONModel
@property int id;
@property long long int createTime;
@property (assign, nonatomic) float totalPrice;
@property int hdcCount;
@property (nonatomic, strong) NSArray<UserHdc> *hdcOrderItems;

-(NSString *) getOutTradeNo;
-(NSString *) getOutTradeTitle;

-(float) getPaymentTotalAmount;
@end