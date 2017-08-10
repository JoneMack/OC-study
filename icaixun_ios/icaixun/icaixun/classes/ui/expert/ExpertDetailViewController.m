//
//  ExpertDetailViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/23.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define expert_detail_bottom_height 35
#define show_segment_msgs           @"msgs"
#define show_segment_achievement    @"achievement"


#import "ExpertDetailViewController.h"
#import "ExpertMessageCell.h"
#import "ExpertDetailHeaderView.h"
#import "SubscribeDescController.h"
#import "UserStore.h"
#import "ExpertMessageStore.h"
#import "MJRefresh.h"
#import "SystemStore.h"
#import "SystemPromptController.h"

@interface ExpertDetailViewController ()

@property (nonatomic , strong) NSString *showSegment;


@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) UIButton *subscribeBtn;
@property (nonatomic , strong) UIButton *cancelAttentionBtn;

@property int currentPageNo;
@property int pageSize;
@property int currentTableViewStatus;
@property int currentEventType;

@end

@implementation ExpertDetailViewController

-(id) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(id) initWithExpert:(Expert *)expert
{
    self = [super init];
    if (self) {
        self.expert = expert;
        self.currentTableViewStatus = load_data_status_waiting_load;
        self.currentEventType = event_load_data_load_over;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    
    [self initBodyView];
    
    [self initBottomView];
    
    [self setupEvents];
    
    [self setupMJRefresh];
    [self transformEvent:event_load_data_init_load];
}

-(void) setupMJRefresh
{
    //下拉刷新
    [self.bodyView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    //上拉加载更多
    [self.bodyView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    // 设置文字
    self.bodyView.headerPullToRefreshText = @"下拉可以刷新了";
    self.bodyView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.bodyView.headerRefreshingText = @"刷新中...";
    
    self.bodyView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.bodyView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.bodyView.footerRefreshingText = @"加载中...";
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

-(void) initBodyView
{
    // 垃圾代码，这个地方有问题，之后调整
    UIView *testView = [[UIView alloc] init];
    [self.view addSubview:testView];
    
    self.bodyView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - expert_detail_bottom_height)
                                                 style:UITableViewStyleGrouped];
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.bodyView.dataSource = self;
    self.bodyView.delegate = self;
    [self.view addSubview:self.bodyView];
    
}

-(void) initBottomView
{
    self.bottomView = [UIView new];
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.bottomView];
    
    self.subscribeBtn = [UIButton new];
    self.subscribeBtn.layer.masksToBounds = YES;
    self.subscribeBtn.layer.cornerRadius = 11;
    [self.subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.subscribeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.subscribeBtn setBackgroundColor:[ColorUtils colorWithHexString:orange_red_line_color]];
    if ([self.expert.relationStatus isEqualToString:@"Subscribe"]) {
        [self.subscribeBtn setTitle:@"续订" forState:UIControlStateNormal];
        
        self.cancelAttentionBtn = [UIButton new];
        [self.cancelAttentionBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.cancelAttentionBtn setTitle:[DateUtils stringFromLongLongIntAndFormat:self.expert.userExpertRelation.endTime dateFormat:@"MM-dd到期"] forState:UIControlStateDisabled];
        [self.cancelAttentionBtn setEnabled:NO];
        [self.cancelAttentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [self.bottomView addSubview:self.cancelAttentionBtn];

        
    }else if ([self.expert.relationStatus isEqualToString:@"Follow"]){
        [self.subscribeBtn setTitle:@"马上订阅" forState:UIControlStateNormal];
        
        self.cancelAttentionBtn = [UIButton new];
        self.cancelAttentionBtn.layer.masksToBounds = YES;
        self.cancelAttentionBtn.layer.cornerRadius = 11;
        [self.cancelAttentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelAttentionBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.cancelAttentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.cancelAttentionBtn setBackgroundColor:[ColorUtils colorWithHexString:gray_button_color]];
        [self.bottomView addSubview:self.cancelAttentionBtn];
        
    }
    [self.bottomView addSubview:self.subscribeBtn];
    
    [self initBottomViewFrame];
}

-(void) initBottomViewFrame
{
    
    self.bottomView.frame = CGRectMake(0, screen_height - expert_detail_bottom_height, screen_width, expert_detail_bottom_height);
    
//    if ([self.expert.relationStatus isEqualToString:@"Subscribe"]) {
//        self.subscribeBtn.frame = CGRectMake((screen_width - 77)/2, (expert_detail_bottom_height-22)/2, 77, 22);
//    }else{
        self.cancelAttentionBtn.frame = CGRectMake( ((screen_width/2)-77)/2, (expert_detail_bottom_height-22)/2, 77, 22);
        self.subscribeBtn.frame = CGRectMake( ((screen_width/2)-77)/2+screen_width/2, (expert_detail_bottom_height-22)/2, 77, 22);
//    }
    
    
}

-(void) setupEvents
{
    [self.subscribeBtn addTarget:self action:@selector(subscribeExpert) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancelAttentionBtn addTarget:self action:@selector(cancelAttentionExpert) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) loadData
{
    [[ExpertMessageStore sharedInstance] getExpertMessagesByExpertIds:^(Page *page, NSError *err) {
        [SVProgressHUD dismiss];
        if (err == nil) {
            
            if (self.expertMessages == nil) {
                self.expertMessages = [NSMutableArray new];
            }
            
            if (page.items.count > 0) {
                [self.expertMessages addObjectsFromArray:page.items];
                [self fillExpertMessagesFrames:page.items];
                [self.bodyView reloadData];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"全部加载完成"];
            }
            
        }else{
            ExceptionMsg *msg = [err.userInfo objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:msg.message];
        }
        self.currentTableViewStatus = load_data_status_waiting_load;
        if(self.currentEventType == event_load_data_pull_down){
            [self.bodyView headerEndRefreshing];
        }else if(self.currentEventType == event_load_data_pull_up){
            [self.bodyView footerEndRefreshing];
        }
        
    } expertIds:[NSArray arrayWithObject:@(self.expert.id)] pageNo:self.currentPageNo pageSize:self.pageSize];
    

}

#pragma mark 返回section 的header视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (self.headerView == nil) {
            self.headerView = [[ExpertDetailHeaderView alloc] initWithExpert:self.expert
                                                        navigationController:self.navigationController];
            self.headerView.frame = CGRectMake(0, 0, screen_width, 210);
        }
        return self.headerView;
    }else{
        self.segmentView = [[UITableViewHeaderFooterView alloc] init];
        self.segmentView.frame = CGRectMake(0, 0, screen_width, 37);
        [self.segmentView.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_black_color]];
        
        // 财讯
        self.infoListBtn = [[UIButton alloc] init];
        [self.infoListBtn setTitle:@"微博" forState:UIControlStateNormal];
        [self.infoListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.infoListBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        self.infoListBtn.frame = CGRectMake(0, 0, self.segmentView.frame.size.width/2, self.segmentView.frame.size.height);
        [self.segmentView addSubview:self.infoListBtn];
    
        [self.infoListBtn setImage:[UIImage imageNamed:@"icon_arrow"] forState:UIControlStateNormal];
        
        
        // 成就
        self.achievementBtn = [[UIButton alloc] init];
        [self.achievementBtn setTitle:@"成就" forState:UIControlStateNormal];
        [self.achievementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.achievementBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        self.achievementBtn.frame = CGRectMake(self.infoListBtn.rightX , 0, self.segmentView.frame.size.width/2, self.segmentView.frame.size.height);
        [self.segmentView addSubview:self.achievementBtn];
        
        [self.achievementBtn setImage:[UIImage imageNamed:@"icon_arrow"] forState:UIControlStateNormal];
        
        
        if ([self.showSegment isEqualToString:show_segment_msgs]) {
            [self.infoListBtn setImageEdgeInsets:UIEdgeInsetsMake(32, 0, 0, -45)];
            [self.achievementBtn setImageEdgeInsets:UIEdgeInsetsMake(47, 0, 0, -45)];
        }else{
            [self.infoListBtn setImageEdgeInsets:UIEdgeInsetsMake(47, 0, 0, -45)];
            [self.achievementBtn setImageEdgeInsets:UIEdgeInsetsMake(32, 0, 0, -45)];
        }
        [self.infoListBtn addTarget:self action:@selector(showMsgs) forControlEvents:UIControlEventTouchUpInside];
        [self.achievementBtn addTarget:self action:@selector(showAchievement) forControlEvents:UIControlEventTouchUpInside];
        
        return self.segmentView;
    }
    return nil;
}

