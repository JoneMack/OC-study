//
//  YeZhuViewController.m
//  xiangyu
//
//  Created by xubojoy on 16/9/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "YeZhuViewController.h"
#import "MyContractViewCell.h"
#import "ContractDetailViewController.h"
#import "UserStore.h"
static NSString *myContractViewCellId = @"myContractViewCellId";
@interface YeZhuViewController ()
@property int currentTableViewStatus;
@property int currentEventType;

@end

@implementation YeZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentPageNo = 0;
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self transformEvent:event_load_data_init_load];
    [self initBodyView];
}

- (void)loadYeZhuData{
    [[UserStore sharedStore] getUserSfContractList:^(NSArray<ContractInfoList *> *userSfContractList, NSError *err) {
        [self.bodyView.mj_header endRefreshing];
        [self.bodyView.mj_footer endRefreshing];
        if (err == nil) {
            self.currentTableViewStatus = load_data_status_waiting_load;
            if(self.userSfContractListArray == nil){
                self.userSfContractListArray = [NSMutableArray new];
            }
            if(userSfContractList != nil && userSfContractList.count >0){
                [self.userSfContractListArray addObjectsFromArray:userSfContractList];
                
            }else{
                [self.bodyView.mj_footer endRefreshingWithNoMoreData];
                self.currentTableViewStatus = load_data_status_load_over;
            }
        }else{
            
        }
        [self.bodyView reloadData];
    } pageNum:[NSString stringWithFormat:@"%d",self.currentPageNo] orderType:@"承租合同"];
}

-(void) initBodyView
{
    self.bodyView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - 64-45) style:UITableViewStylePlain];
    [self.view addSubview:self.bodyView];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"MyContractViewCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:myContractViewCellId];
    
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    //下拉刷新
    self.bodyView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    //上拉加载更多
    self.bodyView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    
}

//下拉刷新
-(void) headerRefreshing
{
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self.userSfContractListArray removeAllObjects];
    [self transformEvent:event_load_data_pull_down];
}
//上拉刷新
-(void) footerRefreshing
{
    [self transformEvent:event_load_data_pull_up];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userSfContractListArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 183;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyContractViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myContractViewCellId forIndexPath:indexPath];
    if (self.userSfContractListArray.count > 0) {
        self.contractInfoList = self.userSfContractListArray[indexPath.row];
        [cell renderMyContractViewCellWithContractInfoList:self.contractInfoList];
    }
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.userSfContractListArray.count > 0) {
        self.contractInfoList = self.userSfContractListArray[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(didYeZhuViewControllerIndexPathRow:contractInfoList:)]) {
            [self.delegate didYeZhuViewControllerIndexPathRow:indexPath.row contractInfoList:self.contractInfoList];
        }
    }
}

#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if ((self.currentTableViewStatus == load_data_status_waiting_load
         || self.currentTableViewStatus == load_data_status_load_over)
        && eventType == event_load_data_init_load) {
        // 初始化加载
        if(self.userSfContractListArray != nil && self.userSfContractListArray.count >0){
            [self.userSfContractListArray removeAllObjects];
        }
        self.currentPageNo = 1;
        self.currentTableViewStatus = load_data_status_loading;
        [self loadYeZhuData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        // 上拉加载
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = self.currentPageNo + 1;
        [self loadYeZhuData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down){
        // 下拉刷新
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        [self.userSfContractListArray removeAllObjects];
        [self.bodyView reloadData];
        [self loadYeZhuData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
