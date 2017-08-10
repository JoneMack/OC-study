//
//  LookingUnFinishViewController.h
//  xiangyu
//
//  Created by xubojoy on 16/8/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookingUnFinishViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *selectBtn;
@property (nonatomic ,strong) UINavigationController *navigationController;
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) NSMutableArray *lookingUnfnishHouseArray;
@property (nonatomic ,strong) NSMutableArray *selectedUnfnishHouseIdArray;

- (instancetype)initWithSelectBtn:(UIButton *)btn navigationController:(UINavigationController *)navigationController;


@end
