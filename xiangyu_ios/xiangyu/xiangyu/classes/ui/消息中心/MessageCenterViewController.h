//
//  MessageCenterViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterViewController : UIViewController < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UITableView *bodyView;


@end
