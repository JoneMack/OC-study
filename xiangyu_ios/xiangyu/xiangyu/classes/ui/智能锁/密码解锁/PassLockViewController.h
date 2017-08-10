//
//  PassLockViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassLockViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bgView;

@property (nonatomic , strong) UIButton *mimaBtn;
@property (nonatomic , strong) UIButton *shoushiBtn;

@property (nonatomic , strong) UITableView *bodyView;




@end
