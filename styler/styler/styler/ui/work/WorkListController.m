//
//  LookWorkListController.m
//  styler
//
//  Created by wangwanggy820 on 14-6-4.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WorkListController.h"
#import "AllHairStyleController.h"
#import "LoadingStatusView.h"
#import "WorkCell.h"
#import "StylistWorkStore.h"
#import "UserStore.h"
#import "AppDelegate.h"
#import "FunctionUtils.h"
#import "RewardActivityProcessor.h"

#define scroll_up   0
#define scroll_down 1

#define position_origin         0
#define position_top            1
#define position_up_offset      2
#define position_down_offset    3
#define position_last_row       4


#define search_btn_x     270
#define work_cell_height 380

typedef enum {
    kkkkkk = 1,
    bbbbbb = 2,
}ddd;

@interface WorkListController ()

@end

@implementation WorkListController
{
    LoadingStatusView *loadingView;
    LoadingStatusView *refreshingView;
    int pageNo;
    UIButton *reloadBtn;
    float lastOffsetY;
    int scrollPosition;
    BOOL animating;
    int currentRow;
    BOOL hasShareAppRewardActivity;
    UIButton *rewardActivityBtn;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRequestURL:(NSString *)url title:(NSString *)title type:(int)type
{
    if (self = [super init]) {
        self.url = url;
        self.title = title;
        self.type = type;
        if(self.type == my_fav_work){//我收藏的作品
            self.title = self.title;
        }else if(self.type == stylist_profile_work){
            self.title = [NSString stringWithFormat:@"%@的全部作品", self.title];
        }else if(self.type == common_work){
            self.title = page_name_all_hair_style;
        }else{
            self.title = [NSString stringWithFormat:@"全部%@发型", self.title];
        }
    }
    return self;
}

//程序进入后台后，再次打开后回调用此通知
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnterForegroundNotification)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.currentTableViewStatus = work_list_status_waiting_load;
    
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initTableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserFavStylists)
                                                 name:notification_name_update_fav_stylist
                                               object:nil];
}

#pragma mark ------初始化头部------------------
-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:self.title navigationController:self.navigationController];
    if (self.type == common_work) {
        self.header.backBut.hidden = YES;
//        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(search_btn_x, self.header.backBut.frame.origin.y-3, navigation_height, navigation_height)];
//        [searchBtn setImage:[UIImage imageNamed:@"branch_search_default"] forState:UIControlStateNormal];
//        [searchBtn setImage:[UIImage imageNamed:@"branch_search_select"] forState:UIControlStateHighlighted];
//        [searchBtn addTarget:self action:@selector(searchHairSytle:) forControlEvents:UIControlEventTouchUpInside];
//        [self.header addSubview:searchBtn];
        
        float searchBtnX = screen_width- 50;
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchBtnX , self.header.backBut.frame.origin.y, navigation_height, navigation_height)];
        [searchBtn setTitle:@"分类" forState:UIControlStateNormal];
        [searchBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
        [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:big_font_size]];
        [searchBtn addTarget:self action:@selector(searchHairSytle:) forControlEvents:UIControlEventTouchUpInside];
        [self.header addSubview:searchBtn];
    }

    self.header.title.text = self.title;
    [self.view addSubview:self.header];

    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void)searchHairSytle:(id)sender{
    AllHairStyleController *hairStyle = [[AllHairStyleController alloc] init];
    [self.navigationController pushViewController:hairStyle animated:YES];
    [MobClick event:page_name_all_hair_style attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"所有发型", @"作品", nil]];
}

