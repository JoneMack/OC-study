//
//  SubscribeDescController.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/23.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert.h"

@interface SubscribeDescController : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bodyView;

@property (nonatomic , strong) UIImageView *contentBlockView;
@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , strong) UILabel *commonLabel;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) Expert *expert;

-(instancetype) initWithExpert:(Expert *)expert;

@end
