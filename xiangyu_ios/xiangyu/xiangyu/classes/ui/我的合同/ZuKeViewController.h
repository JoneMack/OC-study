//
//  ZuKeViewController.h
//  xiangyu
//
//  Created by xubojoy on 16/9/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractInfoList.h"
@protocol ZuKeViewControllerDelegate <NSObject>

- (void)didZuKeViewControllerIndexPathRow:(NSInteger)row contractInfoList:(ContractInfoList *)contractInfoList;

@end
@interface ZuKeViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , strong) UITableView *bodyView;
@property (nonatomic ,assign) int currentPageNo;
@property (nonatomic ,strong) ContractInfoList *contractInfoList;
@property (nonatomic ,strong) NSMutableArray *contractInfoListArray;
@property (nonatomic , strong) NSArray *currentType;
@property (nonatomic ,assign) id<ZuKeViewControllerDelegate> delegate;


@end
