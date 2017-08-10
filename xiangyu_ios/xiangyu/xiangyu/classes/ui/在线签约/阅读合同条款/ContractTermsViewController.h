//
//  ContractTermsViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"
#import "HouseInfo.h"

@interface ContractTermsViewController : UIViewController

@property (nonatomic , strong) HeaderView *headerView;

//@property (nonatomic , strong) UITableView *bodyView;
@property (nonatomic , strong) UIWebView *bodyView;

@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) UIButton *nextBtn;

@property (nonatomic , strong) House *house;
@property (nonatomic , strong) HouseInfo *houseInfo;

@property (nonatomic , strong) NSDictionary *rentPeriod;
@property (nonatomic , strong) NSString *cfcontractid;

@end
