//
//  MyOrderedLookController.h
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderedLookSegmentView.h"
#import "LookingUnFinishViewController.h"
#import "FinishLookViewController.h"
@interface MyOrderedLookController : UIViewController<MyOrderedLookSegmentViewDelegate>
@property (nonatomic ,strong) UIView *topSegView;
@property (nonatomic , strong) MyOrderedLookSegmentView *myOrderedLookSegmentView;
@property (nonatomic ,strong) NSArray *currentType;
//@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *selectBtn;
@property (nonatomic ,strong) UINavigationController *navigationController;

@property (nonatomic ,strong) LookingUnFinishViewController *lookingUnFinishViewController;
@property (nonatomic ,strong) FinishLookViewController *finishLookViewController;
- (instancetype)initWithOrderedLookSelectBtn:(UIButton *)btn navigationController:(UINavigationController *)navigationController;
@end
