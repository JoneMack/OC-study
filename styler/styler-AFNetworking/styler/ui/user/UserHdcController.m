//
//  UserHdcController.m
//  styler
//
//  Created by wangwanggy820 on 14-7-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserHdcController.h"
#import "HdcStore.h"
#import "HdcDigestView.h"
#import "UserHdcCell.h"
#import "OrganizationStore.h"
#import "AlipayProcessor.h"
#import "AppDelegate.h"
#import "WebContainerController.h"
#import "ConfirmHdcOrderController.h"
#import "UIViewController+Custom.h"
#import "CustomSegmentView.h"
#import "UserHdcDetailController.h"

@interface UserHdcController ()

@end

@implementation UserHdcController
{
    HeaderView *header;
    LoadingStatusView *loadingView;
    int currentRow;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCardStatus:(NSArray *)cardStatuses
{
    self = [super init];
    if (self) {
        self.currentCardStatuses = cardStatuses;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renderUserHdcNavView) name:notification_name_update_has_unpayment_hdc object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPageNO = 1;
    self.currentTableViewStatus = table_view_status_waiting;
    [self initHeader];
    [self initUserHdcNavView];
    [self initLoadingStatusView];
    [self setRightSwipeGesture];
    [self initTableView];
    
    [self checkLocalPaidUserHdcAndInitLoad];
}

-(void)initHeader
{
    header = [[HeaderView alloc]initWithTitle:page_name_my_hdcs navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void)initTableView
{
    self.userHdcsTableView.delegate = self;
    self.userHdcsTableView.dataSource = self;
    self.userHdcsTableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    CGRect frame = self.userHdcsTableView.frame;
    frame.origin.y = header.frame.size.height+splite_line_height+general_cell_height;
    frame.size.height =  self.view.frame.size.height-header.frame.size.height-splite_line_height-general_cell_height;
    self.userHdcsTableView.frame = frame;
    self.userHdcsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.userHdcsTableView registerClass:[UserHdcCell class] forCellReuseIdentifier:@"UserHdcCell"];
    
}

-(void)loadData:(BOOL)reload
{
    AppStatus *as = [AppStatus sharedInstance];
    [loadingView updateStatus:network_status_loading animating:YES];
    [HdcStore getUserHdcByUserId:^(Page *page, NSError *error) {
        if (page != nil) {
            if (reload) {
                self.userHdcs = [NSMutableArray new];
                self.organizations = [NSMutableArray new];
            }
            
            if (self.userHdcNavView.currentIndex == 0) {
                [[PayProcessor sharedInstance] mergePaidCardsWithLocal:page];
            }else if(self.userHdcNavView.currentIndex == 1){
                [[PayProcessor sharedInstance] mergeUnpaymentCardsWithLocal:page];
            }
            [self.userHdcs addObjectsFromArray:page.items];
            
            [self.userHdcsTableView reloadData];
            
            //遍历用户美发卡获取机构id数组
            NSMutableString *orgIds = [NSMutableString new];
            for (int i = 0; i < page.items.count; i++) {
                UserHdc *userHdc = (UserHdc *)page.items[i];
                if (i != (page.items.count-1)) {
                    [orgIds appendFormat:@"%d,", userHdc.organizationId];
                }else{
                    [orgIds appendFormat:@"%d", userHdc.organizationId];
                }
            }
            
            BOOL hasNexPage = page.totalCount>(self.currentPageNO*user_hdc_page_size);
            //根据机构id数组获取机构列表
            NSString *url = [OrganizationStore getRequestUrlWithOrganizationIds:orgIds];
            [OrganizationStore getOrganizationByUrl:^(Page *page, NSError *error) {
                [self.organizations addObjectsFromArray:page.items];
                [self.userHdcsTableView reloadData];
                if (hasNexPage) {
                    [self transformEvent:event_load_complete_succes];
                }else{
                    [self transformEvent:event_load_complete_over];
                }
            } url:url];
        }else if(page == nil){
            [self transformEvent:event_load_complete_fail];
        }
    } userId:as.user.idStr.intValue pageNo:self.currentPageNO cardStatus:self.currentCardStatuses];
}

-(void)initUserHdcNavView
{
    NSArray *btnTitleArray = [[NSArray alloc] initWithObjects:@"未使用",@"未付款",@"已使用",@"退款", nil];
    self.userHdcNavView = [[CustomSegmentView alloc] initWithFrame:CGRectMake(0, header.frame.size.height+splite_line_height, screen_width, general_cell_height)];
    [self.userHdcNavView render:btnTitleArray currentIndex:[self getSelectIndex]];
    self.userHdcNavView.delegate = self;
    self.userHdcNavView.backgroundColor = [ColorUtils colorWithHexString:white_text_color];
    
    UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, general_cell_height-splite_line_height, screen_width, splite_line_height)];
    downSpeliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.userHdcNavView addSubview:downSpeliteLine];
    [self.view addSubview:self.userHdcNavView];
    
    [self renderUserHdcNavView];
}

