//
//  OrganizationFilter.m
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationFilter.h"
#import "CityDistrict.h"

@implementation OrganizationFilter

-(void) setSelectedBusinessCircleName:(NSString *)businessCircle{
    if (self.clickedCityDistricts != nil && self.clickedCityDistricts.count > 0) {
        self.selectedCityDistrictName = [self.clickedCityDistricts lastObject];
        [self.clickedCityDistricts removeAllObjects];
    }
    
    _selectedBusinessCircleName = businessCircle;
}

//-(void) clearClickedCityDistricts{
//    if (self.clickedCityDistricts == nil || self.clickedCityDistricts.count == 0) {
//        self.clickedCityDistricts = [[NSMutableArray alloc] init];
//        return;
//    }
//    [self.clickedCityDistricts removeAllObjects];  // 这个地方有问题
//    if ([NSStringUtils isNotBlank:self.selectedCityDistrictName]) {
//        [self.clickedCityDistricts addObject:self.selectedCityDistrictName];
//    }
//    
//}


-(NSArray *) getBusinessCirclesByCityDistrictName:(NSString *)cityDistrictName{
    if (self.allCityDistricts == nil || self.allCityDistricts.count == 0) {
        return [[NSArray alloc] init] ;
    }
    for (int i=0; i<self.allCityDistricts.count; i++) {
        if([[self.allCityDistricts[i] name] isEqualToString:cityDistrictName]){
            CityDistrict *cityDistrict = self.allCityDistricts[i];
            return cityDistrict.businessCircles;
        }
    }
    return [[NSArray alloc] init] ;
}

-(id)init{
    self = [super init];
    self.pageNo = 1;
    self.pageSize = 10;
    self.selectedBusinessCircleName = @"附近";
    self.selectedCityDistrictName = @"附近";
    return self;
}

@end

