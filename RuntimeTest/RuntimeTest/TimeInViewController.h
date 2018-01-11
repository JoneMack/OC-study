//
//  TimeInViewController.h
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/3.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeInViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSMutableArray *indesPaths;
@property (nonatomic,assign)int DatNum;
@property(nonatomic,strong) NSTimer * timer;
@end
