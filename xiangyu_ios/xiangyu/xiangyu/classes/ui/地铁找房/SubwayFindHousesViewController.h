//
//  SubwayFindHousesViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentView.h"
#import "House.h"

@interface SubwayFindHousesViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;

@property (nonatomic , strong) CustomSegmentView *customSegmentView;

@property (nonatomic , strong) NSArray *currentType;

@property (nonatomic , strong) NSString *subwayLine;
@property (nonatomic , strong) NSString *subwayLineId;
@property (nonatomic , strong) NSString *station;
@property (nonatomic , strong) NSString *stationId;

@property (nonatomic , strong) NSString *minPrice;
@property (nonatomic , strong) NSString *maxPrice;
@property (nonatomic , strong) NSString *rentType;
@property (nonatomic , strong) NSString *houseType;  //户型居室（不限、1、2、3、4+）
@property (nonatomic , strong) NSString *orderByType;  // 显示顺序（租金：priceASC/priceDESC、面积:areaASC/areaDESC）默认不传值
@property (nonatomic , strong) NSString *liveFlg;   // 带视频直播（选中：1）
@property (nonatomic , strong) NSMutableArray *searchTab;

@property (nonatomic , strong) NSMutableArray<House *> *houses;

-(void) loadData;

-(void) changeConditionReloadData;


-(void) transformEvent:(int)eventType;

@end
