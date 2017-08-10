//
//  CityStore.m
//  iUser
//
//  Created by System Administrator on 13-4-8.
//  Copyright (c) 2013年 珠元玉睿ray. All rights reserved.
//

#import "Store.h"
#import "CityDistrict.h"
#import "BusinessCircles.h"
#import "CityStore.h"
@implementation CityStore

+ (CityStore *) sharedStore
{
    static CityStore *cityStore = nil;
    if(!cityStore){
        cityStore = [[CityStore alloc] init];
    }
    
    return cityStore;
}

- (void) getCityDistrictList:(void (^)(NSArray *, NSError *)) block
                    cityName:(NSString *)cityName{
    NSString *urlStr = [NSString stringWithFormat:@"/city/%@/cityDistricts", cityName];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        NSArray *dictArray = [json objectFromJSONString];
        NSArray<CityDistrict> *districts  = (NSArray<CityDistrict>*)[CityDistrict arrayOfModelsFromDictionaries:dictArray];
        block(districts, nil);
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void) getBusinessCirclesByHdcTypeName:(void(^)(NSArray *cityDistricts, NSError *error))completionBlock
                            hdcTypeName:(NSString *)hdcTypeName{
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *urlStr = [NSString stringWithFormat:@"/businessCircles/hasHDCs"];
    if (![hdcTypeName isEqualToString:@"全部"]) {
        urlStr = [NSString stringWithFormat:@"%@?hdcTypeName=%@" , urlStr , hdcTypeName];
    }
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@">>>根据美发卡名称查商圈:%@" , urlStr);
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        
        NSArray *dictArray = [json objectFromJSONString];
        NSArray<CityDistrict> *districts  = (NSArray<CityDistrict>*)[CityDistrict arrayOfModelsFromDictionaries:dictArray];
        completionBlock(districts, nil);
        
    } refresh:YES useCacheIfNetworkFail:YES];
}

@end
