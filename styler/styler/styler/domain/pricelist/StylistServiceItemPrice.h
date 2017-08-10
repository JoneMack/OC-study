//
//  StylistServiceItemPrices.h
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceCondition.h"
#import "JSONModel.h"

@protocol StylistServiceItemPrice
@end

@interface StylistServiceItemPrice : JSONModel

@property(copy, nonatomic) NSString *serviceItemName;
@property(strong, nonatomic) NSArray<ServiceCondition> *serviceConditions;
@property int price;
@property int specialOfferPrice;


@end
