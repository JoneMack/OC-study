//
//  MyOrderController.h
//  styler
//
//  Created by System Administrator on 13-6-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

#define my_order_title        @"我的预约"
#define my_unevalaution_title @"待评价"

#define filte_type_all 1
#define filte_type_unevaluation 2

#define table_view_status_waiting 1 //等待加载状态
#define table_view_status_loading 2 //正在加载状态
#define table_view_status_load_over 3 //加载完成完成
#define table_view_status_load_fail 4 //加载失败

#define event_init_load 0 //初始加载事件
#define event_pull_up 1 //上拉事件
#define event_click_load    2 //点击加载事件
#define event_load_complete_succes 3 //加载成功事件
#define event_load_complete_fail   4 //加载失败事件
#define event_load_complete_over   5 //加载完成事件


@interface MyOrderController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *orderListTable;
@property (strong, nonatomic) HeaderView *header;
@property (nonatomic, retain) NSMutableArray *orders;

@property (copy, nonatomic) NSString *title;
@property int filteType;

@property int currentPageNO;
@property int currentTableViewStatus;//列表当前状态

-(id)initWithOrders:(NSMutableArray *)orders filteType:(int)filteType;

@end