-(void)initTableView{
    self.tableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    CGRect frame = self.tableView.frame;
    frame.origin.y = self.header.frame.size.height;
    if (self.type == common_work) {
        frame.size.height = self.view.frame.size.height - self.header.frame.size.height - tabbar_height;
    }else{
        frame.size.height = self.view.frame.size.height;
    }
    
    // 判断是否有奖励活动
    RewardActivityProcessor *rap = [RewardActivityProcessor sharedInstance];
    hasShareAppRewardActivity = [rap hasRewardActivityInSharedContentType:shareAppPage] && (self.type != my_fav_work) ;
    
    self.tableView.frame = frame;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.decelerationRate = 0.8;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WorkCell class] forCellReuseIdentifier:@"WorkCell"];
    [self.tableView setContentInset:UIEdgeInsetsMake(0-loading_view_height, 0, 0, 0)];
    lastOffsetY = self.tableView.contentOffset.y;
    scrollPosition = position_top;
    animating = NO;
    
    loadingView = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [loadingView updateStatus:network_status_loading animating:YES];
    
    refreshingView = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [refreshingView updateStatus:network_status_refresh animating:YES];
    
    [self transformEvent:event_init_load];
}

-(void) loadWorkList{
    StylistWorkStore *stylistWorkStore = [StylistWorkStore sharedStore];
    NSString *url = [NSString stringWithFormat:@"%@&pageSize=10&pageNo=%d",self.url,pageNo];
    if (self.type == stylist_profile_work || self.type == common_work || self.type == tag_name_work) {
        [stylistWorkStore getStylistWorksBySearcher:^(Page *page, NSError *err) {
            [self handleLoadData:page];
        } url:url refresh:YES];
    }else{
        [stylistWorkStore getStylistWorksByApi:^(Page *page, NSError *err) {
            [self handleLoadData:page];
        } url:url refresh:YES];
    }
}

-(void) handleLoadData:(Page *)page{
    if (page != nil) {
        if (self.currentTableViewStatus == work_list_status_refreshing) {
            [self.workList removeAllObjects];
        }
        [self.workList addObjectsFromArray:page.items];
        [self.tableView reloadData];
        
        if ([page isLastPage]) {
            [self transformEvent:event_load_over];
        }else{
            [self transformEvent:event_load_success];
        }
        
        // 后台线程遍历作品创建时间
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [self checkoutStylistWorkLastCreateTime:page.items];
//        });
        
        [MobClick event:log_event_name_work_list_paging];
        
    }else{
        [self transformEvent:event_load_fail];
    }
}

