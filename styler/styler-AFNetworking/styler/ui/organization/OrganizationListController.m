//
//  OrganizationController.m
//  styler
//
//  Created by wangwanggy820 on 14-4-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationListController.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"
#import "OrganizationCell.h"
#import "StylistListController.h"
#import "StylistStore.h"
#import "UIView+Custom.h"
#import "OrganizationDetailInfoController.h"
#import "AllBusinessCirclesController.h"
#import "HdcQuery.h"
#import "HdcStore.h"
#import "HairDressingCard.h"

@interface OrganizationListController ()

@end

@implementation OrganizationListController
{
    LoadingStatusView *loadingView;
    UITableView *orderTypeList;
    BOOL noMoreOrganization;
    float lastWorkListContentOffset;
    int pageNo;//当前页码
    int pageSize;//每个页码的page个数
    BOOL isLoading;//是否处于下载状态
    int row;//用来记录上一次选中的第几行
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUrl:(NSString *)url title:(NSString *)title{
    if (self = [super init]) {
        self.url = url;
        self.title = title;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hdcs=[[NSMutableArray alloc] init];
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
//    [self initOrderTypeList];
    [self initHeader];
    [self initOrganizationTableView];
    pageSize = 10;
    row = 0;//用来记录上一次选中的第几行
}

-(void)initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.header) {
        orderTypeList.hidden = YES;
        return YES;
    }
    return NO;
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:self.title navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

//右上角的排序列表
-(void)updateOrganizationTableView:(UIButton *)btn{
    int y = self.header.frame.size.height;
    orderTypeList.frame = CGRectMake(self.view.frame.size.width - orderTypeList_frame_width, y, orderTypeList_frame_width, 0);
    if (orderTypeList.hidden == NO) {
        orderTypeList.hidden = YES;
    }else{
        orderTypeList.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = orderTypeList.frame;
            frame.size.height = order_type_list_cell_height*3 + splite_line_height;
            orderTypeList.frame = frame;
        }];
    }
}

#pragma mark------初始化机构列表---
-(void)initOrganizationTableView
{
    CGRect frame = self.organizationTableView.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.height = self.view.frame.size.height - self.header.frame.size.height;
    self.organizationTableView.frame = frame;
    [self.organizationTableView setContentInset:UIEdgeInsetsMake(organization_cell_space, 0, 0, 0)];
    
    self.organizationTableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.organizationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.organizationTableView.dataSource = self;
    self.organizationTableView.delegate = self;
    [self.organizationTableView registerClass:[OrganizationCell class] forCellReuseIdentifier:@"OrganizationCell"];
    
    //请求网络数据
    self.organizations = [[NSMutableArray alloc] init];
    noMoreOrganization = NO;
    pageNo = 0;
    [self requestOrganizations];
}