/**
 *  共有2个section
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

/**
 * 每个section 有几个row
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        if ([self.showSegment isEqualToString:show_segment_achievement]) {
            return 1;
        }else{
            return self.expertMessages.count;
        }
    }
    return 0;
}

#pragma mark 返回每个section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 210;
    }else if (section == 1){
        return 37;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

#pragma mark 返回每个row的视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }else if (indexPath.section == 1){
        
        if ([self.showSegment isEqualToString:show_segment_msgs]) {
            static NSString *indexExpertMessageCellIdentifier = @"indexExpertMessageCellIdentifier";
            [tableView registerNib:[UINib nibWithNibName:@"ExpertMessageCell" bundle:nil] forCellReuseIdentifier:indexExpertMessageCellIdentifier];
            ExpertMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:indexExpertMessageCellIdentifier];
            if (cell == nil) {
                cell = [[ExpertMessageCell alloc] initWithReuseIdentifier:indexExpertMessageCellIdentifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            ExpertMessage *message = self.expertMessages[indexPath.row];
            ExpertMessageFrame *frame = self.expertMessagesFrames[indexPath.row];
            [cell renderWithExpertMessage:message expert:self.expert];
            [cell renderBaseFrame:frame];
            return cell;
        }else{
            UITableViewCell *cell = [UITableViewCell new];
            [cell.contentView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
            UILabel *label = [UILabel new];
            label.text = self.expert.introduction;
            label.frame = CGRectMake(15, 15, screen_width-30, 21);
            label.numberOfLines = 0;
            [label sizeToFit];
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];
            return cell;
        }
    }
    return nil;
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


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 0;
    }else if (indexPath.section == 1){
        ExpertMessageFrame *frame = self.expertMessagesFrames[indexPath.row];
        return frame.cellHeight;
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) showMsgs
{
    self.showSegment = show_segment_msgs;
    [self.bodyView reloadData];
}

-(void) showAchievement
{
    self.showSegment = show_segment_achievement;
    [self.bodyView reloadData];
}

#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if (self.currentTableViewStatus == load_data_status_waiting_load
        && eventType == event_load_data_init_load) {
        // 初始化加载
        self.currentTableViewStatus = load_data_status_loading;
        self.showSegment = show_segment_msgs;  // 初始化显示消息列表
        self.pageSize = 10;
        self.currentPageNo = 1;
        self.expertMessages = nil;
        self.expertMessagesFrames = nil;
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        
        self.currentTableViewStatus = load_data_status_loading;
        self.currentEventType = event_load_data_pull_up;
        self.currentPageNo = self.currentPageNo + 1;
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down){
        [self.expertMessages removeAllObjects];
        [self.expertMessagesFrames removeAllObjects];
        self.currentPageNo = 1;
        self.currentEventType = event_load_data_pull_down;
        [self loadData];
    }
}


#pragma mark 订阅专家
-(void) subscribeExpert
{
    [[SystemStore sharedInstance] getAppInfo:^(AppInfo *appInfo, NSError *err) {
        if ([appInfo.pay isEqualToString:@"false"]) {
            SystemPromptController *promptController = [[SystemPromptController alloc] init];
            promptController.appInfo = appInfo;
            [self.navigationController pushViewController:promptController animated:YES];
        }else{
            SubscribeDescController *subscribeDescController = [[SubscribeDescController alloc] initWithExpert:self.expert];
            [self.navigationController pushViewController:subscribeDescController animated:YES];
        }
    }];
}

#pragma mark 取消订阅专家
-(void) cancelAttentionExpert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定取消关注吗？" message:nil delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark alertView点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UserStore sharedStore] removeAttentionExpert:^(NSError *err) {
            if (err == nil) {
                [SVProgressHUD showErrorWithStatus:@"取消成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_attention_expert object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                ExceptionMsg *msg = [err.userInfo objectForKey:@"ExceptionMsg"];
                [SVProgressHUD showErrorWithStatus:msg.message];
            }
        } expertId:self.expert.id];
    }
}

@end