-(void)appEnterForegroundNotification{
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 这个地方需要区分不同的列表 （ 收藏不显示 活动 ， 发型师作品列表不显示 ）
    if (hasShareAppRewardActivity) {
        return self.workList.count+3;
    }
    return self.workList.count+2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 有奖励活动的列表
    int controlRow =hasShareAppRewardActivity ? 2:1;
    if (indexPath.row ==0 ) {
        return general_height;
    }
    if (indexPath.row == (self.workList.count+controlRow)|| indexPath.row == controlRow-1) {
        return reward_activity_banner_height;
    }
    StylistWork *work = self.workList[indexPath.row-controlRow];
    return work_cell_height + (work.tagNames.count/6)*title_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {  // 第一个位置
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
        [loadingView removeFromSuperview];
        [cell.contentView addSubview:refreshingView];
        [cell.contentView setAutoresizesSubviews:NO];
        return cell;
    }
    if(hasShareAppRewardActivity && indexPath.row == 1){ // 有奖励活动的第二个位置
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        rewardActivityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        rewardActivityBtn.frame = CGRectMake(0, 0, screen_width, reward_activity_banner_height);
        RewardActivityProcessor *rewardActivityProcessor = [RewardActivityProcessor sharedInstance];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[rewardActivityProcessor getActivityBannerUrl:shareAppPage]]];
        [rewardActivityBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        [rewardActivityBtn addTarget:self
                              action:@selector(shareStylistWorkListPageBtnClick)
                    forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:rewardActivityBtn];
        return cell;
    }
    
    if ((indexPath.row==(self.workList.count+1) && !hasShareAppRewardActivity)
         || (indexPath.row==(self.workList.count+2) && hasShareAppRewardActivity)) { // 有没有奖励的最后一个位置
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
        [loadingView removeFromSuperview];
        [cell.contentView addSubview:loadingView];
        [cell.contentView setAutoresizesSubviews:NO];
        return cell;
    }
    
    static NSString * cellIndentifier = @"WorkCell";
    WorkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (hasShareAppRewardActivity) {
        [cell initUI:self.workList[indexPath.row-2] viewController:self];
    }else{
        [cell initUI:self.workList[indexPath.row-1] viewController:self];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell.work.publishStatus == work_status_open || self.type != my_fav_work) {
        cell.deleteBtn.hidden = YES;
        cell.arrowImage.hidden = NO;
        
    } else if(cell.work.publishStatus == work_status_out_of_stack && self.type == my_fav_work){
        
        cell.deleteBtn.hidden = NO;
        cell.arrowImage.hidden = YES;
        cell.coverPicture.contentMode = UIViewContentModeCenter;
        cell.coverPicture.userInteractionEnabled = NO;
        cell.coverPicture.backgroundColor = [ColorUtils colorWithHexString:gray_place_holder_color];
        [cell.coverPicture setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"work_out_of_stack"]];
        currentRow = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteWorkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)deleteWorkBtnClick:(UIButton *)sender{
    StylistWork *work = [self.workList objectAtIndex:currentRow-1];
    AppStatus *appStatus = [AppStatus sharedInstance];
    [[UserStore sharedStore] removeFavWork:^(NSError *err) {
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功" duration:1.0];
            [appStatus.user removeFavWork:work.id];
            [self.workList removeObjectAtIndex:currentRow-1];
            [self.tableView setEditing:NO animated:YES];
            [self.tableView reloadData];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @(work.id), @"作品id", nil];
            [MobClick event:log_event_name_remove_fav_work attributes:dict];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"删除失败" duration:1.0];
        }
    } userId:appStatus.user.idStr workId:work.id];
}

//点击状态栏，返回最顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.workList.count) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int controlRow = hasShareAppRewardActivity? 2:1;
    
    if (indexPath.row != self.workList.count+controlRow ) {
        
        StylistWork *work = [self.workList objectAtIndex:indexPath.row-controlRow];
        if (work.publishStatus != work_status_open) {
            [SVProgressHUD showWithStatus:@"此作品已下架，请点击删除此作品" maskType:SVProgressHUDMaskTypeNone duration:1];
            return ;
        }
        WorkDetailController *wdc = [[WorkDetailController alloc] init];
        wdc.work = [self.workList objectAtIndex:indexPath.row-controlRow];
        [self.navigationController pushViewController:wdc animated:YES];
    }else if(indexPath.row == (self.workList.count+ controlRow -1)){
        [self loadWorkList];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float currentOffsetY = scrollView.contentOffset.y;
    BOOL headerDisplay = (self.tableView.frame.origin.y == 0)?NO:YES;
    
    //计算滚动方向
    int scrollDirection = scroll_down;
    if (scrollView.contentOffset.y > lastOffsetY) {
        scrollDirection = scroll_up;
    }
    
    //计算当前位置
    if (((int)currentOffsetY) > loading_view_height && (currentOffsetY < (self.tableView.contentSize.height - self.tableView.frame.size.height - loadingView.frame.size.height))) {
        scrollPosition = position_up_offset;
    }else if(((int)currentOffsetY) == loading_view_height){
        scrollPosition = position_top;
    }else if(((int)currentOffsetY) < loading_view_height && currentOffsetY > 0){
        scrollPosition = position_down_offset;
    }else if(((int)currentOffsetY) <= 0){
        scrollPosition = position_origin;
    }else if(currentOffsetY >= (self.tableView.contentSize.height - self.tableView.frame.size.height-loadingView.frame.size.height)){
        animating = NO;
        scrollPosition = position_last_row;
    }
//    NSLog(@">>>> y偏移:%f, 头部：%@, position:%d, %@", scrollView.contentOffset.y, headerDisplay?@"显示":@"不显示", scrollPosition, animating?@"动画中":@"无动画");
    if (!animating) {
        
        //向上滚动到向上偏移的位置将触发隐藏头部
        if (scrollDirection == scroll_up && scrollPosition == position_up_offset && headerDisplay) {
            [self hideHeaderAndUpdateTableViewFrame];
        }
        
        //向下滚动并且头部没有显示的情况下显示头部
        else if(scrollDirection == scroll_down && !headerDisplay){
            [self displayHeaderAndUpdateTableViewFrame];
        }
        
        //向下滚动到向下偏移的位置将触发刷新
        else if(scrollDirection == scroll_down && scrollPosition == position_origin){
            [self transformEvent:event_pull_down];
        }
        
        //向上滚动到最后一行的位置将出发加载更多
        else if(scrollDirection == scroll_up && scrollPosition == position_last_row){
            
//            NSLog(@"上推加载更多:%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
            [self transformEvent:event_pull_up];
        }
    }
    
    lastOffsetY = scrollView.contentOffset.y;
}

