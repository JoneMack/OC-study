//
//  YeZhuViewController.h
//  xiangyu
//
//  Created by xubojoy on 16/9/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractInfoList.h"
@protocol YeZhuViewControllerDelegate <NSObject>

- (void)didYeZhuViewControllerIndexPathRow:(NSInteger)row contractInfoList:(ContractInfoList *)contractInfoList;

@end
@interface YeZhuViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , strong) UITableView *bodyView;
@property (nonatomic ,assign) int currentPageNo;
@property (nonatomic ,strong) ContractInfoList *contractInfoList;
@property (nonatomic ,strong) NSMutableArray *userSfContractListArray;
@property (nonatomic ,assign) id<YeZhuViewControllerDelegate> delegate;
@end
