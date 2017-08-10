//
//  MyOrderController.m
//  styler
//
//  Created by System Administrator on 13-6-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "MyOrderController.h"
#import "OrderStore.h"
#import "ServiceOrder.h"
#import "MyOrderCell.h"
#import "OrderDetailInfoController.h"
#import "PushProcessor.h"
#import "AppDelegate.h"
#import "LeveyTabBar.h"
#import "LoadingStatusView.h"
#import "PostEvaluationController.h"
#import "ServiceOrder.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#import "StylistStore.h"

@interface MyOrderController ()

@end

@implementation MyOrderController
{
    NSMutableArray *unEvaluations;
    LoadingStatusView *loading;
    int pageSize;
}
static NSString *orderCellIdentifier = @"orderCellIdentifier";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithOrders:(NSMutableArray *)orders filteType:(int)filteType
{
    self = [super init];
    self.orders = orders;
    self.filteType = filteType;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPageNO = 1;
    pageSize = 10;
    self.currentTableViewStatus = table_view_status_waiting;
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initOrderListTable];
    [self initLoadingStatusView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initOrderListTable) name:notification_name_order_changed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:notification_name_update_post_queue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:notification_name_update_my_evaluations object:nil];
    //接收用户登录的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyOrders) name:notification_name_user_login object:nil];
}

//初始化头部
-(void)initHeader{
    //根据filteType来设置标题
    self.title = (self.filteType == filte_type_all)?my_order_title:my_unevalaution_title;
    
    self.header = [[HeaderView alloc] initWithTitle:self.title navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) initOrderListTable{
    int height = self.view.frame.size.height - self.header.frame.size.height;
    self.orderListTable.frame = CGRectMake(0, self.header.frame.size.height, screen_width, height);
    self.orderListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderListTable.delegate = self;
    self.orderListTable.dataSource = self;
    [self.orderListTable registerClass:MyOrderCell.class forCellReuseIdentifier:orderCellIdentifier];
    if (self.orders == nil) {
        [self transformEvent:event_init_load];
    }else{
        [self loadStylists];
    }
}

-(void) initLoadingStatusView{
    loading = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [loading updateStatus:network_status_loading animating:YES];
}

-(void)getMyOrders:(BOOL)reload{
    [loading updateStatus:network_status_loading animating:YES];
    OrderStore *orderStore = [OrderStore sharedStore];
    [orderStore getMyOrders:^(Page *page, NSError *err) {
        if (reload) {
            self.orders = [NSMutableArray new];
        }
        [self.orders addObjectsFromArray:page.items];
        
        if (self.filteType == filte_type_unevaluation) {
            unEvaluations = [[NSMutableArray alloc] init];
            for (ServiceOrder *unEvaluationOrder in self.orders) {
                if (unEvaluationOrder.orderStatus == order_status_completed && unEvaluationOrder.evaluationStatus == evaluation_status_unpost) {
                    [unEvaluations addObject:unEvaluationOrder];
                }
            }
            self.orders = unEvaluations;
        }
        
        [self.orderListTable reloadData];
        if (self.filteType != filte_type_unevaluation) {
            BOOL hasNexPage = page.totalCount>(self.currentPageNO*pageSize);
            if (hasNexPage) {
                [self transformEvent:event_load_complete_succes];
            }else{
                [self transformEvent:event_load_complete_over];
            }
        }else{
            [self transformEvent:event_load_complete_over];
        }
//        if (self.filteType == filte_type_unevaluation && self.orders.count == 0) {
//            [loading updateStatus:@"没有需要评价的预约" animating:NO];
//        }
        [self loadStylists];
    }pageNo:self.currentPageNO pageSize:pageSize];
}

-(void) loadStylists{
    NSMutableArray *stylistIds = [NSMutableArray new];
    for (ServiceOrder *order in self.orders) {
        if (![stylistIds containsObject:@(order.stylistId)]) {
            [stylistIds addObject:@(order.stylistId)];
        }
    }
    NSString *stylistIdStrs = [stylistIds componentsJoinedByString:@","];
    NSString *url = [StylistStore getUriByStylistIds:stylistIdStrs];
    [[StylistStore sharedStore] getStylist:^(Page *page, NSError *err) {
        if (page != nil) {
            NSArray *stylists = page.items;
            for (ServiceOrder *order in self.orders) {
                for (Stylist *stylist in stylists) {
                    if (stylist.id == order.stylistId) {
                        order.stylist = stylist;
                    }
                }
            }
            [self.orderListTable reloadData];
        }
    } uriStr:url refresh:YES];
}

-(void)refreshOrderList
{
    [self.orderListTable reloadData];
}

#pragma mark- OrderListTable datasource & delegate
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return order_cell_height;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orders.count + 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.orders.count) {
        UITableViewCell *cell = [UITableViewCell new];
        float y = (order_cell_height-loading_view_height)/2;
        CGRect frame = loading.frame;
        frame.origin.y = y;
        loading.frame = frame;
        [cell.contentView addSubview:loading];
        return cell;
    }else{
        MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
        [cell.evaluationBtn addTarget:self action:@selector(jumpToPostEvaluationPage:) forControlEvents:UIControlEventTouchUpInside];
        cell.evaluationBtn.tag = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [cell renderOrderView:self.orders[indexPath.row]];
        return cell;
    }
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.orderListTable) {
        if (scrollView.contentSize.height > 0 && scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size.height-self.header.frame.size.height)) {
            [self transformEvent:event_pull_up];
        }
    }
}

