//
//  SelectContractViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectContractViewController.h"
#import "SelectContractCell.h"
#import "FillUserInfoViewController.h"

static NSString *selectContractCellId = @"selectContractCellId";

@interface SelectContractViewController ()

@end

@implementation SelectContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
}

-(void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"在线签约" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView{
    self.bodyView = [[UITableView alloc] init];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    self.bodyView.frame = CGRectMake(0, 64, screen_width, screen_height - 64);
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    
    UINib *nib = [UINib nibWithNibName:@"SelectContractCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:selectContractCellId];
    [self.view addSubview:self.bodyView];
    
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 190;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectContractCell *cell = [tableView dequeueReusableCellWithIdentifier:selectContractCellId forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.row == 0){
        [cell.iconImg setImage:[UIImage imageNamed:@"zhimaxinyong"]];
    }else{
        [cell.iconImg setImage:[UIImage imageNamed:@"zhengjianqianyue"]];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        
    }else{
        FillUserInfoViewController *fillUserInfoViewController = [[FillUserInfoViewController alloc] init];
        fillUserInfoViewController.houseInfo = self.houseInfo;
        fillUserInfoViewController.house = self.house;
        [self.navigationController pushViewController:fillUserInfoViewController animated:YES];
    }
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
