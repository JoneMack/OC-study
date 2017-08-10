//
//  CouponViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponViewController : UIViewController < UITableViewDelegate , UITableViewDataSource >



@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;

@property (nonatomic , strong) UITableViewHeaderFooterView *bodyHeaderView;
@property (nonatomic , strong) UITextField *inputCouponField;
@property (nonatomic , strong) UIButton *changeCouponBtn;
@property (nonatomic , strong) UIView *lineView;

@end
