//
//  PassLockViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "PassLockViewController.h"
#import "PassLockCell.h"
#import "UpdatePassLockViewController.h"

static NSString *passLockCellId = @"passLockCellId";

@interface PassLockViewController ()

@end

@implementation PassLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBtnsView];
    [self initBodyView];
    
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"密码解锁" navigationController:self.navigationController];
    [self.headerView.rightLongBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [self.headerView.rightLongBtn setTitleColor:[ColorUtils colorWithHexString:white_text_color alpha:0.5] forState:UIControlStateNormal];
    [self.headerView.rightLongBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.headerView.rightLongBtn setHidden:NO];
    [self.view addSubview:self.headerView];
    [self.headerView.rightLongBtn addTarget:self action:@selector(updatePwd) forControlEvents:UIControlEventTouchUpInside];
}

-(void) initBtnsView{
    self.shoushiBtn = [[UIButton alloc] init];
    [self.shoushiBtn setBackgroundColor:[UIColor whiteColor]];
    self.shoushiBtn.frame = CGRectMake(0, 64, screen_width/2, 45);
    [self.shoushiBtn setTitle:@"手势解锁" forState:UIControlStateNormal];
    [self.shoushiBtn setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.shoushiBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.shoushiBtn];
    
    self.mimaBtn = [[UIButton alloc] init];
    [self.mimaBtn setBackgroundColor:[UIColor whiteColor]];
    self.mimaBtn.frame = CGRectMake(screen_width/2, 64, screen_width/2, 45);
    [self.mimaBtn setTitle:@"密码解锁" forState:UIControlStateNormal];
    [self.mimaBtn setTitleColor:[ColorUtils colorWithHexString:text_color_purple] forState:UIControlStateNormal];
    [self.mimaBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.mimaBtn];
}

-(void) initBodyView
{
    
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, self.shoushiBtn.bottomY, screen_width, screen_height-self.shoushiBtn.bottomY);
    [self.bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgLogin"]]];
    [self.view addSubview:self.bgView];
    
    self.bodyView = [[UITableView alloc] init];
    self.bodyView.frame = CGRectMake(0, self.shoushiBtn.bottomY, screen_width, screen_height-self.shoushiBtn.bottomY);
    [self.bodyView setBackgroundColor:[UIColor whiteColor]];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.bodyView registerClass:[PassLockCell class] forCellReuseIdentifier:passLockCellId];
    [self.view addSubview:self.bodyView];
    [self.bodyView setBackgroundColor:[UIColor clearColor]];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 550; // 随便写的
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassLockCell *cell = [tableView dequeueReusableCellWithIdentifier:passLockCellId forIndexPath:indexPath];
    [cell renderView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
    
}


-(void) updatePwd
{
    UpdatePassLockViewController *updatePassLockViewController = [[UpdatePassLockViewController alloc] init];
    [self.navigationController pushViewController:updatePassLockViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
