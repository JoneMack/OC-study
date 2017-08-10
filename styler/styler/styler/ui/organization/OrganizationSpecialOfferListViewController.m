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
#import "OrganizationSpecialOfferListSectionHeaderView.h"

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
    
    CGRect frame = CGRectMake(0, status_bar_height+navigation_height+organization_filter_menu_height+1.5,
                              screen_width,  main_content_height - organization_filter_menu_height);
    self.specialOfferListTableView = [[UITableView alloc] initWithFrame:frame
                                                                  style:UITableViewStylePlain];
    self.specialOfferListTableView.frame = frame;
    self.specialOfferListTableView.delegate=self;
    self.specialOfferListTableView.dataSource = self;
    self.specialOfferListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.specialOfferListTableView setBackgroundColor:[ColorUtils colorWithHexString:light_gray_color]];
    [self.view addSubview:self.specialOfferListTableView];
    self.marginBlock = [[UIView alloc] init];
    self.marginBlock.frame = CGRectMake(0, 0, screen_width, 10);
    self.marginBlock.backgroundColor = [ColorUtils colorWithHexString:light_gray_color];
    
    organizations = [[NSMutableArray alloc] init];
    loadingView = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [loadingView updateStatus:network_status_loading animating:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // 添加UITableView的headerView
    if (organizations.count > 0) {
        [tableView setTableHeaderView:self.marginBlock];
    }
    
    return organizations.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (organizations.count == section ) {  // 最后一个section
        return 1;
    }
    Organization *organization = organizations[section];
    if (organization.hdcs.count == 1) {
        return 1 + 1;
    }
    if ([showMoreManager containsObject:@(organization.id)]) {
        return [organizations[section] hdcs].count + 1;
    }else{
        return 2 + 1;  // 不显示更多美发卡的情况，一个美发卡，加一个更多的按钮
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(organizations.count == indexPath.section){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [ColorUtils colorWithHexString:light_gray_color];
        [loadingView removeFromSuperview];
        [cell.contentView addSubview:loadingView];
        [cell.contentView setAutoresizesSubviews:NO];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    Organization *organization = organizations[indexPath.section];
    
    if((indexPath.row == 1 && organization.hdcs.count == 1)
       || (indexPath.row == 2 && organization.hdcs.count > 1 && ![showMoreManager containsObject:@(organization.id)])
       || (indexPath.row == organization.hdcs.count && [showMoreManager containsObject:@(organization.id)])){
        static NSString *specialOfferListFooterId = @"specialOfferListFooterId";
        UITableViewCell *footerView = [tableView dequeueReusableCellWithIdentifier:specialOfferListFooterId];
        if (footerView == nil) {
            //底部分隔线:
            footerView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specialOfferListFooterId];
            UIView *bottomLineView = [[UIView alloc] init];
            bottomLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            bottomLineView.frame = CGRectMake(0, 0, screen_width,  splite_line_height);
            [footerView addSubview:bottomLineView];
            
            UIView *marginBlock = [[UIView alloc] init];
            marginBlock.frame = CGRectMake(0, splite_line_height, screen_width, 10);
            marginBlock.backgroundColor = [ColorUtils colorWithHexString:light_gray_color];
            [footerView addSubview:marginBlock];
        }
        return footerView;
    }
    
    if ( indexPath.row == 1 && organization.hdcs.count > 0 && ![showMoreManager containsObject:@(organization.id)]) {
        static NSString *specialOfferShowMoreCellId = @"specialOfferShowMoreCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:specialOfferShowMoreCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
            
            NSString *showMoreTxt = @"更多";
            NSString *showMoreIcon = @"double_arrow_down_icon";
            
            // 查看更多的分隔线 , 根据最后一个卡片获取
            self.showMoreLine = [[UIView alloc] init];
            self.showMoreLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            self.showMoreLine.frame = CGRectMake(10,
                                                 0,
                                                 screen_width-10-10,
                                                 splite_line_height);
            [cell addSubview:self.showMoreLine];
            
            // 查看更多文本
            self.showMoreButton = [[UIButton alloc] init];
            //        self.showMoreButton.backgroundColor = [UIColor purpleColor];
            [self.showMoreButton setTitle:showMoreTxt forState:UIControlStateNormal];
            [self.showMoreButton setImage:[UIImage imageNamed:showMoreIcon] forState:UIControlStateNormal];
            self.showMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            [self.showMoreButton setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
            self.showMoreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.showMoreButton.titleLabel setFont:[UIFont systemFontOfSize:small_font_size]];
            self.showMoreButton.frame = CGRectMake(10, self.showMoreLine.frame.origin.y-0.5, self.showMoreLine.frame.size.width, 25);
            self.showMoreButton.tag = organization.id;
            [cell addSubview:self.showMoreButton];
            
            [self.showMoreButton addTarget:self action:@selector(showOrHideMoreSpecialOffer:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    
    HairDressingCard *hairDressingCard=[organization getNextHairDressingCard:indexPath.row];
    static NSString *specialOfferListCellIdentifier = @"specialOfferListCellIdentifier";
    SpecialOfferCellView *cell = [tableView dequeueReusableCellWithIdentifier:specialOfferListCellIdentifier];
    if (cell == nil) {
        cell = [[SpecialOfferCellView alloc] initWithOrganizationAndHdcs:UITableViewCellStyleDefault
                                                         reuseIdentifier:specialOfferListCellIdentifier
                                                            organization:organization];
    }
    BOOL showOrganizationPic = (indexPath.row == 0 ? YES:NO);
    [cell renderData:organization hairDressingCard:hairDressingCard showOrganizationPic:showOrganizationPic];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == organizations.count) {
        return general_cell_height;
    }
    Organization *organization = organizations[indexPath.section];
    
    if((indexPath.row == 1 && organization.hdcs.count == 1)
       || (indexPath.row == 2 && organization.hdcs.count > 1 && ![showMoreManager containsObject:@(organization.id)])
       || (indexPath.row == organization.hdcs.count && [showMoreManager containsObject:@(organization.id)])){
        return 10;
    }
    
    if (indexPath.row == 1 && organization.hdcs.count>1 && ![showMoreManager containsObject:@(organization.id)]) {
        // 如果美发卡多于1个，第二个位置“更多”的高度
        return 25;
    }
    
    if (indexPath.row == 0 && organization.hdcs.count == 1) {  // 一个商户只有一个美发卡
        return 65;
    }
    
    if (indexPath.row > 0 && organization.hdcs.count == indexPath.row+1) {  // 一个商户有多个美发卡，并且已经展开了的最后一个美发卡。
        return 65;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (organizations.count == section) {
        return 0;
    }
    return 31;
}

/**
 *  每一个section的头部
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (organizations.count == section) {
        return nil;
    }
    Organization *organization = organizations[section];
    static NSString *specialOfferListHeaderIdentifierView = @"specialOfferListSectionHeaderView";
    OrganizationSpecialOfferListSectionHeaderView *sectionHeaderView = [self.specialOfferListTableView dequeueReusableCellWithIdentifier:specialOfferListHeaderIdentifierView];
    if (sectionHeaderView == nil) {
        sectionHeaderView = [[OrganizationSpecialOfferListSectionHeaderView alloc] initWithOrganization:organization identifier:specialOfferListHeaderIdentifierView];
    }
    [sectionHeaderView renderSectionUI:organization];
    return sectionHeaderView;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (organizations.count == section) {
//        return 0;
//    }
//    return 10;
//}
//
//
///**
// *  每一个section的尾部
// */
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    
//    static NSString *specialOfferListFooterId = @"specialOfferListFooterId";
//    UITableViewCell *footerView = [tableView dequeueReusableCellWithIdentifier:specialOfferListFooterId];
//    if (footerView == nil) {
//        //底部分隔线:
//        footerView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specialOfferListFooterId];
//        UIView *bottomLineView = [[UIView alloc] init];
//        bottomLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
//        bottomLineView.frame = CGRectMake(0, 0, screen_width,  splite_line_height);
//        [footerView addSubview:bottomLineView];
//        [footerView addSubview:self.marginBlock];
//    }
//    return footerView;
//}



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
 *判断当前商户的更多美发卡的状态
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


-(void) showOrHideMoreSpecialOffer:(UIButton *)sender{
    [self showOrHideMoreHdcs:sender.tag];
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
                // 商户渲染美发卡
                for (HairDressingCard *hdc in hdcs) {
                    for (Organization *organization in newOrganizations) {
                        if ([hdc.saleRule.organizationIds containsObject:@(organization.id)]) {
                            [organization addHairDressingCard:hdc];
                            break;
                        }
                    }
                }
                for(Organization *organization in newOrganizations){
                    [organization tidyHdcSort:self.organizationFilterView.organizationFilter.hdcCatalogs];
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
