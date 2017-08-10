//
//  MyPatientControllerViewController.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupListViewController.h"
#import "CommonCell.h"
@interface MyPatientController : BaseViewController<WKTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) GroupListViewController *groupController;

@end
