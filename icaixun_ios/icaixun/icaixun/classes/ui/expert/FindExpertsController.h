//
//  FindExpertsController.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindExpertsHeaderView.h"

@interface FindExpertsController : UIViewController < UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UITableView *bodyTableView;
@property (nonatomic , strong) FindExpertsHeaderView *sectionHeaderView;

@property (nonatomic , strong) NSArray *experts;

@property (nonatomic , strong) NSArray *expertMessages;

@end
