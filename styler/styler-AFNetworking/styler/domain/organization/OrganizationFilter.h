//
//  OrganizationFilter.h
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrganizationFilter : NSObject

@property (nonatomic, strong) NSString *brandName;
@property int orderType;

@property (nonatomic, strong) NSArray *hdcTypes;
@property (nonatomic, strong) NSArray *allCityDistricts;

@property (nonatomic, strong) NSString *selectedHdcTypeName;
@property int selectedHdcTypeValue;

@property (nonatomic, strong) NSString *selectedCityDistrictName;
@property int selectedCityDistrictRowId;
@property (nonatomic, strong) NSString *selectedBusinessCircleName;

@property (nonatomic, strong) NSString *selectedOrderTypeName;
@property (nonatomic, strong) NSString *selectedOrderTypeValue;

@property int pageSize;
@property int pageNo;


@property (nonatomic, strong) NSMutableArray *clickedCityDistricts;  // 用于临时存储用户选择城区的操作过程，选择完商圈后，只取城区队列里最后一个

-(void) setSelectedBusinessCircleName:(NSString *)setSelectedBusinessCircleName;

-(NSArray *) getBusinessCirclesByCityDistrictName:(NSString *)cityDistrictName;

//-(void) clearClickedCityDistricts;

@end


