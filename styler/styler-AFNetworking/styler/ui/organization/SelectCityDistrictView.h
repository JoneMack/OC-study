//
//  SelectCityDistrict.h
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrganizationFilter, SelectedCityDistrict , CityDistrict;


@protocol SelectCityDistrictViewDelegate <NSObject>

-(void) cityDistrictSelected:(CityDistrict *)cityDistrict;

@end

@interface SelectCityDistrictView : UIView <UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *cityDistrictsTableView;
@property (nonatomic, strong) OrganizationFilter *organizationFilter;
@property (nonatomic, strong) id<SelectCityDistrictViewDelegate> delegate;
@property (nonatomic, strong) CityDistrict *defaultCityDistrict;

-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter;

@end


@interface SelectCityDistrictCellView : UITableViewCell

@property (nonatomic, strong) UIView *remindView;
@property (nonatomic, strong) UIView *separatorLine;

-(id)initWithCityDistrictName:(NSString *)cityDistrictName reuseIdentifier:(NSString *)reuseIdentifier;

@end
