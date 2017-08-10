//
//  OrganizationFilterView.m
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationFilterView.h"
#import "UIImage+imagePlus.h"
#import "NSStringUtils.h"
#import "CityStore.h"
#import "HdcStore.h"
#import "CityDistrict.h"
#import "UILabel+Custom.h"

@implementation OrganizationFilterView
{
    NSMutableArray *menuItems;
    NSArray *itemNames;
    NSMutableArray *downArrows;
    NSMutableArray *upArrows;
    float menuItemWidth;
    NSArray *allHdcCatalogs;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id) initWithOrganizationFilter:(OrganizationFilter *) organizationFilter{
    if (self = [super init]) {
        [self initMenuBar:organizationFilter];
        [self initSelectHdcTypesView];
        [self initSelectBusinessCircleView];
        [self initSpecialOfferOrderTypeView];
        [self loadData];
    }
    return self;
}

#pragma mark 初始化菜单栏
-(void) initMenuBar:(OrganizationFilter *) organizationFilter{
    self.organizationFilter = organizationFilter;
    menuItems = [[NSMutableArray alloc] init];
    downArrows = [[NSMutableArray alloc] init];
    upArrows = [[NSMutableArray alloc] init];
    NSString *displayHdcTypeName = [NSStringUtils isNotBlank:self.organizationFilter.selectedHdcTypeName]?
    self.organizationFilter.selectedHdcTypeName:@"全部";
    NSString *displayBusinessCircleName = [NSStringUtils isNotBlank:self.organizationFilter.selectedBusinessCircleName]?self.organizationFilter.selectedBusinessCircleName : @"附近";
    itemNames = [NSArray arrayWithObjects:displayHdcTypeName , displayBusinessCircleName , @"推荐排序", nil];
    menuItemWidth = screen_width/itemNames.count;
    for (int i=0 ; i < itemNames.count ; i++) {
        // 按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:itemNames[i] forState:UIControlStateNormal];
        [button setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:default_2_font_size]];
        button.tag = i;
        CGRect frame = CGRectMake(i*menuItemWidth, 0 , menuItemWidth, organization_filter_menu_height);
        button.frame = frame;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [self addSubview:button];
        
        // 获取按钮中文本的长度
        float titleLabelWidth = [button titleLabel].realWidth;
        float titleLabelHeight = [button titleLabel].frame.size.height;
        
        // 设置向下的箭头
        UIImageView *downArrowIcon = [[UIImageView alloc] init];
        [downArrowIcon setImage:[UIImage imageNamed:@"abel_down_icon"]];
        float downArrowIconX = i*menuItemWidth + (titleLabelWidth+ menuItemWidth)/2+ menu_item_label_margin_with_arrow;
        float downArrowIconY = titleLabelHeight/itemNames.count;
        frame = CGRectMake(downArrowIconX, downArrowIconY, down_arrow_icon_width, down_arrow_icon_height);
        downArrowIcon.frame = frame;
        [self addSubview:downArrowIcon];
        [downArrows addObject:downArrowIcon];
        
        // 设置边线
        UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(i*menuItemWidth, 0, splite_line_height, organization_filter_menu_height)];
        downSpeliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [self addSubview:downSpeliteLine];
        
        // 判断是否是从品牌过来的，如果是从品牌过来的，则第二个按钮变灰禁用。
        if (i==1 && ![NSStringUtils isBlank:self.organizationFilter.brandName]) {
            [button setEnabled:NO];
            button.alpha = 0.4;
            downArrowIcon.alpha = 0.4;
        }else{
            [button addTarget:self action:@selector(didSelectedSegment:) forControlEvents:UIControlEventTouchUpInside];
        }
        [menuItems addObject:button];
        [self handleMenuItemContent:itemNames[i] location:i];
    }
    
    // 设置底部的线
    UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, organization_filter_menu_height, screen_width, splite_line_height)];
    downSpeliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self addSubview:downSpeliteLine];
    
    // 设置向上的箭头
    for (int i=0 ; i < itemNames.count ; i++) {
        UIImageView *currentSelected = [[UIImageView alloc] init];
        [currentSelected setImage:[UIImage imageNamed:@"up_arrow"]];
        float start = i*menuItemWidth + menuItemWidth/2+ menu_item_label_margin_with_arrow-10;
        CGRect frame = CGRectMake(start, organization_filter_menu_height-2.5, 13, 3);
        currentSelected.frame = frame;
        currentSelected.hidden=YES;
        [self addSubview:currentSelected];
        [upArrows addObject:currentSelected];
    }
}

