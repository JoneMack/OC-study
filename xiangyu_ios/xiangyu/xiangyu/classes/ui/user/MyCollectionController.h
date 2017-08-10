//
//  MyCollectionController.h
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyCollectionController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *selectBtn;
@property (nonatomic ,strong) UINavigationController *navigationController;
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) NSMutableArray *favHouseArray;
@property (nonatomic ,strong) NSMutableArray *selectedHouseCollectionIdArray;
@property (nonatomic ,strong) NSMutableDictionary *selectedHouseCollectionIdDict;

- (instancetype)initWithSelectBtn:(UIButton *)btn navigationController:(UINavigationController *)navigationController;
@end
