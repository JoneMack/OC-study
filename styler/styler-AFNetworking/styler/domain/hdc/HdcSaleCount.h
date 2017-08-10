//
//  HdcSaleCount.h
//  styler
//
//  Created by wangwanggy820 on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HdcSaleCount
@end

@interface HdcSaleCount : JSONModel

@property int hairDressingCardId;
@property int saleCount;
@property int realSaleCount;

@end


