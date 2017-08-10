//
//  UserHdcController.h
//  styler
//
//  Created by wangwanggy820 on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

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

#import <UIKit/UIKit.h>
#import "UserHdcCell.h"
#import "Organization.h"
#import "CustomSegmentView.h"
#import "UserHdc.h"
#import "LoadingStatusView.h"

@interface UserHdcController : UIViewController<UITableViewDataSource, UITableViewDelegate, CustomSegmentViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) CustomSegmentView *userHdcNavView;
@property (weak, nonatomic) IBOutlet UITableView *userHdcsTableView;
@property (strong, nonatomic) LoadingStatusView *lsv;

@property (nonatomic, strong) NSMutableArray *userHdcs;
@property (nonatomic, strong) NSMutableArray *organizations;

@property int currentPageNO;
@property NSArray *currentCardStatuses;
@property int currentTableViewStatus;//列表当前状态

-(id) initWithCardStatus:(NSArray *)cardStatuses;

@end
