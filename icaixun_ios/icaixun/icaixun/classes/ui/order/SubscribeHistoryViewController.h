//
//  SubscribeHistoryViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/10.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeExpertLog.h"

@interface SubscribeHistoryViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bodyView;

@property (nonatomic , strong) UIImageView *contentBlockView;
@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , strong) UILabel *commonLabel;
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *subscribeExpertLogs;


@end