#pragma mark 选择美发卡类型列表的初始化
-(void) initSelectHdcTypesView{
    // 美发卡类别
    self.selectHdcCatalogView = [[SelectHdcCatalogView alloc] initWithOrganizationFilter:self.organizationFilter];
    self.selectHdcCatalogView.frame = CGRectMake(0, organization_filter_menu_height+0.5, self.selectHdcCatalogView.frame.size.width, 491);
    self.selectHdcCatalogView.delegate = self;
    self.selectHdcCatalogView.hidden = YES;
    [self addSubview:self.selectHdcCatalogView];
    
    // 美发卡类型
    self.selectHdcTypeView = [[SelectHdcTypeView alloc] initWithOrganizationFilter:self.organizationFilter];
    self.selectHdcTypeView.frame = CGRectMake(self.selectHdcCatalogView.frame.size.width, organization_filter_menu_height+0.5,self.selectHdcTypeView.frame.size.width, 491);
    self.selectHdcTypeView.hidden = YES;
    self.selectHdcTypeView.delegate = self;
    [self addSubview:self.selectHdcTypeView];

}

#pragma mark 选择了美发卡类别的代理
-(void) hdcCatalogSelected:(HdcCatalog *)hdcCatalog{
    
    if (hdcCatalog == nil || [hdcCatalog.name isEqualToString:@"全部"]) {
        
        self.selectHdcCatalogView.hidden = YES;
        self.selectHdcTypeView.hidden = YES;
        [self.superview sendSubviewToBack:self];
        // 处理菜单的新文本
        [self handleCurrentViewStatus:menu_item_hdc_type content:hdcCatalog.name];
        
        if(hdcCatalog == nil || [hdcCatalog.name isEqualToString:self.organizationFilter.selectedHdcTypeName]){
            self.organizationFilter.clickedHdcCatalog = nil;
            return;
        }
        
        [self.organizationFilter setSelectedHdcTypeId:0];
        [self.organizationFilter setSelectedHdcTypeName:hdcCatalog.name];
        [self.organizationFilter setSelectedHdcCatalogName:hdcCatalog.name];
        [self.organizationFilter setClickedHdcCatalog:hdcCatalog];
        
        // 先查商圈  // 再查商户  // 再查美发卡
        [CityStore getBusinessCirclesByHdcTypeName:^(NSArray *cityDistricts, NSError *error) {
            self.organizationFilter.allCityDistricts = cityDistricts;
            // 通知代理
            if([self.delegate respondsToSelector:@selector(organizationFilterConditionChanged)]){
                [self.delegate organizationFilterConditionChanged];
            }
            
        } hdcTypeName:hdcCatalog.name];
        
    }
    
    [self.organizationFilter setClickedHdcCatalog:hdcCatalog];
    [self.selectHdcTypeView reloadHdcTypes];
}

#pragma mark 选择美发卡类型列表的代理
-(void) hdcTypeSelected:(HdcType *)hdcType{ 
    
    self.selectHdcTypeView.hidden = YES;
    self.selectHdcCatalogView.hidden = YES;
    [self.superview sendSubviewToBack:self];
    // 处理菜单的新文本
    [self handleCurrentViewStatus:menu_item_hdc_type content:hdcType.name];
    
    // 如果这次选的和上次选的是一样的数据，则不进行再查询
    if (hdcType==nil || hdcType.type == self.organizationFilter.selectedHdcTypeId) {
        return;
    }
    
    // 保存新的选择
    self.organizationFilter.selectedHdcTypeName = hdcType.name;
    self.organizationFilter.selectedHdcTypeId = hdcType.type;
    if (self.organizationFilter.clickedHdcCatalog) {
        self.organizationFilter.selectedHdcCatalogName = self.organizationFilter.clickedHdcCatalog.name;
        self.organizationFilter.clickedHdcCatalog = self.organizationFilter.clickedHdcCatalog;
    }
    
    // 先查商圈  // 再查商户  // 再查美发卡
    [CityStore getBusinessCirclesByHdcTypeName:^(NSArray *cityDistricts, NSError *error) {
        self.organizationFilter.allCityDistricts = cityDistricts;
        // 通知代理
        if([self.delegate respondsToSelector:@selector(organizationFilterConditionChanged)]){
            [self.delegate organizationFilterConditionChanged];
        }
        
    } hdcTypeName:hdcType.name];
}

