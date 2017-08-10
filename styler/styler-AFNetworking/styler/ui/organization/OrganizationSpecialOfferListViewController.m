//
//  OrganizationSpecialOfferListViewController.m
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define remind_block_view_width          5
#define cell_margin_up                   10

#import "OrganizationSpecialOfferListViewController.h"
#import "UILabel+Custom.h"
#import "UIViewController+Custom.h"
#import "Organization.h"
#import "HairDressingCard.h"
#import "OrganizationStore.h"
#import "HdcStore.h"
#import "LoadingStatusView.h"

@interface OrganizationSpecialOfferListViewController ()

@end

@implementation OrganizationSpecialOfferListViewController
{
    
    NSMutableArray *organizations;
    NSMutableArray *showMoreManager;
    LoadingStatusView *loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter{
    self = [super init];
    if (self) {
        self.organizationFilter = organizationFilter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initOrganizationFilter];
    [self initSpecialOfferListTableView];
    [self setCurrentTableViewStatus:special_offer_list_status_waiting_load];
    [self transformEvent:event_init_load];
}

- (void)initHeader
{
    self.header = [[HeaderView alloc] initWithTitle:page_name_organization_special_offer_list
                               navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) initOrganizationFilter{
    self.organizationFilterView = [[OrganizationFilterView alloc] initWithOrganizationFilter:self.organizationFilter];
    self.organizationFilterView.frame = CGRectMake(0, status_bar_height+navigation_height+1, screen_width, main_content_height);
    self.organizationFilterView.delegate = self;
    [self.view addSubview:self.organizationFilterView];
}

-(void) initSpecialOfferListTableView{
    
    self.specialOfferListTableView = [[UITableView alloc] init];
    CGRect frame = CGRectMake(0, status_bar_height+navigation_height+organization_filter_menu_height+1.5,
                              screen_width,  main_content_height - organization_filter_menu_height);
    self.specialOfferListTableView.frame = frame;
    self.specialOfferListTableView.delegate=self;
    self.specialOfferListTableView.dataSource = self;
    self.specialOfferListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.specialOfferListTableView setBackgroundColor:[ColorUtils colorWithHexString:light_gray_color]];
    [self.view addSubview:self.specialOfferListTableView];
    
    organizations = [[NSMutableArray alloc] init];
    loadingView = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [loadingView updateStatus:network_status_loading animating:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return organizations.count+1;  // 加1 是最底部的那个加载状态cell
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(organizations.count == indexPath.row){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [ColorUtils colorWithHexString:light_gray_color];
        [loadingView removeFromSuperview];
        [cell.contentView addSubview:loadingView];
        [cell.contentView setAutoresizesSubviews:NO];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    Organization *organization = organizations[indexPath.row];
    static NSString *specialOfferListCellIdentifier = @"specialOfferListCellIdentifier";
    SpecialOfferCellView *cell = [tableView dequeueReusableCellWithIdentifier:specialOfferListCellIdentifier];
    if (cell == nil) {
        cell = [[SpecialOfferCellView alloc] initWithOrganizationAndHdcs:UITableViewCellStyleDefault
                                                         reuseIdentifier:specialOfferListCellIdentifier
                                                            organization:organization
                                                                 hdcType:self.organizationFilter.selectedHdcTypeValue
                                                            showMoreFlag:[self getShowMoreFlag:organization]];
        
        cell.delegate = self;
    }
    [cell renderData:organization hdcType:self.organizationFilter.selectedHdcTypeValue showMoreFlag:[self getShowMoreFlag:organization]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == organizations.count) {
        return general_cell_height;
    }
    // 如果滑动时有性能问题，这个地方可以优化。
    Organization *organization = organizations[indexPath.row];
    return [SpecialOfferCellView getHeightByHdcs:organization.hdcs showMoreFlag:[self getShowMoreFlag:organization]];
}

#pragma mark 显示或隐藏更多美发卡
-(void) showOrHideMoreHdcs:(int) organizationId{
    if ([self showMoreManagerHasOrganizationId:organizationId]) {
        [showMoreManager removeObject:@(organizationId)];
    }else{
        [showMoreManager addObject:@(organizationId)];
    }
    [self.specialOfferListTableView reloadData];
}

/**
 *判断当前机构的更多美发卡的状态
 */
-(BOOL) showMoreManagerHasOrganizationId:(int)organizationId{
    
    if (showMoreManager == nil) {
        showMoreManager = [[NSMutableArray alloc] init];
        return false;
    }
    for (int i=0 ; i<showMoreManager.count; i++) {
        NSNumber *orgId =  showMoreManager[i];
        if (organizationId == [orgId intValue]) {
            return true;
        }
    }
    return false;
}

-(int) getShowMoreFlag:(Organization *) organization{
    if (organization.hdcs.count == 1) {
        return show_more_none;
        
    }else if(organization.hdcs.count >1){
        
        if ([self showMoreManagerHasOrganizationId:organization.id]) {
            return show_more_cards;
        }
        return show_more_txt;
    }
    return show_more_none;
}

/**
 *  当过滤条件改变时，触发该方法
 */
-(void) organizationFilterConditionChanged{
    [organizations removeAllObjects];
    [self.specialOfferListTableView reloadData];
    [self.organizationFilter setPageNo:1];
    [showMoreManager removeAllObjects];
    [loadingView updateStatus:network_status_loading animating:NO];
    [self setCurrentTableViewStatus:special_offer_list_status_loading];
    [self getOrganziationsAndHdcs];
}

-(void) getOrganziationsAndHdcs{
    [SVProgressHUD showWithStatus:network_status_loading];
    [OrganizationStore getOrganizationsWithOrganizationFilter:^(Page *page, NSError *error) {
        if (error != nil) {
            [SVProgressHUD dismiss];
            [self transformEvent:event_load_fail];
            return;
        }
        
        NSArray *newOrganizations = page.items;
        NSMutableArray *organizationIds = [[NSMutableArray alloc] init];
        for (Organization *organization in newOrganizations) {
            [organizationIds addObject:@(organization.id)];
        }
        if (page.items.count > 0){
            [HdcStore searcherHdcsByOrganizationIds:^(NSArray *hdcs, NSError *error) {
                // 机构渲染美发卡
                for (HairDressingCard *hdc in hdcs) {
                    for (Organization *organization in newOrganizations) {
                        if ([hdc.saleRule.organizationIds containsObject:@(organization.id)]) {
                            [organization addHairDressingCard:hdc];
                            break;
                        }
                    }
                }
                for(Organization *organization in newOrganizations){
                    [organization tidyHdcSort:self.organizationFilterView.organizationFilter.hdcTypes];
                }
                [organizations addObjectsFromArray:newOrganizations];
                [self.specialOfferListTableView reloadData];
                [SVProgressHUD dismiss];
                if(organizations.count == page.totalCount){
                    [self transformEvent:event_load_over];
                }else{
                    [self transformEvent:event_load_success];
                }
            } organizationIds:organizationIds organizationFilter:self.organizationFilter];
            
        }else{  // 该种美发卡类型该商圈没有
            
            [SVProgressHUD dismiss];
            [self transformEvent:event_load_over];
        }
    } organizationFilter:self.organizationFilter];
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
}

#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if (self.currentTableViewStatus == special_offer_list_status_waiting_load
        && eventType == event_init_load) {
        // 初始化加载
        self.currentTableViewStatus = special_offer_list_status_loading;
        [self getOrganziationsAndHdcs];
        
    }else if(self.currentTableViewStatus == special_offer_list_status_loading
             && eventType == event_load_success){
        // 数据加载成功
        self.currentTableViewStatus = special_offer_list_status_waiting_load;
        self.organizationFilter.pageNo++;
        
    }else if(self.currentTableViewStatus == special_offer_list_status_loading
             && eventType == event_load_over){
        // 数据加载结束
        self.currentTableViewStatus = special_offer_list_status_load_over;
        [loadingView updateStatus:network_status_no_more animating:NO];
        
    }else if(self.currentTableViewStatus == special_offer_list_status_load_fail){
        // 数据加载失败
        self.currentTableViewStatus = special_offer_list_status_load_fail;
        
    }else if(self.currentTableViewStatus == special_offer_list_status_waiting_load
             && eventType == event_pull_up){
        // 上拉加载数据
        self.currentTableViewStatus = special_offer_list_status_loading;
        [self getOrganziationsAndHdcs];
        
    }
}

#pragma mark 滚动监听
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float currentOffsetY = scrollView.contentOffset.y;
    
    if (currentOffsetY >=  self.specialOfferListTableView.contentSize.height - self.specialOfferListTableView.frame.size.height
        && self.currentTableViewStatus != special_offer_list_status_load_over) {
        [self transformEvent:event_pull_up];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_organization_special_offer_list;
}

@end
