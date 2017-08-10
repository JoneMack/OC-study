//
//  HairDressingCard.m
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HairDressingCard.h"
#import "HdcType.h"
#import "HdcCatalog.h"


@implementation HairDressingCard

-(NSComparisonResult)compare:(HairDressingCard *)theCard hdcTypes:(NSArray *)hdcCatalogs{
    int cardHdcTypeInx = 0;
    int theCardHdcTypeInx = 0;
    
    for(int i = 0; i < hdcCatalogs.count; i++){
        HdcCatalog *hdcCatalog = (HdcCatalog *)hdcCatalogs[i];
        for (HdcType *hdcType in hdcCatalog.hdcTypes) {
            if (hdcType.type == self.hdcType.type) {
                cardHdcTypeInx = i;
            }else if(hdcType.type == theCard.hdcType.type){
                theCardHdcTypeInx = i;
            }
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

+(NSArray *) sortHdcs:(NSArray *)hdcs hdcCatalogs:(NSArray *)hdcCatalogs{
    NSMutableArray *result = [NSMutableArray new];
    for (HdcCatalog *hdcCatalog in hdcCatalogs) {
        NSMutableArray *group = [NSMutableArray new];
        for (HdcType *theHdcType in hdcCatalog.hdcTypes) {
            for (HairDressingCard *hdc in hdcs) {
                if ([theHdcType.name isEqualToString:hdc.hdcType.name]) {
                    [group addObject:hdc];
                }
            }
        }
        if (group.count > 0) {
            [result addObject:group];
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
