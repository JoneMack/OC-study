//
//  SelectContractViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseInfo.h"
#import "House.h"

@interface SelectContractViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;


@property (nonatomic , strong) House *house;

@property (nonatomic , strong) HouseInfo *houseInfo;


@end