-(void)renderUserHdcNavView{
    AppStatus *as = [AppStatus sharedInstance];
    [self.userHdcNavView renderRedDot:1 showRedDot:as.hasUnpaymentHdc];
}

-(void) initLoadingStatusView{
    self.lsv = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [self.lsv updateStatus:network_status_loading animating:YES];
}

//根据当前的美发卡状态获取选中的位序
-(int)getSelectIndex{
    if ([self.currentCardStatuses isEqualToArray:[[NSArray alloc] initWithObjects:@(user_card_status_paid), nil]]) {
        return 0;
    }else if ([self.currentCardStatuses isEqualToArray:[[NSArray alloc] initWithObjects:@(user_card_status_unpayment), nil]]) {
        return 1;
    }else if ([self.currentCardStatuses isEqualToArray:[[NSArray alloc] initWithObjects:@(user_card_status_used), nil]]) {
        return 2;
    }else if ([self.currentCardStatuses isEqualToArray:[[NSArray alloc] initWithObjects:@(user_card_status_refunded), @(user_card_status_request_refund), nil]]) {
        return 3;
    }
    return 0;
}

-(void)selectSegment:(int)inx
{
    switch (inx) {
        case 0:
            self.currentCardStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_paid), nil];
            [MobClick event:log_event_name_view_my_hdcs attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          @"已支付", @"类型", nil]];
            break;
        case 1:
            self.currentCardStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_unpayment), nil];
            [MobClick event:log_event_name_view_my_hdcs attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          @"未支付", @"类型", nil]];
            break;
        case 2:
            self.currentCardStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_used), nil];
            [MobClick event:log_event_name_view_my_hdcs attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          @"已使用", @"类型", nil]];
            break;
        case 3:
            self.currentCardStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_refunded), @(user_card_status_request_refund), nil];
            [MobClick event:log_event_name_view_my_hdcs attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          @"退款", @"类型", nil]];
            break;
        default:
            break;
    }
    [self transformEvent:event_init_load];
}

