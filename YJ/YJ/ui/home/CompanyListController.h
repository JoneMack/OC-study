//
//  CompanyListController.h
//  YJ
//
//  Created by xubojoy on 2017/6/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyListController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) HeaderView *headerView;

@end
