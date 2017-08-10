//
//  OrderServiceItem.h
//  styler
//
//  Created by System Administrator on 14-4-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceCondition.h"
#import "JSONModel.h"
#import "OrderServiceItemSpecialOffer.h"

@protocol OrderServiceItem
@end

@interface OrderServiceItem : JSONModel

@property int price;
@property int specialOfferPrice;
@property int serviceTime;
@property (nonatomic, copy) NSString *serviceItemName;
@property (nonatomic, strong) NSArray<ServiceCondition> *serviceConditions;
@property (nonatomic, strong) NSArray<OrderServiceItemSpecialOffer> *orderServiceItemSpecialOffers;
-(NSString *)getServiceOrderItemDescription;
-(NSString *)getServiceOrderItemSpecialOfferDescription;
@end
