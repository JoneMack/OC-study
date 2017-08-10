//
//  SelectAreaViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@interface SelectAreaViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UIView *headerBlock;

@property (strong, nonatomic) IBOutlet UIView *middleLineView;

@property (strong, nonatomic) IBOutlet UITableView *leftTableView;

@property (strong, nonatomic) IBOutlet UITableView *rightTableView;


@property (strong, nonatomic) HeaderView *headerView;

@property (strong, nonatomic) Circle *circle;

@property (strong, nonatomic) NSString *currentQuyu;
@property (strong, nonatomic) NSString *currentShangquan;


@property (strong, nonatomic) NSString *selectedQuyu;
@property (strong, nonatomic) NSString *selectedShangquan;




@end
