//
//  MyExpertsController.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "MyExpertsController.h"
#import "ExpertCardCell.h"
#import "ExpertStore.h"

@interface MyExpertsController ()

@property (nonatomic , strong) NSArray *myAttentionExperts;
@property (nonatomic , strong) NSArray *moreExperts;

@end

@implementation MyExpertsController

#pragma mark 视图加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView = [[HeaderView alloc] initWithTitle:@"微博专家" navigationController:self.navigationController];
    [self.headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_page_header_750@2x.jpg"]]];
    [self.view addSubview:self.headerView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.frame.size.height);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

-(void) loadData
{
    
    [ExpertStore getMyAttentionExperts:^(NSArray *myAttentionExperts, NSError *err) {
        
        if (err == nil) {
            self.myAttentionExperts = myAttentionExperts;
        }
        [self.tableView reloadData];
    }];
    
    ExpertQuery * query = [[ExpertQuery alloc] initWithPageSize:100];
    
    [ExpertStore getExperts:^(NSArray *experts, NSError *err) {
        if (err == nil) {
            self.moreExperts = experts;
        }
        [self.tableView reloadData];
    } query:query];
    
}

#pragma mark   返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


#pragma mark   返回每个 section 中 cell 的个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.myAttentionExperts.count;
    }else if (section == 1){
        return self.moreExperts.count;
    }
    return 0;
}



#pragma mark  返回 section 的高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark  返回 cell 的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 172;
    return 210;
}

#pragma mark   渲染 section header view
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] init];
    [view.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_black_color]];
    if (section == 0) {
        [view.textLabel setText:@"我关注的专家"];
    }else{
        [view.textLabel setText:@"更多最热专家"];
    }
    [view.textLabel setTextColor:[UIColor whiteColor]];
    [view.textLabel setFont:[UIFont systemFontOfSize:9]];
    return view;
}

#pragma mark 渲染 cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *expertCardCellIdentifier = @"expertCardCellIdentifier";
    ExpertCardCell *cell = [tableView dequeueReusableCellWithIdentifier:expertCardCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpertCardCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Expert *expert = nil;
    if(indexPath.section == 0){
        expert = self.myAttentionExperts[indexPath.row];
    }else if(indexPath.section == 1){
        expert = self.moreExperts[indexPath.row];
        for (Expert *temp in self.myAttentionExperts) {
            if (temp.id == expert.id) {
                expert.relationStatus = temp.relationStatus;
            }
        }
    }
    [cell renderWithExpert:expert navigationController:self.navigationController];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
