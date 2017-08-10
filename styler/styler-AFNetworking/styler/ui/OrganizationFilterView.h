//
//  OrganizationFilterView.h
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define organization_filter_menu_height        33
#define menu_item_label_margin_with_arrow      0
#define down_arrow_icon_width                  23
#define down_arrow_icon_height                 20


#define menu_item_hdc_type                     0
#define menu_item_business_circle              1
#define menu_item_order_type                   2


#import <UIKit/UIKit.h>
#import "SelectHdcTypeView.h"
#import "OrganizationFilter.h"
#import "SelectCityDistrictView.h"
#import "SelectBusinessCircleView.h"
#import "SelectSpecialOfferListOrderTypeView.h"



@protocol OrganizationFilterViewDelegate <NSObject>

@optional
-(void) organizationFilterConditionChanged;

@end



@interface OrganizationFilterView : UIView <SelectHdcTypeViewDelegate ,
                                            SelectCityDistrictViewDelegate ,
                                            SelectBusinessCircleViewDelegate ,
                                            SpecialOfferListOrderTypeDelegate>


@property (nonatomic, strong) OrganizationFilter *organizationFilter;
@property (nonatomic, strong) SelectHdcTypeView *selectHdcTypeView;
@property (nonatomic, strong) SelectCityDistrictView *selectCityDistrictView;
@property (nonatomic, strong) SelectBusinessCircleView *selectBusinessCircleView;
@property (nonatomic, strong) SelectSpecialOfferListOrderTypeView *selectSpecialOfferListOrderTypeView;
@property (nonatomic, strong) id<OrganizationFilterViewDelegate> delegate;


-(id) initWithOrganizationFilter:(OrganizationFilter *) organizationFilter;


@end