-(void) hideHeaderAndUpdateTableViewFrame{

    [UIView animateWithDuration:0.5
     
                     animations:^{
                         animating = YES;
                         self.header.frame = CGRectMake(0, -self.header.frame.size.height - splite_line_height, screen_width, self.header.frame.size.height);
                         self.tableView.frame = CGRectMake(0, 0, screen_width, [self judgeTableViewHeight:NO]);
                     }
     
                     completion:^(BOOL finished) {
                         animating = NO;
                     }
     ];
}

-(void)displayHeaderAndUpdateTableViewFrame{

    [UIView animateWithDuration:0.5
                     animations:^{
                         animating = YES;
                         self.header.frame = CGRectMake(0, 0, screen_width, self.header.frame.size.height);
                         self.tableView.frame = CGRectMake(0, self.header.frame.size.height, screen_width, [self judgeTableViewHeight:YES]);
                     }
     
                     completion:^(BOOL finished) {
                         animating = NO;
                     }
     ];
}

-(float) judgeTableViewHeight:(BOOL)displayHeader{
    if (!displayHeader) {
        float tableViewHeight = 0;
        
        if (self.type == common_work) {
            tableViewHeight = self.view.frame.size.height - tabbar_height;
        }else{
            tableViewHeight = self.view.frame.size.height;
        }
        return tableViewHeight;
    }
    
    float tableViewHeight = 0;
    if (self.type == common_work) {
        tableViewHeight = self.view.frame.size.height - self.header.frame.size.height - tabbar_height;
    }else{
        tableViewHeight = self.view.frame.size.height - self.header.frame.size.height;
    }

    return tableViewHeight;
}

