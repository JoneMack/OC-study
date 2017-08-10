//
//  StylistPriceList.m
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistPriceList.h"
#import "CommonItemTxt.h"

@implementation StylistPriceList

//该方法将优惠进行分组，对于优惠类分组按照优惠折扣率进行分组、对于赠送类优惠按照赠送的目标优惠服务项目分组
//减价类优惠暂不分组即独立显示
-(NSArray *) getSpecialOffersCommonItemTxtArray
{
    NSMutableArray *commonItemTxtArray = [NSMutableArray array];
    
    for (StylistSpecialOffer *specialOffer in self.specialOffers) {
        if (specialOffer.specialOfferType == specialoffer_type_discount) {
            [self addDiscountSpecialOffer:commonItemTxtArray specialOffer:specialOffer];
        }else if(specialOffer.specialOfferType == specialoffer_type_reward){
            [self addRewardSpecialOffer:commonItemTxtArray specialOffer:specialOffer];
        }else if(specialOffer.specialOfferType == specialoffer_type_reduce){
            [self addReduceSpecialOffer:commonItemTxtArray specialOffer:specialOffer];
        }
    }
    
    return commonItemTxtArray;
}

-(void) addDiscountSpecialOffer:(NSMutableArray *)commonItemTxtArray specialOffer:(StylistSpecialOffer *)specialOffer
{
    for (CommonItemTxt *itemTxt in commonItemTxtArray) {
        if ([itemTxt.title isEqualToString:specialOffer.name]) {
            itemTxt.content = [NSString stringWithFormat:@"%@\n%@::%@", itemTxt.content, specialOffer.originServiceItem.name, specialOffer.description];
            return ;
        }
    }
    
    CommonItemTxt *itemTxt = [CommonItemTxt new];
    itemTxt.title = specialOffer.name;
    itemTxt.content = [NSString stringWithFormat:@"%@::%@", specialOffer.originServiceItem.name, specialOffer.description];
    [commonItemTxtArray addObject:itemTxt];
}

-(void) addRewardSpecialOffer:(NSMutableArray *)commonItemTxtArray specialOffer:(StylistSpecialOffer *)specialOffer
{
    for (CommonItemTxt *itemTxt in commonItemTxtArray) {
        if ([itemTxt.title isEqualToString:specialOffer.name]) {
            if (specialOffer.discount > 0) {
                itemTxt.content = [NSString stringWithFormat:@"%@\n%@::%@", itemTxt.content, specialOffer.destinationServiceItem.name, specialOffer.description];
            }else{
                itemTxt.content = [NSString stringWithFormat:@"%@\n%@::%@", itemTxt.content, specialOffer.originServiceItem.name, specialOffer.description];
            }
            return ;
        }
    }
    
    CommonItemTxt *itemTxt = [CommonItemTxt new];
    itemTxt.title = specialOffer.name;
    if (specialOffer.discount > 0) {
        itemTxt.content = [NSString stringWithFormat:@"%@::%@", specialOffer.destinationServiceItem.name, specialOffer.description];
    }else{
        itemTxt.content = [NSString stringWithFormat:@"%@::%@", specialOffer.originServiceItem.name, specialOffer.description];
    }
    [commonItemTxtArray addObject:itemTxt];
}

-(void) addReduceSpecialOffer:(NSMutableArray *)commonItemTxtArray specialOffer:(StylistSpecialOffer *)specialOffer
{
    CommonItemTxt *itemTxt = [CommonItemTxt new];
    itemTxt.title = specialOffer.name;
    itemTxt.content = [NSString stringWithFormat:@"%@::%@", specialOffer.originServiceItem.name, specialOffer.description];
    [commonItemTxtArray addObject:itemTxt];
}

-(void)cleanNoSupportServiceItem{
    NSMutableArray *serviceItems = [[NSMutableArray alloc] init];
    for (StylistServiceItem *serviceItem in self.stylistServiceItems) {
        if (serviceItem.defaultProvide) {
            [serviceItems addObject:serviceItem];
        }
    }
    self.stylistServiceItems = (NSArray<StylistServiceItem, Optional>*)serviceItems;
}

-(NSArray *) discountSpecialOffers{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(StylistSpecialOffer *specialOffer in self.specialOffers){
        if ([specialOffer isDiscountSpecialOffer]) {
            [result addObject:specialOffer];
        }
    }
    return result;
}

-(float) minDiscount{
    float minDiscount = 1;
    for (StylistSpecialOffer *specialOffer in self.specialOffers) {
        if (specialOffer.specialOfferType == specialoffer_type_discount
            && specialOffer.discount < minDiscount) {
            minDiscount = specialOffer.discount;
        }
    }
    return minDiscount;
}

-(NSArray *)rewardSpecialOffers{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(StylistSpecialOffer *specialOffer in self.specialOffers){
        if (specialOffer.specialOfferType == specialoffer_type_reward) {
            [result addObject:specialOffer];
        }
    }
    return result;
}

@end
