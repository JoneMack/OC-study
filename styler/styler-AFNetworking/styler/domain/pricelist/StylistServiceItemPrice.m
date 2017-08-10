//
//  StylistServiceItemPrices.m
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistServiceItemPrice.h"

@implementation StylistServiceItemPrice

//-(void)readFromJSONDictionary:(NSDictionary *)jsonDict{
//    self.serviceItemName = [jsonDict objectForKey:@"serviceItemName"];
//    self.price = [[jsonDict objectForKey:@"price"] intValue];
//    self.specialOfferPrice = [[jsonDict objectForKey:@"specialOfferPrice"] intValue];
//    NSArray * array = [jsonDict objectForKey:@"serviceConditions"];
//    if ((NSNull *)array != [NSNull null] && array.count > 0) {
//        self.serviceConditions = [ServiceCondition readFromJsonDictionayArray:array];
//    }
//}
//
//-(id)initWithJSONDictionary:(NSDictionary *)jsonDict
//{
//    self = [super init];
//    [self readFromJSONDictionary:jsonDict];
//    return self;
//}
//
//+(NSArray *) readFromJsonDictionayArray:(NSArray *)jsonDictArray
//{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in jsonDictArray) {
//        StylistServiceItemPrice *price = [[StylistServiceItemPrice alloc] initWithJSONDictionary:dic];
//        [array addObject:price];
//    }
//    return array;
//}

@end
