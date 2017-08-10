//
//  CityStore.h
//  iUser
//
//  Created by System Administrator on 13-4-8.
//  Copyright (c) 2013年 珠元玉睿ray. All rights reserved.
//


#import "JSONKit.h"
@interface CityStore : NSObject

+ (CityStore *) sharedStore;

- (void) getCityDistrictList:(void (^)(NSArray *districts, NSError *err)) block
                    cityName:(NSString *)cityName;


+(void) getBusinessCirclesByHdcTypeName:(void(^)(NSArray *cityDistricts, NSError *error))completionBlock
                            hdcTypeName:(NSString *)hdcTypeName;



@end
