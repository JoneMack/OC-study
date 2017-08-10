//
//  SelectPayWayViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHouseSourceCell.h"
#import "HouseInfo.h"
#import "House.h"
#import "CustomerInfo.h"


@interface SelectPayWayViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>


@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;

@property (nonatomic , strong) UIView *bottomBlock;
@property (nonatomic , strong) UIButton *nextBtn;


@property (nonatomic , weak) House *house;
@property (nonatomic , weak) HouseInfo *houseInfo;
@property (nonatomic , strong) NSArray *payTypes;
@property (nonatomic , strong) NSString *sfContractId;

@property (nonatomic , strong) MainHouseSourceCell *houseSourceCell;

@property (nonatomic , strong) NSString *currentPayType;
@property (nonatomic , assign) NSInteger currentPayTypeRow;

@property (nonatomic , strong) NSDictionary *rentPeriod;

@property (nonatomic , weak) CustomerInfo *customerInfo;

@end
