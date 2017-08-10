//
//  SpecialOffer.h
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecialOfferServiceItem.h"
#import "JSONModel.h"

#define specialoffer_type_reward   1
#define specialoffer_type_discount 2
#define specialoffer_type_reduce   3

@protocol StylistSpecialOffer
@end

@interface StylistSpecialOffer : JSONModel

@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *displayName;
@property(copy, nonatomic) NSString<Optional> *description;
@property(assign, nonatomic) long long int startTime;
@property(assign, nonatomic) long long int endTime;
@property(strong, nonatomic) SpecialOfferServiceItem *originServiceItem;
@property(strong, nonatomic) SpecialOfferServiceItem<Optional> *destinationServiceItem;
@property float discount;
@property float amount;
@property int specialOfferType;

-(BOOL) isDiscountSpecialOffer;

@end
