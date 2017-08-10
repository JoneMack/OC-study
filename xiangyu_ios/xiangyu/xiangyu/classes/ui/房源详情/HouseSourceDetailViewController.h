//
//  HouseSourceDetailViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"
#import "HouseInfo.h"
#import "HouseSourceDetailBottomView.h"
#import "MMDrawerController.h"

@interface HouseSourceDetailViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;
@property (nonatomic , strong) HouseSourceDetailBottomView *bottomView;

@property (nonatomic , strong) NSString *houseId;
@property (nonatomic , strong) NSString *roomId;
@property (nonatomic , strong) NSString *rentType;

@property (nonatomic , strong) House *house;
@property (nonatomic , strong) HouseInfo *houseInfo;
@property (nonatomic , strong) NSArray<House *> *recommendHouses;

@property (nonatomic ,strong) MMDrawerController *drawerController;


@end
