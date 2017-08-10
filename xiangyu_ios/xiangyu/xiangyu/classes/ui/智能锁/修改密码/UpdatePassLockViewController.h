//
//  UpdatePassLockViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/28.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePassLockViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UITableView *bodyView;

@end