-(void)transformEvent:(int)eventType{
    if((self.currentTableViewStatus == table_view_status_waiting
        || self.currentTableViewStatus == table_view_status_load_over)
       && eventType == event_init_load){
        
        [self.orders removeAllObjects];
        [self.orderListTable reloadData];
        self.currentTableViewStatus = table_view_status_loading;
        [loading updateStatus:network_status_loading animating:YES];
        self.currentPageNO = 1;
        //加载数据
        [self getMyOrders:YES];
    }else if (self.currentTableViewStatus == table_view_status_waiting && eventType == event_pull_up) {

        //更新加载状态视图到正在加载的效果
        [loading updateStatus:network_status_loading animating:YES];
        self.currentPageNO = self.currentPageNO + 1;
        self.currentTableViewStatus = table_view_status_loading;
        //加载数据
        [self getMyOrders:NO];
    }else if(self.currentTableViewStatus == table_view_status_loading && eventType == event_load_complete_fail){
        
        //更新加载状态视图到加载失败的效果
        [loading updateStatus:network_request_fail animating:NO];
        self.currentPageNO = self.currentPageNO - 1;
        
        self.currentTableViewStatus = table_view_status_load_fail;
    }else if(self.currentTableViewStatus == table_view_status_loading && eventType == event_load_complete_over){
        
        [loading updateStatus:[self getNoMoreNote] animating:NO];
        
        self.currentTableViewStatus = table_view_status_load_over;
    }else if(self.currentTableViewStatus == table_view_status_loading && eventType == event_load_complete_succes){
        
        [loading updateStatus:network_status_loading animating:YES];
        
        self.currentTableViewStatus = table_view_status_waiting;
    }else if(self.currentTableViewStatus == table_view_status_load_fail
             && (eventType == event_pull_up || eventType == event_click_load)
             && [[AppStatus sharedInstance] isConnetInternet]){
        
        self.currentTableViewStatus = table_view_status_loading;
        
        [loading updateStatus:network_status_loading animating:YES];
        //加载数据
        self.currentPageNO = self.currentPageNO + 1;
        [self getMyOrders:NO];
    }
}

-(NSString *) getNoMoreNote{
    if (self.orders.count == 0) {
        return @"没有需要评价的预约";
    }
    return network_status_no_more;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.orders.count) {
        [self transformEvent:event_click_load];
    }
    else{
        ServiceOrder *currentOrder = self.orders[indexPath.row];
        int orderUIStatus = -1;
        if (currentOrder.orderStatus == order_status_completed
            && currentOrder.evaluationStatus == evaluation_status_post) {
            orderUIStatus = order_ui_status_complete_evaluation;
        }else if(currentOrder.orderStatus == order_status_completed
                 && currentOrder.evaluationStatus == evaluation_status_unpost){
            orderUIStatus = order_ui_status_wait_evaluation;
        }else if(currentOrder.orderStatus == order_status_confirmed
                 || currentOrder.orderStatus == order_status_waiting_confirm){
            orderUIStatus = order_ui_status_success_second;
        }else if(currentOrder.orderStatus == order_status_canceled){
            orderUIStatus = order_ui_status_canceled;
        }
        OrderDetailInfoController *odc = [[OrderDetailInfoController alloc] initWithOrder:currentOrder orderUIStatus:orderUIStatus];
        [self.navigationController pushViewController:odc animated:YES];
        
        [MobClick event:log_event_name_goto_order_detail_info attributes:[NSDictionary dictionaryWithObjectsAndKeys:currentOrder.stylist.name, @"发型师名字",nil]];
    }
}

#pragma mark -------跳转到评价页面-----
-(void)jumpToPostEvaluationPage:(UIButton *)sender{
    ServiceOrder *order = (ServiceOrder *)[self.orders objectAtIndex:sender.tag];
    PostEvaluationController *pec = [[PostEvaluationController alloc] initWithOrder:order];
    [self.navigationController pushViewController:pec animated:YES];
    
    [MobClick event:log_event_name_goto_sender_evaluation_page attributes:[NSDictionary dictionaryWithObjectsAndKeys:order.stylist.name, @"发型师名字",nil]];
}

-(void)viewDidAppear:(BOOL)animated
{
     [[((AppDelegate*)[UIApplication sharedApplication].delegate) tabbar].tabbarController hidesTabBar:YES animated:NO];
}

-(NSString *)getPageName{
    return self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setOrderListTable:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

@end
