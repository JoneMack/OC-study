//
//  OrganizationFilter.h
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HdcCatalog.h"


@interface OrganizationFilter : NSObject

@property (nonatomic, strong) NSString *brandName;
@property int orderType;

//@property (nonatomic, strong) NSArray *hdcTypes;
@property (nonatomic, strong) NSArray *hdcCatalogs;
@property (nonatomic, strong) NSString *selectedHdcCatalogName;
@property int selectedHdcTypeId;
@property (nonatomic, strong) NSString *selectedHdcTypeName;
//@property int selectedHdcTypeValue;
@property (nonatomic, strong) HdcCatalog *clickedHdcCatalog; // 用于临时存储用户选择美发卡类别的操作过程.

@property (nonatomic, strong) NSArray *allCityDistricts;
@property (nonatomic, strong) NSString *selectedCityDistrictName;
@property int selectedCityDistrictRowId;
@property (nonatomic, strong) NSString *selectedBusinessCircleName;
@property int selectedBusinessCircleId;
@property (nonatomic, strong) NSMutableArray *clickedCityDistricts;  // 用于临时存储用户选择城区的操作过程，选择完商圈后，只取临时城区队列里最后一个

@property (nonatomic, strong) NSString *selectedOrderTypeName;
@property (nonatomic, strong) NSString *selectedOrderTypeValue;

@property int pageSize;
@property int pageNo;




-(id) initWithSelectedBusinessCircle:(NSString *)selectedCityDistrictName
            selectedBusinessCircleId:(int)selectedBusinessCircleId
          selectedBusinessCircleName:(NSString *)selectedBusinessCircleName;


-(id) initWithSelectedHdcType:(NSString *)selectedHdcCatalogName
            selectedHdcTypeId:(int)selectedHdcTypeId
          selectedHdcTypeName:(NSString *)selectedHdcTypeName;

-(void) setSelectedBusinessCircleName:(NSString *)setSelectedBusinessCircleName;

/**
 *  获取当前城区下的所有商圈
 */
-(NSArray *) getBusinessCirclesByCityDistrictName:(NSString *)cityDistrictName;

/**
 *  获取当前美发卡类别的美发卡类型
 */
-(NSArray *) getHdcTypesByHdcCatalogName:(NSString *)hdcCategoryName;

@end


