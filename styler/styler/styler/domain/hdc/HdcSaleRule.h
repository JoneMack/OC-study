//
//  SaleRule.h
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HdcSaleRule
@end

@interface HdcSaleRule : JSONModel

@property int hairDressingCardId;
@property long long int startTime;
@property long long int endTime;
@property int singleMaxBuy;
@property BOOL recommendStatus;
@property BOOL saleStatus;
@property (nonatomic,strong)NSArray *organizationIds;
@property (nonatomic,strong)NSArray *stylistIds;


@end
