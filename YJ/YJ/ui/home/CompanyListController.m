//
//  CompanyListController.m
//  YJ
//
//  Created by xubojoy on 2017/6/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "CompanyListController.h"
#import "CompanyListCell.h"
#import "CompanyDetailController.h"
#import "AddCompanyController.h"
#import "PYSearch.h"
#import "BrokenLineView.h"
@interface CompanyListController ()<PYSearchViewControllerDelegate>
@property(nonatomic, strong) NSArray *array;
@end
static NSString *companyListCellIdentifier = @"CompanyListCell";
@implementation CompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.array = @[
                   @{
                       @"id": @(1),
                       @"logo": @"golf.png",
                       @"name": @"每日高尔夫（北京）科技有限公司",
                       @"code": @"9111-0101-3303-7306-17",
                       
                       },
                   @{
                       @"id": @(2),
                       @"logo": @"huifenqi.jpg",
                       @"name": @"会找房（北京）网络技术有限公司",
                       @"code": @"9111-0108-3183-4529-5U",
                       },
                   @{
                       @"id": @(3),
                       @"logo": @"th.png",
                       @"name": @"北京听花科技有限公司",
                       @"code": @"9111-0105-MA00-5LKW-0Y",
                       },
                   @{
                       @"id": @(4),
                       @"logo": @"tairui.png",
                       @"name": @"泰瑞数创科技（北京）有限公司",
                       @"code": @"9111-0108-7662-8712-1Q",
                       }
                   ];
    [self initHeaderView];
//    [self initUI];
    BrokenLineView *lineView = [[BrokenLineView alloc] initWithFrame:CGRectMake(20, 50, 200, 200)];
    lineView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lineView];
    
}

- (void)initUI{
    [self initTableView];
    [self initBottomBtn];
}

- (void)initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"CHECK ME" navigationController:self.navigationController];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.backBut.hidden = YES;
    [self.view addSubview:self.headerView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(screen_width-60, general_space, 60, 44);
//    btn.backgroundColor = [UIColor cyanColor];
//    [btn setTitle:@"搜搜" forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    [btn setImage:[UIImage imageNamed:@"search-44"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchCompanyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:btn];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height+splite_line_height, screen_width, screen_height-self.headerView.frame.size.height-tabbar_height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"CompanyListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:companyListCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)initBottomBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(general_space, screen_height-tabbar_height-general_padding, screen_width-2*general_space, tabbar_height);
    btn.backgroundColor = [ColorUtils colorWithHexString:@"#1296db"];
    [btn setTitle:@"添加公司" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(addCompanyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:companyListCellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.array[indexPath.row];
    NSLog(@">>>>>>>>>>>>>%@",dict);
    cell.logoImgView.image = [UIImage imageNamed:dict[@"logo"]];
    cell.companyNameLabel.text = dict[@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - BtnClick

- (void)addCompanyBtnClick{
    AddCompanyController *addvc = [[AddCompanyController alloc] init];
    [self.navigationController pushViewController:addvc animated:YES];
}

- (void)searchCompanyBtnClick{
    NSArray *hostArray = @[@"每日高尔夫（北京）科技有限公司",@"会找房（北京）网络技术有限公司",@"北京听花科技有限公司",@"泰瑞数创科技（北京）有限公司",@"北京百度网讯科技有限公司",@"阿里巴巴（中国）网络技术有限公司",@"深圳市腾讯计算机系统有限公司"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hostArray searchBarPlaceholder:@"输入公司名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[CompanyDetailController alloc] init] animated:YES];
    }];
//    searchViewController.searchBarBackgroundColor = [ColorUtils colorWithHexString:@"#1296db"];
    // 3. Set style for popular search and search history
//    if (0 == indexPath.section) {
//        searchViewController.hotSearchStyle = (NSInteger)indexPath.row;
//        searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
//    } else {
//        searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
//        searchViewController.searchHistoryStyle = (NSInteger)indexPath.row;
//    }
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    nav.navigationBar.backgroundColor = [ColorUtils colorWithHexString:@"#1296db"];
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
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