-(void)requestOrganizations{
    if (isLoading) {
        return;
    }
    
    pageNo++;
    isLoading = YES;
    AppStatus *as = [AppStatus sharedInstance];
    self.poi = [NSString stringWithFormat:@"%f,%f",as.lastLat, as.lastLng];
    
    NSString *connectCharacter = @"?";
    if ([self.url rangeOfString:@"?"].location < self.url.length)
    {
        connectCharacter = @"&";
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@poi=%@&orderType=%d&reserve=%d&pageSize=10&pageNo=%d", self.url, connectCharacter, self.poi,self.orderType, self.reserve, pageNo];
    [loadingView updateStatus:network_status_loading animating:YES];

    [OrganizationStore getOrganizationByUrl:^(Page *page, NSError *err) {
        if (!err)
        {
            if (page.totalCount <= pageNo*pageSize)
            {
                noMoreOrganization = YES;
                [loadingView updateStatus:network_status_no_more animating:NO];
            }
//            NSLog(@"---totalcount->>%d",page.totalCount);
            [self requestHdcs:page.items];
            [self.organizations addObjectsFromArray:page.items];
            [self.organizationTableView reloadData];
        }else{
            [loadingView updateStatus:network_unconnect_note animating:NO];
        }
        isLoading = NO;
    } url:requestUrl];
}

-(void)requestHdcs:(NSArray *)organizations{
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for (Organization *org in organizations) {

        [ids addObject:[[NSNumber alloc] initWithInt:org.id]];
    }
    HdcQuery *query = [[HdcQuery alloc] initWithOrganizationIds:ids];
    [HdcStore searchHdc:^(Page *page, NSError *error) {
        [self.hdcs addObjectsFromArray:page.items];
        [self.organizationTableView reloadData];
    } query:query];
}

#pragma mark------初始化排序列表----
-(void)initOrderTypeList{
    orderTypeList = [[UITableView alloc] init];
    orderTypeList.delegate = self;
    orderTypeList.dataSource = self;
    orderTypeList.scrollsToTop = NO;
    orderTypeList.scrollEnabled = NO;
    orderTypeList.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTypeList.alpha = 0.9;
    orderTypeList.backgroundColor = [ColorUtils colorWithHexString:black_text_color];
    [self.view addSubview:orderTypeList];
    
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    [orderTypeList selectRowAtIndexPath:first animated:NO scrollPosition:UITableViewScrollPositionNone];
    orderTypeList.hidden = YES;
    self.reserve = true;
}

#pragma mark ------dataSource--------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == orderTypeList) {
//        return 3;
//    }
    return self.organizations.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.organizations.count)
    {
        return loading_cell_height;
    }

    Organization *org = self.organizations[indexPath.row];
    return [OrganizationCell getCellHeight:[self getOrganizationHdcs:org]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == orderTypeList) {
        UITableViewCell *cell  = [[UITableViewCell alloc] init];
        cell.backgroundColor = [ColorUtils colorWithHexString:black_text_color];
        cell.alpha = 0.9;
        cell.textLabel.font = [UIFont systemFontOfSize:default_font_size];
        cell.textLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
        cell.textLabel.userInteractionEnabled = YES;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [ColorUtils colorWithHexString:black_text_color];
        if (indexPath.row == 0 || indexPath.row == 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, splite_line_height )];
            line.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            [cell addSubview:line];
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"距离近";
                break;
            case 1:
                cell.textLabel.text = @"折扣高";
                break;
            case 2:
                cell.textLabel.text = @"折扣低";
                break;
            default:
                break;
        }
        return cell;
    }else if (tableView == self.organizationTableView){
        if (indexPath.row == self.organizations.count) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            if (!loadingView) {
                loadingView = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, (loading_cell_height - loading_view_height)/2, screen_width, general_cell_height)];
                [loadingView updateStatus:network_status_loading animating:YES];
            }
            if (![[AppStatus sharedInstance] isConnetInternet]) {
                [loadingView updateStatus:network_unconnect_note animating:NO];
            }
            [cell addSubview:loadingView];
            cell.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
            
            return cell;
        }else{
            OrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrganizationCell"];
            Organization *org = self.organizations[indexPath.row];
            [cell renderOrganization:org hdcs:[self getOrganizationHdcs:org]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

-(NSArray *) getOrganizationHdcs:(Organization *)org{
    NSMutableArray *orgHdcs = [[NSMutableArray alloc] init];
    for (HairDressingCard *hdc in self.hdcs)
    {
        if([hdc isSuitableOrganization:org]){
            [orgHdcs addObject:hdc];
        }
        
    }
    return orgHdcs;
}


#pragma mark ---delegate----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    orderTypeList.hidden = YES;
    if (tableView == orderTypeList) {
        [orderTypeList reloadData];
        [[tableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[ColorUtils colorWithHexString:white_text_color]];
        switch (indexPath.row) {
            case 0:
                self.orderType = organization_order_by_distance;
                self.reserve = organization_order_by_reserve;
                break;
            case 1:
                self.orderType = organization_order_by_price;
                self.reserve =  organization_order_by_reserve;
                break;
            case 2:
                self.orderType = organization_order_by_price;
                self.reserve =  organization_order_by_unreserve;
                break;
            default:
                break;
        }

        //如果与上一次的行数不相同才请求数据
        if (indexPath.row != row) {
            pageNo = 0;
            [self.organizations removeAllObjects];
            [self requestOrganizations];
            [self.organizationTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        row = indexPath.row;
    }else if (tableView == self.organizationTableView){
        Organization *org = self.organizations[indexPath.row];
        [MobClick event:log_event_name_select_org attributes:[NSDictionary dictionaryWithObjectsAndKeys:org.name, @"沙龙", nil]];
        
        OrganizationDetailInfoController *odic = [[OrganizationDetailInfoController alloc] initWithOrganizationId:org.id];

        odic.organization = self.organizations[indexPath.row];
        odic.hdcs = [self getOrganizationHdcs:org];
        [self.navigationController pushViewController:odic animated:YES];
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == orderTypeList && cell.selected)
    {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.organizationTableView && indexPath.row == self.organizations.count) {
        return NO;
    }
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    orderTypeList.hidden = YES;
    if(lastWorkListContentOffset < self.organizationTableView.contentOffset.y){//上推
        if (scrollView == self.organizationTableView){
            if(self.organizationTableView.contentOffset.y >= (self.organizationTableView.contentSize.height - 2*organization_cell_height - general_cell_height*2) && !noMoreOrganization)
            {
                [self requestOrganizations];
            }
        }
    }
    lastWorkListContentOffset = scrollView.contentOffset.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_organization_list;
}

@end