#pragma mark 选择城区和商圈的初始化
-(void) initSelectBusinessCircleView{
    
    // 城区
    self.selectCityDistrictView = [[SelectCityDistrictView alloc] initWithOrganizationFilter:self.organizationFilter];
    self.selectCityDistrictView.frame = CGRectMake(0, organization_filter_menu_height+0.5, self.selectCityDistrictView.frame.size.width, self.selectCityDistrictView.frame.size.height);
    self.selectCityDistrictView.delegate = self;
    
    // 商圈
    self.selectBusinessCircleView = [[SelectBusinessCircleView alloc] initWithOrganizationFilter:self.organizationFilter];
    self.selectBusinessCircleView.frame = CGRectMake(self.selectCityDistrictView.frame.size.width,organization_filter_menu_height+0.5, self.selectBusinessCircleView.frame.size.width, self.selectBusinessCircleView.frame.size.height);
    self.selectBusinessCircleView.delegate = self;
    self.selectBusinessCircleView.businessCircleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.selectCityDistrictView.hidden = YES;
    self.selectBusinessCircleView.hidden = YES;
    [self addSubview:self.selectCityDistrictView];
    [self addSubview:self.selectBusinessCircleView];
    
}

#pragma mark 选择城区的代理
-(void)cityDistrictSelected:(CityDistrict *)cityDistrict{
    
    if (cityDistrict==nil || [cityDistrict.name isEqualToString:@"附近"]) {  // 特殊处理
        
        // 隐藏
        self.selectCityDistrictView.hidden = YES;
        self.selectBusinessCircleView.hidden = YES;
        [self.superview sendSubviewToBack:self];
        
        // 处理菜单的新文本
        [self handleCurrentViewStatus:1 content:cityDistrict.name];
        
        if (cityDistrict==nil || [cityDistrict.name isEqualToString:self.organizationFilter.selectedBusinessCircleName]){
            return;
        }
        
        [self.organizationFilter setSelectedBusinessCircleName:cityDistrict.name];
        [self.organizationFilter setSelectedBusinessCircleId:0];
        [self.organizationFilter setSelectedCityDistrictName:cityDistrict.name];
        [self.organizationFilter setSelectedCityDistrictRowId:0];

        
        // 先查美发卡类型 ， 再查商户， 再查商户对应的美发卡
        [HdcStore getHdcTypeByBusinessCircleId:^(NSArray *hdcTypes, NSError *error) {
            self.organizationFilter.hdcCatalogs = [self getHdcCatalogsByHdcTypes:hdcTypes];
            if([self.delegate respondsToSelector:@selector(organizationFilterConditionChanged)]){
                [self.delegate organizationFilterConditionChanged];
            }
        } businessCirclesId:0];  // 0就是表示附近这个商圈，所在在这里写0
        return ;
    }

    if (self.organizationFilter.clickedCityDistricts == nil) {
        self.organizationFilter.clickedCityDistricts = [[NSMutableArray alloc] init];
    }
    
    [self.organizationFilter.clickedCityDistricts addObject:cityDistrict.name];
    
    [self.selectBusinessCircleView reloadBusinessCircles];

}

#pragma mark 选择商圈的代理
-(void)businessCircleSelected:(BusinessCircles *)businessCircle{
    
    // 隐藏
    self.selectCityDistrictView.hidden = YES;
    self.selectBusinessCircleView.hidden = YES;
    [self.superview sendSubviewToBack:self];
    
    // 处理菜单的新文本
    [self handleCurrentViewStatus:menu_item_business_circle content:businessCircle.name];
    
    if (businessCircle==nil || [businessCircle.name isEqualToString:self.organizationFilter.selectedBusinessCircleName]) {
        return;
    }
    
    OrganizationFilter *organizationFilter = self.organizationFilter;
    [organizationFilter setSelectedBusinessCircleName:businessCircle.name];
    [organizationFilter setSelectedBusinessCircleId:businessCircle.id];
    
    // 先查美发卡类型 ， 再查商户， 再查商户对应的美发卡
    [HdcStore getHdcTypeByBusinessCircleId:^(NSArray *hdcTypes, NSError *error) {
        self.organizationFilter.hdcCatalogs = [self getHdcCatalogsByHdcTypes:hdcTypes];
        if([self.delegate respondsToSelector:@selector(organizationFilterConditionChanged)]){
            [self.delegate organizationFilterConditionChanged];
        }
        
    } businessCirclesId:businessCircle.id];
}

