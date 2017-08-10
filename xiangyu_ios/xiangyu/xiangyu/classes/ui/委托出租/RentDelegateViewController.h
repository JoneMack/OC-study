//
//  RentDelegateViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"
#import "SeleceAreaAndCircleView.h"
#import "RentDelegateFormCell.h"

@interface RentDelegateViewController : UIViewController <UITableViewDelegate , UITableViewDataSource , SelectAreaAndCircleDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerBlock;

@property (strong, nonatomic) IBOutlet UITableView *bodyView;


@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , strong) SeleceAreaAndCircleView *selectView;

@property (nonatomic , strong) UIView *pickControlView;

@property (nonatomic , strong) RentDelegateFormCell *cell;

@end
