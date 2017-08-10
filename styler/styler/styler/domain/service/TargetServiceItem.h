//
//  TargetServiceItem.h
//  styler
//
//  Created by wangwanggy820 on 14-3-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ServiceCondition.h"
#import "StylistSpecialOffer.h"

@protocol TargetServiceItem
@end

@interface TargetServiceItem : JSONModel

@property(copy, nonatomic) NSString *name;
@property int serviceTime;
@property(strong, nonatomic) NSArray<ServiceCondition> *serviceConditions;
@property int price;
@property int specialOfferPrice;
@property(strong, nonatomic) NSArray<StylistSpecialOffer, Optional> *specialOffers;

@end

