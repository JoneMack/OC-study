//
//  ViewController.h
//  videotest
//
//  Created by xubojoy on 16/9/9.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListCell.h"
#import "LiveListModel.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) LiveListModel *liveListModel;
@property (nonatomic ,strong) NSMutableArray *liveListModelArray;
@end

