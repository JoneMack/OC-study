//
//  OrderServiceItem.m
//  styler
//
//  Created by System Administrator on 14-4-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderServiceItem.h"

@implementation OrderServiceItem

-(NSString *)getServiceOrderItemDescription{
    NSString *str= @"";
    for (ServiceCondition *condition in self.serviceConditions) {
        str  = [NSString stringWithFormat:@"%@%@",str,condition.value];
    }
    return str;
}

-(NSString *)getServiceOrderItemSpecialOfferDescription
{
    NSString *str= @"";
    int count = self.orderServiceItemSpecialOffers.count;
    for (int i = 0; i < count; i++) {
        OrderServiceItemSpecialOffer *specialOffer = self.orderServiceItemSpecialOffers[i];
        str  = [NSString stringWithFormat:@"%@%@",str,specialOffer.name];
        if (i < count - 1) {
            str = [NSString stringWithFormat:@"%@,",str];
        }
    }
    return str;
}
@end
