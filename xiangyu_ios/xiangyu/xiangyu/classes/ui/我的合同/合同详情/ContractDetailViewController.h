//
//  ContractDetailViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/11.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractDetailViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UITableView *bodyView;

@property (strong, nonatomic) NSString *userType ; // user:租客 , owner:业主



@end
