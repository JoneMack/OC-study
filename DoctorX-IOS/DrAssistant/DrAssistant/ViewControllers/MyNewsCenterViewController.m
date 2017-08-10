//
//  MyNewsCenterViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/31.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyNewsCenterViewController.h"
#import "SRRefreshView.h"
#import "MyNewsDetailModel.h"
#import "NewsWebViewController.h"
@interface MyNewsCenterViewController ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
{
    int pageCount;
    long total;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *remainData;
@end

@implementation MyNewsCenterViewController

- (void)initRequestForNewsType
{
        [self showWithStatus:@"请等待.."];
        NSString *pageString = [NSString stringWithFormat:@"%d",pageCount];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:pageString forKey:@"page"];
        [dic safeSetObject:@"10" forKey:@"pagenum"];
        [dic safeSetObject:[GlobalConst shareInstance].loginInfo.iD forKey:@"userId"];
        [dic safeSetObject:@([GlobalConst shareInstance].loginInfo.user_type) forKey:@"type"];
        [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
        [[GRNetworkAgent sharedInstance] requestUrl:GetPushMessage param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
            [self dismissToast];
            total = [[reponeObject objectForKey:@"total"] integerValue];
            MyNewsDetailModel *detailModel = [[MyNewsDetailModel alloc]init];
            self.remainData = [ detailModel packageDataWithObject:reponeObject];
            for (MyNewsModel *model in self.remainData) {
                [self.dataArr safeAddObject:model];
            }
            [self.tableView reloadData];
            
        } failure:^(GRBaseRequest *request, NSError *error) {
            
        } withTag:0];
        
        pageCount = pageCount +1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageCount = 1;
    total = 0;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self initRequestForNewsType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    MyNewsModel *newsModel = [self.dataArr safeObjectAtIndex:indexPath.row];
    cell.textLabel.text = newsModel.title;
    cell.detailTextLabel.text = newsModel.create_time;
    cell.imageView.image = [UIImage imageNamed:@"xiaoxizhongxin.png"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyNewsModel *newsModel = [self.dataArr safeObjectAtIndex:indexPath.row];
    NewsWebViewController *newsWeb = [NewsWebViewController simpleInstance];
    newsWeb.title=@"消息详情";
    newsWeb.newsModel = newsModel;
    [self.navigationController pushViewController:newsWeb animated:YES];
    
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate

//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"pageCount－－－%d",pageCount);
    NSString *pageString = [NSString stringWithFormat:@"%d",pageCount];
    //        [self.dataArr removeAllObjects];
        //[self showWithStatus:@"请等待.."];
    if (total/10 < pageCount-1)
    {
        [self showString:@"没有更多数据啦"];
        [self.remainData removeAllObjects];
        [_slimeView endRefresh];
        return ;
    }
    
    [self.remainData removeAllObjects];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:pageString forKey:@"page"];
        [dic safeSetObject:@"10" forKey:@"pagenum"];
        [dic safeSetObject:[GlobalConst shareInstance].loginInfo.iD forKey:@"userId"];
        [dic safeSetObject:@([GlobalConst shareInstance].loginInfo.user_type) forKey:@"type"];
        [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
        [[GRNetworkAgent sharedInstance] requestUrl:GetPushMessage param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
            //[self dismissToast];
            MyNewsDetailModel *detailModel = [[MyNewsDetailModel alloc]init];
            
           self.remainData = [ detailModel packageDataWithObject:reponeObject];
            NSLog(@"----------s----%ld",self.remainData.count);
            for (MyNewsModel *model in self.remainData)
            {
                [self.dataArr safeAddObject:model];
            }
            pageCount = pageCount +1;
            [self.tableView reloadData];
        } failure:^(GRBaseRequest *request, NSError *error) {
            
        } withTag:0];
    
    [_slimeView endRefresh];
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (NSMutableArray *)remainData
{
    if (_remainData == nil) {
        _remainData = [[NSMutableArray alloc]init];
    }
    return _remainData;
}

@end
