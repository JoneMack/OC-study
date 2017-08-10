//
//  SubwayFindHousesViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SubwayFindHousesViewController.h"
#import "MainHouseSourceCell.h"
#import "CustomSegmentView.h"
#import "HouseSourceDetailViewController.h"
#import "HouseStore.h"

static NSString *subwayFindHouseSourceTableViewCellId = @"subwayFindHouseSourceTableViewCellId";

@interface SubwayFindHousesViewController ()

@property int currentPageNo;
@property int pageSize;
@property int currentTableViewStatus;
@property int currentEventType;


@end

@implementation SubwayFindHousesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"地铁找房" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.view addSubview:self.headerView];
    
    CGRect frame = CGRectMake(0, self.headerView.frame.size.height, screen_width, screen_height - self.headerView.frame.size.height);
    
    self.bodyView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"MainHouseSourceCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:subwayFindHouseSourceTableViewCellId];
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.bodyView];
    
    self.currentType = @[@"地铁线路"];
    [self setRightSwipeGestureAndAdaptive];
    [self setupMJRefresh];
    self.currentPageNo = 1;
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self transformEvent:event_load_data_init_load];
}


-(void) setupMJRefresh
{
    //下拉刷新
    self.bodyView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    //上拉加载更多
    self.bodyView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

//下拉刷新
-(void) headerRefreshing
{
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self.houses removeAllObjects];
    [self transformEvent:event_load_data_pull_down];
}
//上拉刷新
-(void) footerRefreshing
{
    [self transformEvent:event_load_data_pull_up];
}


-(void) changeConditionReloadData{
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self.houses removeAllObjects];
    [self transformEvent:event_load_data_init_load];
}

-(void) loadData{
    
    AppStatus *as = [AppStatus sharedInstance];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@(self.currentPageNo) forKey:@"pageNum"];
    
    //    [params setObject:@"" forKey:@"businessCircleId"];
    //    [params setObject:@"" forKey:@"inDistrict"];
    //    [params setObject:@"" forKey:@"minPrice"];
    //    [params setObject:@"" forKey:@"maxPrice"];
    
    
    if([NSStringUtils isNotBlank:self.rentType]){
        [params setObject:self.rentType forKey:@"rentType"];
    }
    if ([NSStringUtils isNotBlank:self.houseType]) {
        [params setObject:self.houseType forKey:@"houseType"];  //户型居室（不限、1、2、3、4+）
    }
    if ([NSStringUtils isNotBlank:self.orderByType]) {
        [params setObject:self.orderByType forKey:@"orderByType"];  //户型居室（不限、1、2、3、4+）
    }
    if ([NSStringUtils isNotBlank:self.liveFlg]) {
        [params setObject:self.liveFlg forKey:@"liveFlg"];  //户型居室（不限、1、2、3、4+）
    }
    
    if(self.searchTab != nil && self.searchTab.count >0){
        [params setObject:[self.searchTab componentsJoinedByString:@","]  forKey:@"searchTab"];
    }
    
    if([NSStringUtils isNotBlank:self.subwayLineId]){
        [params setValue:self.subwayLineId forKey:@"subwayLines"];
    }
    if([NSStringUtils isNotBlank:self.stationId]){
        [params setValue:self.stationId forKey:@"subwayStations"];
    }
    
    [[HouseStore sharedStore] getHouses:^(NSArray<House *> *houses, NSError *err) {
        [self.bodyView.mj_header endRefreshing];
        [self.bodyView.mj_footer endRefreshing];
        self.currentTableViewStatus = load_data_status_waiting_load;
        if(self.houses == nil){
            self.houses = [NSMutableArray new];
        }
        if(houses != nil && houses.count >0){
            [self.houses addObjectsFromArray:houses];
            
        }else{
            [self.bodyView.mj_footer endRefreshingWithNoMoreData];
            self.currentTableViewStatus = load_data_status_load_over;
        }
        [self.bodyView reloadData];
    } params:params];
    
}



#pragma mark   返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark   返回每个 section 中 cell 的个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houses.count;
}


-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView  *headerView = [UITableViewHeaderFooterView new];
    
    if(self.customSegmentView == nil){
        NSArray *titles = [[NSArray alloc] initWithObjects:@"地铁线路" , @"价格" , @"更多", nil];
        self.customSegmentView = [[CustomSegmentView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 45)];
        [self.customSegmentView setBackgroundColor:[UIColor whiteColor]];
        [self.customSegmentView render:titles currentIndex:[self getSelectIndex]];
        [self.customSegmentView addBottomSeparateLine];
        self.customSegmentView.navigationController = self.navigationController;
    }
    self.customSegmentView.rentType = self.rentType;
    self.customSegmentView.houseType = self.houseType;
    self.customSegmentView.orderByType = self.orderByType;
    self.customSegmentView.liveFlg = self.liveFlg;
    self.customSegmentView.searchTab = self.searchTab;
    
    [headerView addSubview:self.customSegmentView];
    return headerView;
}


-(int)getSelectIndex{
    if ([self.currentType isEqualToArray:[[NSArray alloc] initWithObjects:@"地铁线路", nil]]) {
        return 0;
        
    }else if ([self.currentType isEqualToArray:[[NSArray alloc] initWithObjects:@"价格", nil]]) {
        return 1;
    }else if ([self.currentType isEqualToArray:[[NSArray alloc] initWithObjects:@"更多", nil]]){
        return 2;
    }
    return 0;
}


#pragma mark  返回 cell 的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}


#pragma mark 渲染 cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    House *house = self.houses[indexPath.row];
    MainHouseSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:subwayFindHouseSourceTableViewCellId forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell renderData:house];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    House *house = self.houses[indexPath.row];
    HouseSourceDetailViewController *detailController = [[HouseSourceDetailViewController alloc] init];
    detailController.houseId= house.houseId;
    detailController.roomId = house.roomsID;
    detailController.rentType = house.rentType;
    detailController.house = house;
    [self.navigationController pushViewController:detailController animated:YES];
    
}



#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if ((self.currentTableViewStatus == load_data_status_waiting_load
         || self.currentTableViewStatus == load_data_status_load_over)
        && eventType == event_load_data_init_load) {
        // 初始化加载
        if(self.houses != nil && self.houses.count >0){
            [self.houses removeAllObjects];
        }
        self.currentPageNo = 1;
        self.currentTableViewStatus = load_data_status_loading;
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        // 上拉加载
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = self.currentPageNo + 1;
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down){
        // 下拉刷新
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        [self.houses removeAllObjects];
        [self.bodyView reloadData];
        [self loadData];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
