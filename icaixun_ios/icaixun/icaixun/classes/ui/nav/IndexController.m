//
//  IndexController.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/15.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "IndexController.h"
#import "ExpertMessageCell.h"
#import "UILabel+Custom.h"
#import "LeveyTabBarController.h"
#import "ExpertMessageStore.h"
#import "ExpertMessageFrame.h"
#import "MJRefresh.h"
#import "ExpertDetailViewController.h"

@interface IndexController ()

@property int currentPageNo;
@property int pageSize;
@property int currentEventType;

@end

@implementation IndexController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentEventType = event_load_data_init_load;
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshExpertMessages:) name:notification_name_receive_expert_message object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpExpert) name:@"test_jump" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPageView) name:notification_name_network_not_reachable object:nil];
}

/**
 * 初始化视图
 */
- (void)initView
{
    
    self.currentEventType = event_load_data_load_over;
    
    UIView *testView = [[UIView alloc] init];
    testView.frame = CGRectMake(0, 0, screen_width, 0);
    [self.view addSubview:testView];
    int y = CURRENT_SYSTEM_VERSION >= 7 ? 0 : status_bar_height;
    CGRect frame = CGRectMake(0, 0+y, screen_width,
                              screen_height - y - tabbar_height);
    self.bodyTableView = [[UITableView alloc] initWithFrame:frame
                                                      style:UITableViewStyleGrouped];
    self.bodyTableView.frame = frame;
    [self.bodyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.bodyTableView.dataSource = self;
    self.bodyTableView.delegate = self;
    [self.bodyTableView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];

    [self.view addSubview:self.bodyTableView];
    
    [self setupMJRefresh];
    
}

-(void) setupMJRefresh
{
    //下拉刷新
    [self.bodyTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.bodyTableView headerBeginRefreshing];
    //上拉加载更多
    [self.bodyTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.bodyTableView headerEndRefreshing];
    // 设置文字
    self.bodyTableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.bodyTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.bodyTableView.headerRefreshingText = @"刷新中...";
    
    self.bodyTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.bodyTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.bodyTableView.footerRefreshingText = @"加载中...";
}

//下拉刷新
-(void) headerRefreshing
{
    [self transformEvent:event_load_data_pull_down];
}

-(void) footerRefreshing
{
    [self transformEvent:event_load_data_pull_up];
}

#pragma mark 返回section的个数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每个section的cell个数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expertMessages.count;
}

#pragma mark 返回section 的高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int y = CURRENT_SYSTEM_VERSION >= 7 ? status_bar_height : 0;
    return 155 + y;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark 返回cell 的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertMessageFrame *frame = self.expertMessagesFrames[indexPath.row];
    return frame.cellHeight;
}

#pragma mark 返回第一个section 的 header view
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.indexHeaderView == nil) {
        self.indexHeaderView = [[IndexHeaderView alloc] initWithNavigationController:self.navigationController];
        self.indexHeaderView.delegate = self;
    }
    return self.indexHeaderView;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indexExpertMessageCellIdentifier = @"indexExpertMessageCellIdentifier";
    [tableView registerNib:[UINib nibWithNibName:@"ExpertMessageCell" bundle:nil] forCellReuseIdentifier:indexExpertMessageCellIdentifier];
    ExpertMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:indexExpertMessageCellIdentifier];
    if (cell == nil) {
        cell = [[ExpertMessageCell alloc] initWithReuseIdentifier:indexExpertMessageCellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ExpertMessage *message = self.expertMessages[indexPath.row];
    Expert *expert = [self getExpertById:message.expertId];
    ExpertMessageFrame *frame = self.expertMessagesFrames[indexPath.row];
    [cell renderWithExpertMessage:message expert:expert];
    [cell renderBaseFrame:frame];
    return cell;
}

-(void) getExpertsMessages:(NSArray *)experts
{
    self.experts = experts;
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self transformEvent:event_load_data_init_load];
}

-(void) fillExpertMessagesFrames:(NSArray *)expertMessages
{
    if (self.expertMessagesFrames == nil) {
        self.expertMessagesFrames = [NSMutableArray new];
    }
    for (ExpertMessage *expertMessage in expertMessages) {
        ExpertMessageFrame *messageFrame = [[ExpertMessageFrame alloc] initWithExpertMessage:expertMessage];
        [self.expertMessagesFrames addObject:messageFrame];
    }
}


-(Expert *) getExpertById:(int)expertId
{
    for (Expert *expert in self.experts) {
        if (expert.id == expertId) {
            return expert;
        }
    }
    return nil;
}


#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    self.currentEventType = eventType;
    if (self.currentTableViewStatus == load_data_status_waiting_load
        && eventType == event_load_data_init_load) {
        // 初始化加载
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        self.pageSize = 10;
        self.expertMessages = nil;
        self.expertMessagesFrames = nil;
        [self getExpertMessages];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        // 上拉加载
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = self.currentPageNo + 1;
        [self getExpertMessages];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down) {
        // 下拉刷新
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        self.expertMessages  = nil;
        self.expertMessagesFrames = nil;
        [self getExpertMessages];
    }
}

#pragma mark 获取专家消息数据
-(void) getExpertMessages
{
    
    if (self.experts == nil) {
        return;
    }
    
    NSMutableArray *expertIds = [NSMutableArray new];
    for (Expert *expert in self.experts) {
        [expertIds addObject:@(expert.id)];
    }
    
    [[ExpertMessageStore sharedInstance] getExpertMessagesByExpertIds:^(Page *page, NSError *err) {
        if (err == nil) {
            
            if (self.expertMessages == nil) {
                self.expertMessages = [NSMutableArray new];
            }
            
            if (page.items.count >0) {
                self.currentTableViewStatus = load_data_status_waiting_load;
                [self.expertMessages addObjectsFromArray:page.items];
                [self fillExpertMessagesFrames:page.items];
                [self.bodyTableView reloadData];
                
            }else{
                self.currentTableViewStatus = load_data_status_waiting_load;
                [SVProgressHUD showSuccessWithStatus:@"全部加载完成"];
            }
            
        }else{
            ExceptionMsg *msg = [err.userInfo objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:msg.message];
            
        }
        if(self.currentEventType == event_load_data_pull_down){
            [self.bodyTableView headerEndRefreshing];
        }else if(self.currentEventType == event_load_data_pull_up){
            [self.bodyTableView footerEndRefreshing];
        }
        
    } expertIds:[expertIds copy] pageNo:self.currentPageNo pageSize:self.pageSize];
}

-(void) refreshExpertMessages:(NSNotification *)notification
{
    [self transformEvent:event_load_data_init_load];
}

-(void) jumpExpert
{
    Expert *expert = self.experts[0];
    ExpertDetailViewController *expertDetailController = [[ExpertDetailViewController alloc] initWithExpert:expert];
    [self.navigationController pushViewController:expertDetailController animated:YES];
}

-(void) refreshPageView
{
    self.indexHeaderView = [[IndexHeaderView alloc] initWithNavigationController:self.navigationController];
    self.indexHeaderView.delegate = self;
    
    [self.bodyTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
