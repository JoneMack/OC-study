//
//  MyContractViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractDetailViewController.h"
#import "XBCustomSegmentView.h"
#import "ZuKeViewController.h"
#import "YeZhuViewController.h"
@interface MyContractViewController : UIViewController <XBCustomSegmentViewDelegate, ZuKeViewControllerDelegate,YeZhuViewControllerDelegate>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic ,strong) XBCustomSegmentView *xbCustomSegmentView;
//@property (nonatomic , strong) UITableView *bodyView;
@property (nonatomic ,strong) NSArray *currentGameStatuses;
//@property (nonatomic , strong) UITableViewHeaderFooterView *bodyHeaderView;
//@property (nonatomic , strong) UIButton *zukeBtn;
//@property (nonatomic , strong) UIButton *yezhuBtn;
//@property (nonatomic , strong) UIView *lineView;
@property (nonatomic ,strong) NSString *pushTypeStr;
@property (nonatomic ,strong) ZuKeViewController *zuKeViewController;
@property (nonatomic ,strong) YeZhuViewController *yeZhuViewController;

//
//@property (strong, nonatomic) NSString *userType ; // user:租客 , owner:业主

@end
