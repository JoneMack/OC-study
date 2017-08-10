//
//  HairDressingCard.m
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HairDressingCard.h"
#import "HdcType.h"


@implementation HairDressingCard

-(NSComparisonResult)compare:(HairDressingCard *)theCard hdcTypes:(NSArray *)hdcTypes{
    int cardHdcTypeInx = 0;
    int theCardHdcTypeInx = 0;
    
    for(int i = 0; i < hdcTypes.count; i++){
        HdcType *hdcType = (HdcType *)hdcTypes[i];
        if (hdcType.type == self.hdcType.type) {
            cardHdcTypeInx = i;
        }else if(hdcType.type == theCard.hdcType.type){
            theCardHdcTypeInx = i;
        }
    }
    
    if (cardHdcTypeInx > theCardHdcTypeInx) {
        return NSOrderedDescending;
    }else if(cardHdcTypeInx < theCardHdcTypeInx){
        return NSOrderedAscending;
    }
        
    if (self.specialOfferPrice > theCard.specialOfferPrice) {
        return NSOrderedDescending;
    }else if(self.specialOfferPrice < theCard.specialOfferPrice){
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

-(BOOL)isSuitableOrganization:(Organization *)org{
    for (NSNumber *orgId in self.saleRule.organizationIds)
    {
        if (orgId.intValue==org.id)
        {
            return YES;
        }
    }
    return false;
}

+(NSArray *) sortHdcs:(NSArray *)hdcs{
    NSMutableArray *result = [NSMutableArray new];
    for (NSObject *hdcObj in hdcs) {
        HairDressingCard *hdc = (HairDressingCard *)hdcObj;
        BOOL hasGroup = NO;
        for(NSObject *theHdcArray in result){
            HairDressingCard *theHdc = (HairDressingCard *)((NSArray *)theHdcArray)[0];
            if(theHdc.hdcType.type == hdc.hdcType.type){
                [((NSMutableArray *)theHdcArray) addObject:hdc];
                hasGroup = YES;
                break;
            }
        }
        if(!hasGroup){
            NSMutableArray *hdcGroup = [NSMutableArray new];
            [hdcGroup addObject:hdc];
            [result addObject:hdcGroup];
        }
    }
    return result;
}

+(NSArray *)getRecommendHdcs:(NSArray *)hdcs
{
    NSMutableArray *recommendHdcs = [[NSMutableArray alloc] init];
    for (NSObject *hdcObj in hdcs) {
        HairDressingCard *hdc = (HairDressingCard *)hdcObj;
        if (hdc.saleRule.recommendStatus == YES) {
            [recommendHdcs addObject:hdc];
        }
    }
    return recommendHdcs;
}

-(NSString *)specialOfferPriceTxt{
    int specialOfferPriceInt = (int)self.specialOfferPrice;
    NSString *specialOfferPriceTxt = [NSString stringWithFormat:@"￥%.0f", self.specialOfferPrice];
    if (self.specialOfferPrice > (float)specialOfferPriceInt) {
        specialOfferPriceTxt = [NSString stringWithFormat:@"￥%.2f", self.specialOfferPrice];
    }
    return specialOfferPriceTxt;
}

-(NSString *)expiredTimeString
{

    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:self.saleRule.endTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年M月d日";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;

}

@end