#pragma mark 选择排序类型的初始化
-(void) initSpecialOfferOrderTypeView{
    self.selectSpecialOfferListOrderTypeView = [[SelectSpecialOfferListOrderTypeView alloc] initWithOrganizationFilter:self.organizationFilter];
    self.selectSpecialOfferListOrderTypeView.frame = CGRectMake(0, organization_filter_menu_height+0.5, screen_width, 491);
    self.selectSpecialOfferListOrderTypeView.hidden = YES;
    self.selectSpecialOfferListOrderTypeView.delegate = self;
    [self addSubview:self.selectSpecialOfferListOrderTypeView];
}

#pragma mark 排序类型选择的代理
-(void) specialOfferListOrderTypeSelectedOrderType:(SpecialOfferListOrderType *)orderType{
    
    // 隐藏
    self.selectSpecialOfferListOrderTypeView.hidden = YES;
    [self.superview sendSubviewToBack:self];
    
    // 处理菜单的新文本
    [self handleCurrentViewStatus:menu_item_order_type content:orderType.name];
    
    if (orderType==nil || [orderType.name isEqualToString:self.organizationFilter.selectedOrderTypeName]) {
        return;
    }
    
    OrganizationFilter *organizationFilter = self.organizationFilter;
    [organizationFilter setSelectedOrderTypeName:orderType.name];
    [organizationFilter setSelectedOrderTypeValue:orderType.value];
    
    // 通知代理
    if([self.delegate respondsToSelector:@selector(organizationFilterConditionChanged)]){
        [self.delegate organizationFilterConditionChanged];
    }
}

#pragma mark 初次加载数据
-(void) loadData{
    
    [HdcStore getAllHdcTypes:^(NSArray *hdcCatalogs, NSError *error) {  // 获取可显示的全部美发卡。
        
        allHdcCatalogs = hdcCatalogs;
        
        // 根据商圈初始化美发卡类型
        int businessCirclesId = self.organizationFilter.selectedBusinessCircleId;
        [HdcStore getHdcTypeByBusinessCircleId:^(NSArray *hdcTypes, NSError *error) {
            self.organizationFilter.hdcCatalogs = [self getHdcCatalogsByHdcTypes:hdcTypes];
            
            [self.selectHdcTypeView reloadHdcTypes];
            NSString *hdcTypeName = @"全部";
            if ([NSStringUtils isNotBlank:self.organizationFilter.selectedHdcTypeName]) {
                hdcTypeName = self.organizationFilter.selectedHdcTypeName;
            }
            
            // 根据美发卡查商圈
            [CityStore getBusinessCirclesByHdcTypeName:^(NSArray *districts, NSError *error) {
                self.organizationFilter.allCityDistricts = districts;
                [self.selectCityDistrictView.cityDistrictsTableView reloadData];
                [self.selectBusinessCircleView.businessCircleView reloadData];
            } hdcTypeName:hdcTypeName];
            
        } businessCirclesId:businessCirclesId];

    }];
}

// 当选中了菜单项走该方法
-(void) didSelectedSegment:(UIButton *)btn{

    switch (btn.tag) {
        case 0:
            self.selectHdcTypeView.hidden = !self.selectHdcTypeView.hidden;
            self.selectHdcCatalogView.hidden = !self.selectHdcCatalogView.hidden;
            [self handleCurrentViewStatus:0 content:nil];
            if (!self.selectHdcTypeView.hidden) {
                [self.organizationFilter setClickedHdcCatalog:nil];
                [self.selectHdcCatalogView.hdcCatalogsTableView reloadData];
                [self.selectHdcTypeView.hdcTypesTableView reloadData];
                [self.superview bringSubviewToFront:self];
            }
            break;
        case 1:
            
            self.selectCityDistrictView.hidden = !self.selectCityDistrictView.hidden;
            self.selectBusinessCircleView.hidden = !self.selectBusinessCircleView.hidden;
            [self handleCurrentViewStatus:1 content:nil];
            if (!self.selectCityDistrictView.hidden) {
                [self.organizationFilter.clickedCityDistricts removeAllObjects];
                [self.selectCityDistrictView.cityDistrictsTableView reloadData];
                [self.selectBusinessCircleView.businessCircleView reloadData];
                [self.superview bringSubviewToFront:self];
            }
            break;
        case 2:
            self.selectSpecialOfferListOrderTypeView.hidden = !self.selectSpecialOfferListOrderTypeView.hidden;
            [self handleCurrentViewStatus:2 content:nil];
            if (!self.selectSpecialOfferListOrderTypeView.hidden) {
                [self.selectSpecialOfferListOrderTypeView.orderTypeView reloadData];
                [self.superview bringSubviewToFront:self];
            }
            break;
        default:
            break;
    }
}

