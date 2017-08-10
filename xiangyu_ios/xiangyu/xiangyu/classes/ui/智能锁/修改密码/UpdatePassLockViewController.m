//
//  UpdatePassLockViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/28.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "UpdatePassLockViewController.h"
#import "UpdatePassLockCell.h"

@interface UpdatePassLockViewController ()

@end

@implementation UpdatePassLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"修改密码" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView
{
    
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 64, screen_width, screen_height-64);
    [self.bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgLogin"]]];
    [self.view addSubview:self.bgView];
    

    self.bodyView = [[UITableView alloc] init];
    self.bodyView.frame = CGRectMake(0, 64, screen_width, screen_height-64);
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.bodyView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.bodyView];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 550;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdatePassLockCell *cell = [[UpdatePassLockCell alloc] init];
    [cell renderView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.navigationController = self.navigationController;
    return cell;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
