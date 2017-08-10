//
//  RentDelegateFlowViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/27.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "RentDelegateFlowViewController.h"

@interface RentDelegateFlowViewController ()

@end

@implementation RentDelegateFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
}

- (void) initHeaderView{
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"委托出租流程" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.view addSubview:self.headerView];
}



-(void) initBodyView{
    self.bodyView = [[UITableView alloc] init];
    self.bodyView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY);
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.bodyView];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2513/750 *screen_width;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rentDelegateFlow"]];
    imageView.frame = CGRectMake(0, 0, screen_width, 2513/750 *screen_width);
    [cell.contentView addSubview:imageView];
    [cell setBackgroundColor:[UIColor yellowColor]];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