-(void) handleCurrentViewStatus:(int)selectType content:(NSString *)content{
    for (int i=0 ; i<menuItems.count ; i++) {
        if (selectType == i) {  // 被选中的菜单
            
            UIImageView *downArrowIcon = downArrows[i];
            [UIView animateWithDuration:0.3 animations:^{
                downArrowIcon.transform = CGAffineTransformRotate(downArrowIcon.transform, -M_PI);
            }];
            
            UIImageView *currentSelectd = upArrows[i];
            currentSelectd.hidden = !currentSelectd.hidden;
            
            // 处理菜单项的文本内容
            if([NSStringUtils isNotBlank:content]){
                [self handleMenuItemContent:content location:i];
            }
        }else{ // 没被选中的菜单
            
            UIImageView *downArrowIcon = downArrows[i];
            [UIView animateWithDuration:0.1 animations:^{
                downArrowIcon.transform = CGAffineTransformIdentity;
            }];
            
            UIImageView *currentSelectd = upArrows[i];
            currentSelectd.hidden = YES;
            
            switch (i) {
                case 0:
                    self.selectHdcCatalogView.hidden = YES;
                    self.selectHdcTypeView.hidden = YES;
                    break;
                case 1:
                    self.selectCityDistrictView.hidden = YES;
                    self.selectBusinessCircleView.hidden = YES;
                    break;
                case 2:
                    self.selectSpecialOfferListOrderTypeView.hidden = YES;
                    break;
                default:
                    break;
            }
            [self.superview sendSubviewToBack:self];
        }
    }
    
}

/**
 *  重新计算菜单栏文本与箭头的位置
 */
-(void) handleMenuItemContent:(NSString *)content location:(int)location{

    // 设置菜单项的文本
    UIButton *button = menuItems[location];
    [button setTitle:content forState:UIControlStateNormal];
    float buttonX = (button.frame.size.width - button.titleLabel.realWidth)/2- 7.5;
    button.contentEdgeInsets = UIEdgeInsetsMake(0,buttonX, 0, 0);
    
    // 获取按钮中文本的长度
    float titleLabelHeight = [button titleLabel].frame.size.height;
    
    // 处理向下箭头的位置
    UIImageView *downArrowIcon = downArrows[location];
    float downArrowIconX = button.frame.origin.x + buttonX + button.titleLabel.realWidth;
    float downArrowIconY = titleLabelHeight/itemNames.count;
    CGRect frame = CGRectMake(downArrowIconX, downArrowIconY, down_arrow_icon_width, down_arrow_icon_height);
    downArrowIcon.frame = frame;
    
}


-(NSMutableArray *) getHdcCatalogsByHdcTypes:(NSArray *)hdcTypes{
    NSMutableArray *tempHdcCatalogs = [[NSMutableArray alloc] init];
    
    for (HdcCatalog *hdcCatalog in allHdcCatalogs) {
        NSMutableArray *newHdcTypes = [[NSMutableArray alloc] init];
        for (HdcType *theHdcType in hdcCatalog.hdcTypes) {
            for (HdcType *hdcType in hdcTypes) {
                if ([hdcType.name isEqualToString:theHdcType.name]) {
                    [newHdcTypes addObject:hdcType];
                }
            }
        }
        if(newHdcTypes.count > 0){
            HdcCatalog *newHdcCatalog = [[HdcCatalog alloc] init];
            newHdcCatalog.hdcTypes    = [newHdcTypes copy];
            newHdcCatalog.name        = [hdcCatalog name];
            [tempHdcCatalogs addObject:newHdcCatalog];
        }
    }
    
    return tempHdcCatalogs;
}

@end
