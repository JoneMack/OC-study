//
//  StylistServiceItem.m
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistServiceItem.h"

@implementation StylistServiceItem

-(int)minPriceIndex{
    int result = 0;
    int minPrice = [(StylistServiceItemPrice *)self.serviceItemPrices[0] specialOfferPrice];
    for (int i = 0; i < self.serviceItemPrices.count; i++) {
        StylistServiceItemPrice *serviceItemPrice = (StylistServiceItemPrice *)self.serviceItemPrices[i];
        if ([serviceItemPrice specialOfferPrice] < minPrice) {
            minPrice = serviceItemPrice.specialOfferPrice;
            result = i;
        }
    }
    return result;
}

@end