-(void)checkLocalPaidUserHdcAndInitLoad{
    NSMutableArray *userHdcNumArray = [NSMutableArray new];
    PayProcessor *payProcessor = [PayProcessor sharedInstance];
    NSMutableArray *localPaidHdcs = payProcessor.paidCards;
    if (localPaidHdcs != nil && localPaidHdcs.count > 0) {
        for (int i = 0; i < localPaidHdcs.count; i++) {
            UserHdc *localPaidHdc = localPaidHdcs[i];
            [userHdcNumArray addObject:localPaidHdc.hdcNum];
        }
        NSString *userHdcNums = [userHdcNumArray componentsJoinedByString:@","];
        [HdcStore getUserHdcByUserHdcNums:^(NSArray *remoteUserHdcs, NSError *error) {
            for (int j = 0; j < remoteUserHdcs.count; j++) {
                UserHdc *remoteUserHdc = (UserHdc *)remoteUserHdcs[j];
                if (remoteUserHdc.orderItemStatus == user_card_status_used
                    || remoteUserHdc.orderItemStatus == user_card_status_paid) {
                    int i = 0;
                    for (; i < localPaidHdcs.count; i++) {
                        UserHdc *localPaidHdc = localPaidHdcs[i];
                        if (localPaidHdc.id == remoteUserHdc.id) {
                            break;
                        }
                    }
                    [localPaidHdcs removeObjectAtIndex:i];
                    [payProcessor savePayProcessor];
                }
            }
            [self transformEvent:event_init_load];
        } userHdcNums:userHdcNums];
    }else{
        [self transformEvent:event_init_load];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userHdcs.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return user_hdc_cell_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UserHdcCell";
    if (indexPath.row == ([self.userHdcsTableView numberOfRowsInSection:0]-1)) {
        UITableViewCell *cell = [UITableViewCell new];
        float y = (user_hdc_cell_height-loading_view_height)/2;
        CGRect frame = self.lsv.frame;
        frame.origin.y = y;
        self.lsv.frame = frame;
        [cell.contentView addSubview:self.lsv];
        return cell;
    }else{

        UserHdcCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UserHdc *userHdc = [self.userHdcs objectAtIndex:indexPath.row];
        Organization *org = [self getOrganization:userHdc.organizationId];
        [cell render:userHdc organization:org withSplite:YES last:(indexPath.row==self.userHdcs.count-1?YES:NO)];
        [cell.cancelBtn addTarget:self action:@selector(cancelThisUnpaymentHdc:) forControlEvents:UIControlEventTouchUpInside];
        cell.cancelBtn.tag = indexPath.row;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == ([tableView numberOfRowsInSection:0]-1)) {
        [self transformEvent:event_click_load];
    }else{
        UserHdc *userHdc = self.userHdcs[indexPath.row];
        if (userHdc.orderItemStatus == user_card_status_unpayment)
        {
            ConfirmHdcOrderController *chc = [[ConfirmHdcOrderController alloc] init];
            chc.payModel = pay_model_user_hdc;
            chc.userHdcNum = userHdc.hdcNum;
            chc.lockedRedEnvelopeId = userHdc.getRedEnvelopeId;
            chc.from = @"myHDC";

            [self.navigationController pushViewController:chc animated:YES];
        }else{
            UserHdc *userHdc = self.userHdcs[indexPath.row];
            AppStatus *as = [AppStatus sharedInstance];
            NSString *url = [NSString stringWithFormat:@"%@/app/userHdcs/%@?Authorization=%@", as.webPageUrl, userHdc.hdcNum, as.user.accessToken];
            if (userHdc.orderItemStatus == user_card_status_paid){
                UserHdcDetailController *udc = [[UserHdcDetailController alloc] initWithUrl:url title:@"美发卡详情"];
                [self.navigationController pushViewController:udc animated:YES];
            }else{
                WebContainerController *wcc = [[WebContainerController alloc] initWithUrl:url title:@"美发卡详情"];
                [self.navigationController pushViewController:wcc animated:YES];
            }
        }
    }
}

-(void)cancelThisUnpaymentHdc:(id)sender{
    [SVProgressHUD showWithStatus:network_status_cancel];
    UIButton *btn = (UIButton *)sender;
    UserHdc *userHdc = [self.userHdcs objectAtIndex:btn.tag];
    NSMutableArray *hdcNums = [NSMutableArray new];
    [hdcNums addObject:userHdc.hdcNum];
    [HdcStore updateUserHdcStatus:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功" duration:1.0];
            [SVProgressHUD dismiss];
            [self.userHdcs removeObjectAtIndex:btn.tag];
            [self.userHdcsTableView setEditing:NO animated: YES ];
            [self.userHdcsTableView reloadData];
        }
        [HdcStore checkUnpaymentAmountHdcs:^(NSError *error) {
        }];
    } userHdcNums:hdcNums hdcStatus:1];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height > 0 && scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size.height)) {
        [self transformEvent:event_pull_up];
    }
}

