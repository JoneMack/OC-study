//
//  OrganizationFilter.m
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationFilter.h"
#import "CityDistrict.h"
#import "HdcCatalog.h"

@implementation OrganizationFilter

-(void) setSelectedBusinessCircleName:(NSString *)businessCircle{
    if (self.clickedCityDistricts != nil && self.clickedCityDistricts.count > 0) {
        self.selectedCityDistrictName = [self.clickedCityDistricts lastObject];
        [self.clickedCityDistricts removeAllObjects];
    }
    
    _selectedBusinessCircleName = businessCircle;
}

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

-(NSArray *) getHdcTypesByHdcCatalogName:(NSString *)hdcCatalogName{
    if (self.hdcCatalogs == nil || self.hdcCatalogs.count == 0) {
        return [[NSArray alloc] init];
    }
    for (int i=0; i<self.hdcCatalogs.count; i++) {
        if ([[self.hdcCatalogs[i] name] isEqualToString:hdcCatalogName]) {
            HdcCatalog *temp = self.hdcCatalogs[i];
            return temp.hdcTypes;
        }
    }
    return [[NSArray alloc] init];
}

-(id)init{
    self = [super init];
    self.pageNo = 1;
    self.pageSize = 10;
    if(self.selectedBusinessCircleId == 0){
        self.selectedBusinessCircleName = @"附近";
        self.selectedCityDistrictName = @"附近";
        self.selectedHdcCatalogName = @"全部";
        self.selectedHdcTypeName = @"全部";
    }
    return self;
}

-(id) initWithSelectedBusinessCircle:(NSString *)selectedCityDistrictName selectedBusinessCircleId:(int)selectedBusinessCircleId selectedBusinessCircleName:(NSString *)selectedBusinessCircleName{
    self = [super init];
    _pageNo = 1;
    _pageSize = 10;
    _selectedCityDistrictName = selectedCityDistrictName;
    _selectedBusinessCircleId = selectedBusinessCircleId;
    _selectedBusinessCircleName = selectedBusinessCircleName;
    self.selectedHdcCatalogName = @"全部";
    self.selectedHdcTypeName = @"全部";
    return self;
}

-(id) initWithSelectedHdcType:(NSString *)selectedHdcCatalogName selectedHdcTypeId:(int)selectedHdcTypeId selectedHdcTypeName:(NSString *)selectedHdcTypeName{
    self = [super init];
    _pageNo = 1;
    _pageSize = 10;
    _selectedHdcCatalogName = selectedHdcCatalogName;
    _selectedHdcTypeId = selectedHdcTypeId;
    _selectedHdcTypeName = selectedHdcTypeName;
    
    self.selectedBusinessCircleName = @"附近";
    self.selectedCityDistrictName = @"附近";
    return self;
}

@end

