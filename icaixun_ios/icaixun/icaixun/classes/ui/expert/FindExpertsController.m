//
//  FindExpertsController.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/25.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "FindExpertsController.h"
#import "FindExpertsHeaderView.h"
#import "ExpertMessageCell.h"

@interface FindExpertsController ()

@end

@implementation FindExpertsController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *testView = [[UIView alloc] init];
    testView.frame = CGRectMake(0, 0, screen_width, 0);
    testView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:testView];

    self.bodyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    self.bodyTableView.dataSource = self;
    self.bodyTableView.delegate = self;
    self.bodyTableView.backgroundColor = [ColorUtils colorWithHexString:gray_common_color];
    [self.bodyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview: self.bodyTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float y = 0;
    if (CURRENT_SYSTEM_VERSION >= 7) {
        y = status_bar_height;
    }
    return 145 + y;
}

#pragma mark 每一个section有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark 每一个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 179;
}

#pragma mark 返回 section 的 视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.sectionHeaderView == nil) {
        self.sectionHeaderView = [[FindExpertsHeaderView alloc] initWithNavigationController:self.navigationController];
    }
    return self.sectionHeaderView;
}

#pragma mark 返回 cell view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *findExpertsID = @"findExpertsID";
    ExpertMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:findExpertsID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpertMessageCell" owner:self options:nil] lastObject];
    }
//    [cell renderWithExpertMessage:nil];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
