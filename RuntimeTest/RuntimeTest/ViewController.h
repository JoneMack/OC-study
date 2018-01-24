//
//  ViewController.h
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/17.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@end

