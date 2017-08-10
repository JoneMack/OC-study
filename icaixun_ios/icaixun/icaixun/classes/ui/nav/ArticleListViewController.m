//
//  ArticleListViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleStore.h"
#import "ArticleCell.h"
#import "ArticleDetailViewController.h"
#import "ArticleListHeaderView.h"
#import "MJRefresh.h"

@interface ArticleListViewController ()

@property int currentPageNo;
@property int pageSize;
@property int currentTableViewStatus;
@property int currentEventType;

@end

@implementation ArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageNo = 1;
    self.pageSize = 10;
    self.currentTableViewStatus = load_data_status_waiting_load;
    self.currentEventType = event_load_data_load_over;
    [self initHeaderView];
    [self initBodyView];
}

#pragma mark 返回 header view
-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"财讯新闻" navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    self.headerView.backBut.hidden = YES;
    [self.view addSubview:self.headerView];
}

#pragma mark 初始化body view
-(void) initBodyView
{
    CGRect frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY - tabbar_height);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self setupMJRefresh];
    [self transformEvent:event_load_data_init_load];
}

-(void) setupMJRefresh
{
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
//    [self.tableView headerBeginRefreshing];
    
    //上拉加载更多
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    // 设置文字
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"刷新中...";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中...";
}

//下拉刷新
-(void) headerRefreshing
{
    [self transformEvent:event_load_data_pull_down];
}
//上拉刷新
-(void) footerRefreshing
{
    [self transformEvent:event_load_data_pull_up];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark 返回每个section有多少个row
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bannerArticles.count>0) {
        return self.articles.count +1;
    }
    return self.articles.count;
}

#pragma mark 返回每个row的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.bannerArticles.count > 0){
        if (indexPath.row == 0) {
            return screen_width/2 + 25.5;
        }
    }
    return 97;
}

#pragma mark 返回cell 视图
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannerArticles.count > 0) {
        if (indexPath.row == 0) {
                self.articleListHeaderView = [[ArticleListHeaderView alloc] initWithArticles:self.bannerArticles
                                                                        navigationController:self.navigationController];
                [self.articleListHeaderView setSelectionStyle:UITableViewCellSelectionStyleNone];
            return self.articleListHeaderView;
        }
        
        static NSString *articleCellId = @"articleCellId";
        [tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil]  forCellReuseIdentifier:articleCellId];
        ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellId];
        Article *article = self.articles[indexPath.row-1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell renderArticle:article];
        return cell;
    }
    
    static NSString *articleCellId = @"articleCellId";
    [tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil]  forCellReuseIdentifier:articleCellId];
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellId];
    Article *article = self.articles[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell renderArticle:article];
    return cell;
}


#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if (self.currentTableViewStatus == load_data_status_waiting_load
        && eventType == event_load_data_init_load) {
        // 初始化加载
        self.currentTableViewStatus = load_data_status_loading;
        [self loadArticleListData];
        [self loadBannerData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = self.currentPageNo + 1;
        [self loadArticleListData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down){
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        self.articles = nil;
        [self.bannerArticles removeAllObjects] ;
        [self loadArticleListData];
        [self loadBannerData];

    }
}

#pragma mark 加载 banner数据
-(void) loadBannerData
{
    [[ArticleStore sharedInstance] getBannerArticles:^(Page *page, NSError *err) {
        if (self.bannerArticles == nil) {
            self.bannerArticles = [NSMutableArray new];
        }
        self.articleListHeaderView = nil;
        if(page.items.count > 0){
            [self.bannerArticles addObjectsFromArray:page.items];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark 加载文章数据
-(void) loadArticleListData
{
    
    [[ArticleStore sharedInstance] getArticles:^(Page *page, NSError *err) {
        if (page.items.count > 0) {
            if (self.articles == nil) {
                self.articles = [NSMutableArray new];
            }
            [self.articles addObjectsFromArray:page.items];
            [self.tableView reloadData];
        }
        self.currentTableViewStatus = load_data_status_waiting_load;
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
    } pageNo:self.currentPageNo pageSize:self.pageSize];
}

#pragma mark 选中了cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannerArticles.count > 0) {
        if (indexPath.row == 0) {
            return;
        }
        Article *article = self.articles[indexPath.row-1];
        ArticleDetailViewController *articleDetailController = [[ArticleDetailViewController alloc] init];
        articleDetailController.article = article;
        [self.navigationController pushViewController:articleDetailController animated:YES];
        return;
    }
    Article *article = self.articles[indexPath.row];
    ArticleDetailViewController *articleDetailController = [[ArticleDetailViewController alloc] init];
    articleDetailController.article = article;
    [self.navigationController pushViewController:articleDetailController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
