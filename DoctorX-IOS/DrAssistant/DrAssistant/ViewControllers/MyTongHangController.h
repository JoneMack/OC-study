//
//  MyTongHangController.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupListViewController.h"
#import "CommonCell.h"
@interface MyTongHangController : BaseViewController<WKTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) GroupListViewController *groupController;
@property (nonatomic, strong) UITableView *tableView;
@end
