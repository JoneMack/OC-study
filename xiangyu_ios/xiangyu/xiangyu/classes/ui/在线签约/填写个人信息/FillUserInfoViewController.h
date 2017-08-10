//
//  FillUserInfoViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/13.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHouseSourceCell.h"
#import "UserInfoCell.h"
#import "IDPhotosCell.h"
#import "House.h"
#import "HouseInfo.h"
#import "CustomerInfo.h"

@interface FillUserInfoViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;

@property (nonatomic , strong) MainHouseSourceCell *houseSourceCell;
@property (nonatomic , strong) UserInfoCell *userInfoCell;
@property (nonatomic , strong) IDPhotosCell *idPhotosCell;
@property (nonatomic , strong) UITableViewCell *bodyFooterView;

@property (nonatomic , strong) UIView *lineView;


@property (nonatomic , strong) House *house;

@property (nonatomic , strong) HouseInfo *houseInfo;
@property (nonatomic , strong) CustomerInfo *customerInfo;

@end