-(void)transformEvent:(int)eventType{
    if((self.currentTableViewStatus == table_view_status_waiting
        || self.currentTableViewStatus == table_view_status_load_over)
       && eventType == event_init_load){

        //正在加载中禁止用户产生交互
        [self.userHdcNavView setUserInteractionEnabled:NO];
        
        [self.userHdcs removeAllObjects];
        [self.organizations removeAllObjects];
        [self.userHdcsTableView reloadData];
        self.currentTableViewStatus = table_view_status_loading;
        [self.lsv updateStatus:network_status_loading animating:YES];
        
        self.currentPageNO = 1;
        //加载数据
        [self loadData:YES];
    }else if (self.currentTableViewStatus == table_view_status_waiting && eventType == event_pull_up) {

        //正在加载中禁止用户产生交互
        [self.userHdcNavView setUserInteractionEnabled:NO];
        
        //更新加载状态视图到正在加载的效果
        [self.lsv updateStatus:network_status_loading animating:YES];
        self.currentPageNO = self.currentPageNO + 1;
        
        self.currentTableViewStatus = table_view_status_loading;
        
        //加载数据
        [self loadData:NO];
    }else if(self.currentTableViewStatus == table_view_status_loading && eventType == event_load_complete_fail){

        //更新加载状态视图到加载失败的效果
        [self.lsv updateStatus:network_request_fail animating:NO];
        self.currentPageNO = self.currentPageNO - 1;
        
        //加载失败后允许用户产生交互
        [self.userHdcNavView setUserInteractionEnabled:YES];
        
        self.currentTableViewStatus = table_view_status_load_fail;
    }else if(self.currentTableViewStatus == table_view_status_loading && eventType == event_load_complete_over){

        [self.lsv updateStatus:[self getNoMoreNote] animating:NO];
        
        //加载完成后允许用户产生交互
        [self.userHdcNavView setUserInteractionEnabled:YES];
        
        self.currentTableViewStatus = table_view_status_load_over;
    }else if(self.currentTableViewStatus == table_view_status_loading && eventType == event_load_complete_succes){

        [self.lsv updateStatus:network_status_loading animating:YES];
        
        //加载成功允许用户产生交互
        [self.userHdcNavView setUserInteractionEnabled:YES];
        
        self.currentTableViewStatus = table_view_status_waiting;
    }else if(self.currentTableViewStatus == table_view_status_load_fail
             && (eventType == event_pull_up || eventType == event_click_load)
             && [[AppStatus sharedInstance] isConnetInternet]){

        //加载失败后重新加载禁止用户输入
        [self.userHdcNavView setUserInteractionEnabled:NO];
        
        self.currentTableViewStatus = table_view_status_loading;

        [self.lsv updateStatus:network_status_loading animating:YES];
        //加载数据
        self.currentPageNO = self.currentPageNO + 1;
        [self loadData:NO];
    }
}

-(NSString *) getNoMoreNote{
    if (self.userHdcs.count == 0) {
        switch (self.userHdcNavView.currentIndex) {
            case 0:
                return @"没有未使用美发卡，请去您熟悉的美发沙龙或发型师主页购买美发卡。";
            case 1:
                return @"没有未付款美发卡";
            case 2:
                return @"没有已使用美发卡";
            case 3:
                return @"没有退款美发卡";
            default:
                break;
        }
    }
    
    return network_status_no_more;
}

-(Organization *)getOrganization:(int)orgId{
    if (self.organizations != nil && self.organizations.count > 0) {
        for(Organization *org in self.organizations){
            if (org.id == orgId) {
                return org;
            }
        }
    }
    return nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[((AppDelegate*)[UIApplication sharedApplication].delegate)tabbar].tabbarController hidesTabBar:YES animated:NO];
}

-(NSString *)getPageName{
    return page_name_my_hdcs;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
