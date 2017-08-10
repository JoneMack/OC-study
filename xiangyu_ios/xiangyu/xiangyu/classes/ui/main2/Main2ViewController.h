//
//  MainViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHeaderView.h"
#import "MainHouseSourceTableView.h"
#import "MainCarouselView.h"
#import "MainFindHouseWaysView.h"
#import "MainJoinUsView.h"
#import "MMDrawerController.h"
#import "MainCarouselTempView.h"

@interface Main2ViewController : UIViewController <UITableViewDataSource , UITableViewDelegate , MainHouseSourceTableViewDetegate>


@property (nonatomic ,strong) MMDrawerController *drawerController;

@property (nonatomic , strong) MainHeaderView *headerView;

// 轮播图
@property (nonatomic , strong) MainCarouselView *mainCarouselView;
@property (nonatomic , strong) MainCarouselTempView *mainCarouselTempView;
//找房方式
@property (nonatomic , strong) MainFindHouseWaysView *mainFindHouseWaysView;
// 加入相寓
@property (nonatomic , strong) MainJoinUsView *mainJoinUsView;

@property (nonatomic , strong) MainHouseSourceTableView *hourseSourcesView;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray *banners;



@end
