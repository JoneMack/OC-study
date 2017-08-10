//
//  ConfirmRentDateViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseInfo.h"
#import "House.h"
#import "CustomerInfo.h"

@interface ConfirmRentDateViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>


@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;

@property (nonatomic , strong) UIButton *nextBtn;

@property (nonatomic , strong) House *house;
@property (nonatomic , strong) HouseInfo *houseInfo;
@property (nonatomic , strong) NSString *errorMsg;

@property (nonatomic , strong) NSDictionary *rentPeriod;

@property (nonatomic , strong) CustomerInfo *customerInfo;



@end
