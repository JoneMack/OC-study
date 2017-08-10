//
//  CityDistrict.h
//  iUser
//
//  Created by System Administrator on 13-4-8.
//  Copyright (c) 2013年 珠元玉睿ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "JSONModel.h"
#import "BusinessCircles.h"

@protocol CityDistrict
@end

@interface CityDistrict : JSONModel

@property (nonatomic, copy) NSString *name;
@property int expertCount;
@property (nonatomic, copy) NSArray<BusinessCircles> *businessCircles;

+(NSArray *) clearNoStylistDistrictAndBusinessCircles:(NSArray *)districts;
@end
