//
//  ZuKeViewController.m
//  xiangyu
//
//  Created by xubojoy on 16/9/23.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "ZuKeViewController.h"
#import "MyContractViewCell.h"
#import "ContractDetailViewController.h"
#import "UserStore.h"


static NSString *myContractViewCellId = @"myContractViewCellId";
@interface ZuKeViewController ()

@property int pageSize;
@property int currentTableViewStatus;
@property int currentEventType;

@end

@implementation ZuKeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBodyView];
    self.currentPageNo = 0;
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self transformEvent:event_load_data_init_load];
}

- (void)loadZuKeData{
    [[UserStore sharedStore] getUserCfContractList:^(NSArray<ContractInfoList *> *userCfContractList, NSError *err) {
        [self.bodyView.mj_header endRefreshing];
        [self.bodyView.mj_footer endRefreshing];
        if (err == nil) {
            self.currentTableViewStatus = load_data_status_waiting_load;
            if(self.contractInfoListArray == nil){
                self.contractInfoListArray = [NSMutableArray new];
            }
            if(userCfContractList != nil && userCfContractList.count >0){
                        [self.contractInfoListArray addObjectsFromArray:userCfContractList];
                
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
    [self.contractInfoListArray removeAllObjects];
    [self transformEvent:event_load_data_pull_down];
}
//上拉刷新
-(void) footerRefreshing
{
    [self transformEvent:event_load_data_pull_up];
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contractInfoListArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 183;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyContractViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myContractViewCellId forIndexPath:indexPath];
    if (self.contractInfoListArray.count > 0) {
        self.contractInfoList = self.contractInfoListArray[indexPath.row];
        [cell renderMyContractViewCellWithContractInfoList:self.contractInfoList];
    }
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    ContractDetailViewController *contractDetailViewController = [[ContractDetailViewController alloc] init];
////    contractDetailViewController.userType = self.userType;
//    [self.navigationController pushViewController:contractDetailViewController animated:YES];
    if (self.contractInfoListArray.count > 0) {
        self.contractInfoList = self.contractInfoListArray[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(didZuKeViewControllerIndexPathRow:contractInfoList:)]) {
            [self.delegate didZuKeViewControllerIndexPathRow:indexPath.row contractInfoList:self.contractInfoList];
        }
    }
}

#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if ((self.currentTableViewStatus == load_data_status_waiting_load
         || self.currentTableViewStatus == load_data_status_load_over)
        && eventType == event_load_data_init_load) {
        // 初始化加载
        if(self.contractInfoListArray != nil && self.contractInfoListArray.count >0){
            [self.contractInfoListArray removeAllObjects];
        }
        self.currentPageNo = 1;
        self.currentTableViewStatus = load_data_status_loading;
        [self loadZuKeData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        // 上拉加载
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = self.currentPageNo + 1;
        [self loadZuKeData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down){
        // 下拉刷新
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        [self.contractInfoListArray removeAllObjects];
        [self.bodyView reloadData];
        [self loadZuKeData];
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
