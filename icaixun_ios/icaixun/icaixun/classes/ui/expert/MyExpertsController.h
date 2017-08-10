//
//  MyExpertsController.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyExpertsController : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *tableView;



@end
