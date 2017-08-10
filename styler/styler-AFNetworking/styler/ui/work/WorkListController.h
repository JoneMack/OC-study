//
//  LookWorkListController.h
//  styler
//
//  Created by wangwanggy820 on 14-6-4.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define work_list_status_waiting_load 1
#define work_list_status_loading 2
#define work_list_status_load_over 3
#define work_list_status_load_fail 4
#define work_list_status_refreshing 5

#define event_init_load 1
#define event_load_success 2
#define event_load_over 3
#define event_load_fail 4
#define event_pull_up 5
#define event_pull_down 6


#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "UIViewController+Custom.h"
#import "UIView+Custom.h"


#define tag_name_work        1
#define common_work          2
#define my_fav_work          3
#define stylist_profile_work 4

@interface WorkListController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) HeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *title;
@property int currentTableViewStatus;//列表当前状态
@property int type;


-(id)initWithRequestURL:(NSString *)url title:(NSString *)title type:(int)type;

@end
