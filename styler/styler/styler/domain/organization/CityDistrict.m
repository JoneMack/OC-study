//
//  CityDistrict.m
//  iUser
//
//  Created by System Administrator on 13-4-8.
//  Copyright (c) 2013年 珠元玉睿ray. All rights reserved.
//


#import <ThirdFramework/jsonkit/JSONKit.h>
#import "CityDistrict.h"
#import "BusinessCircles.h"
#import "NSArray+JSONModel.h"
@implementation CityDistrict 

+ (NSArray *) clearNoStylistDistrictAndBusinessCircles:(NSArray *)districts{
    NSMutableArray *result  = [[NSMutableArray alloc] init];
    for (CityDistrict *district in districts) {
        if (district.expertCount > 0) {
            NSMutableArray *businessCirclesArr = [[NSMutableArray alloc] init];
            for (BusinessCircles *businessCircles in district.businessCircles) {
                if(businessCircles.expertCount > 0){
                    [businessCirclesArr addObject:businessCircles];
                }
            }
            district.businessCircles = (NSArray<BusinessCircles>*)businessCirclesArr;
            [result addObject:district];
        }
    }
    return result;
}



@end
