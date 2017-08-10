//
//  RentDelegateFlowViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/27.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentDelegateFlowViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;


@end
