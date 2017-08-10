//
//  SpecialOffer.m
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistSpecialOffer.h"

@implementation StylistSpecialOffer

-(BOOL) isDiscountSpecialOffer{
    return self.specialOfferType == specialoffer_type_discount;
}

//-(id)initWithJSONDictionary:(NSDictionary *)jsonDict
//{
//    self = [super init];
//    [self readFromJSONDictionary:jsonDict];
//    return self;
//}
//
//+(NSArray *)readFromJsonDictionayArray:(NSArray *)jsonDictArray
//{
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    for(NSDictionary *dic in jsonDictArray){
//        StylistSpecialOffer * sso = [[StylistSpecialOffer alloc] initWithJSONDictionary:dic];
//        [result addObject:sso];
//    }
//    return result;
//}
//
//-(void)readFromJSONDictionary:(NSDictionary *)jsonDict{
//    [self setDisplayName:[jsonDict objectForKey:@"displayName"]];
//    [self setDescription:[jsonDict objectForKey:@"description"]];
//
//    long long int startTime = [[jsonDict objectForKey:@"startTime"] longLongValue];
//    [self setStartTime:[NSDate dateWithTimeIntervalSince1970:startTime/1000]];
//    long long int endTime = [[jsonDict objectForKey:@"endTime"] longLongValue];
//    [self setEndTime: [NSDate dateWithTimeIntervalSince1970:endTime/1000]];
//    [self setSpecialOfferType:[[jsonDict objectForKey:@"specialOfferType"] intValue]];
//    
//    if ((NSNull *)[jsonDict objectForKey:@"originServiceItem"] != [NSNull null]) {
//        self.originServiceItem = [[SpecialOfferServiceItem alloc]
//                                  initWithJSONDictionary:[jsonDict objectForKey:@"originServiceItem"]];
//    }
//    if ((NSNull *)[jsonDict objectForKey:@"destinationServiceItem"] != [NSNull null]) {
//        self.destinationServiceItem = [[SpecialOfferServiceItem alloc]
//                                  initWithJSONDictionary:[jsonDict objectForKey:@"destinationServiceItem"]];
//    }
//    
//    long long int createTime = [[jsonDict objectForKey:@"ctreateTime"] longLongValue];
//    [self setCreateTime:[NSDate dateWithTimeIntervalSince1970:createTime/1000]];
//    [self setDiscount:[[jsonDict objectForKey:@"discount"] floatValue]];
//    [self setAmount:[[jsonDict objectForKey:@"reduce"] intValue]];
//}
//
//-(StylistSpecialOffer *) copyWithZone:(NSZone *)zone{
//    StylistSpecialOffer *stso = [[StylistSpecialOffer allocWithZone:zone] init];
//    stso.displayName = self.displayName;
//    stso.startTime = self.startTime;
//    stso.endTime = self.endTime;
//    stso.originServiceItem = self.originServiceItem;
//    stso.destinationServiceItem = self.destinationServiceItem;
//    stso.createTime = self.createTime;
//    
//    return stso;
//}

@end
