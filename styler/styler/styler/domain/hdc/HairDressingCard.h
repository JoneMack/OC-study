//
//  HairDressingCard.h
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HdcType.h"
#import "HdcSaleRule.h"
#import "HdcSaleCount.h"
#import "Organization.h"
#import "RedEnvelope.h"

@protocol HairDressingCard
@end
@interface HairDressingCard : JSONModel

@property int id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString<Optional> *description;
@property int price;
@property (nonatomic, assign) float specialOfferPrice;
@property (nonatomic, copy) NSString<Optional> *discount;
@property (nonatomic, copy) NSString<Optional> *specialOfferDescription;
@property (nonatomic, copy) NSNumber<Optional> *expiredTime;
@property (nonatomic, copy) NSString<Optional> *iconUrl;
@property (nonatomic, strong) HdcType<Optional> *hdcType;
@property (nonatomic, strong) HdcSaleRule<Optional> *saleRule;
@property (nonatomic, strong) HdcSaleCount<Optional> *saleCount;
@property (nonatomic, copy) RedEnvelope<Optional> *redEnvelope;
@property int hdcSaleStatus;

-(BOOL)isSuitableOrganization:(Organization *)org;

//对美发卡按照美发卡类型进行分组
+(NSArray *)sortHdcs:(NSArray *)hdcs hdcCatalogs:(NSArray *)hdcCatalogs;

+(NSArray *)getRecommendHdcs:(NSArray *)hdcs;

-(NSString *)specialOfferPriceTxt;

-(NSString *)expiredTimeString;

-(NSComparisonResult)compare:(HairDressingCard *)theCard hdcTypes:(NSArray *)hdcTypes;

@end