-(void)updateUserFavStylists{
    [self transformEvent:work_list_status_refreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)transformEvent:(int)eventType{

    if (self.currentTableViewStatus == work_list_status_waiting_load
        && eventType == event_init_load) {
        pageNo = 1;
        self.workList = [NSMutableArray new];
        [self.tableView reloadData];
        self.currentTableViewStatus = work_list_status_loading;
        [self loadWorkList];
    }else if (self.currentTableViewStatus == work_list_status_loading
              && eventType == event_load_success){
        [loadingView updateStatus:network_status_loading animating:NO];
        self.currentTableViewStatus = work_list_status_waiting_load;
        pageNo += 1;
    }else if (self.currentTableViewStatus == work_list_status_refreshing
              && (eventType == event_load_success || eventType == event_load_over)){
        [self.tableView setContentInset:UIEdgeInsetsMake(-loading_view_height, 0, 0, 0)];
        self.currentTableViewStatus = work_list_status_waiting_load;
        [refreshingView updateStatus:network_status_refresh animating:YES];
        pageNo += 1;
        
        AppStatus *appStatus = [AppStatus sharedInstance];
        appStatus.hasNewStylistWorks = NO;
        [AppStatus saveAppStatus];
        [appStatus updateBadge];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_has_new_stylist_works object:nil];
        
    }else if(self.currentTableViewStatus == work_list_status_refreshing && eventType == event_load_fail){
        [self.tableView setContentInset:UIEdgeInsetsMake(-loading_view_height, 0, 0, 0)];
        self.currentTableViewStatus = work_list_status_waiting_load;
        [refreshingView updateStatus:network_status_refresh animating:YES];
    }else if((self.currentTableViewStatus == work_list_status_load_fail ||
              self.currentTableViewStatus == work_list_status_waiting_load )
             && eventType == event_pull_up){
        self.currentTableViewStatus = work_list_status_loading;
        [self loadWorkList];
    }else if(self.currentTableViewStatus == work_list_status_loading
             && eventType == event_load_over){
        self.currentTableViewStatus = work_list_status_load_over;
        [loadingView updateStatus:network_status_no_more animating:NO];
    }else if(self.currentTableViewStatus == work_list_status_loading
             && eventType == event_load_fail){
        self.currentTableViewStatus = work_list_status_load_fail;
        [loadingView updateStatus:network_status_retry animating:NO];
    }else if((self.currentTableViewStatus == work_list_status_waiting_load ||
              self.currentTableViewStatus == work_list_status_load_fail ||
              self.currentTableViewStatus == work_list_status_load_over)
             && eventType == event_pull_down){
        pageNo = 1;
        self.currentTableViewStatus = work_list_status_refreshing;
        [refreshingView updateStatus:network_status_refreshing animating:YES];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self loadWorkList];
        [[AppStatus sharedInstance] setHasNewStylistWorks:NO];
        [AppStatus saveAppStatus];
        
    }
}

-(void) checkoutStylistWorkLastCreateTime:(NSArray *) stylistWorks{
    
    if (stylistWorks.count == 0) {
        return;
    }
    
    AppStatus *appStatus = [AppStatus sharedInstance];
    if (appStatus.latestWorkCreateTime == nil || appStatus.latestWorkCreateTime == 0) {
        appStatus.latestWorkCreateTime = [DateUtils dateFromLongLongInt:[stylistWorks[0] createTime]];
        [AppStatus saveAppStatus];
    }
    
    for (StylistWork *stylistWork in stylistWorks) {
        NSDate *workCreateTime = [DateUtils dateFromLongLongInt:stylistWork.createTime];
        if ([DateUtils compare:workCreateTime date2:appStatus.latestWorkCreateTime] == 2) {
            appStatus.latestWorkCreateTime = workCreateTime;
            [AppStatus saveAppStatus];
        }
    }
}

-(void) refreshTableView{
    self.currentTableViewStatus = work_list_status_waiting_load;
    [self transformEvent:event_init_load];
}

#pragma mark 发型师作品列表奖励活动方法
-(void) shareStylistWorkListPageBtnClick{
    [[RewardActivityProcessor sharedInstance] tryDisplayMovement:self];
}

-(ShareContent *) collectionShareContent{
    NSString *content = [NSString stringWithFormat:share_app_txt];
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@ ",share_app_txt,shishangmaoWebShortURL];
    self.shareImage = [UIImage imageNamed:@"logo_1024"];
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:nil
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:shishangmaoWebShortURL
                                                               image:self.shareImage
                                                            imageUrl:nil
                                                    shareContentType:shareAppPage];
    return shareContent;
}

-(NSString *)getPageName{
    if(self.type == my_fav_work){//我收藏的作品
        return page_name_my_fav_works;
    }else if(self.type == stylist_profile_work){
        return page_name_stylist_work_list;
    }else if(self.type == common_work){
        return page_name_all_hair_style;
    }else{
        return page_name_tag_work_list;
    }
    return self.title;
}
@end
