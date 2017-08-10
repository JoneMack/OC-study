//
//  StylistPriceList.h
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StylistSpecialOffer.h"
#import "StylistServiceItem.h"

@interface StylistPriceList : JSONModel

@property(strong, nonatomic)NSArray<StylistSpecialOffer, Optional> *specialOffers;
@property(strong, nonatomic)NSArray<StylistServiceItem, Optional> *stylistServiceItems;

-(float) minDiscount;
-(NSArray *)discountSpecialOffers;
-(NSArray *)rewardSpecialOffers;
-(void)cleanNoSupportServiceItem;

/**
 * 根据优惠获得通用文本条目数组
 */
-(NSArray *) getSpecialOffersCommonItemTxtArray;
@end
