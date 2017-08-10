//
//  PayOrderViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CfContractXS.h"

@interface PayOrderViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;

@property (nonatomic , strong) UIView *bottomBlock;
@property (nonatomic , strong) UIButton *payBtn;

@property (nonatomic , strong) NSString *currentPayType;

@property (nonatomic , strong) NSString *cfcontractid;
@property (nonatomic , strong) CfContractXS *cfContractXS;

@end
