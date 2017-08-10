//
//  RentDelegateViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "RentDelegateViewController.h"
#import "RentDelegateFormCell.h"
#import "CircleStore.h"
#import "RentDelegateFlowViewController.h"


@interface RentDelegateViewController ()

@end

static NSString *rentDelegateFormCellId = @"rentDelegateFormCellId";

@implementation RentDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
    [self loadCircleData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectArea) name:notification_name_rent_delegate_select_quyu object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCircle) name:notification_name_rent_delegate_select_shangquan object:nil];
    
}


- (void) initHeaderView{
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"委托出租" navigationController:self.navigationController];
    [self.headerView renderRightBtn:@"tanhao"];
    [self.headerView.rightBtn addTarget:self action:@selector(showRentDelegateFlow) forControlEvents:UIControlEventTouchUpInside];
    [self.headerBlock addSubview:self.headerView];
}


-(void) initBodyView
{
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"RentDelegateFormCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:rentDelegateFormCellId];
    
}


-(void) initPickerControlView:(Circle *)circle{

    self.selectView = [[SeleceAreaAndCircleView alloc] init];
    self.selectView.circle = circle;
    self.selectView.delegate = self;
    [self.view addSubview:self.selectView];
    
}


-(void) loadCircleData
{
    [[CircleStore sharedStore] getCircles:^(Circle *circle, NSError *err) {
        [self initPickerControlView:circle];
    }];
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [UITableViewHeaderFooterView new];
    UIImageView *imgAd = [UIImageView new];
    [imgAd setImage:[UIImage imageNamed:@"ad1"]];
    imgAd.frame = CGRectMake(0, 0, screen_width, 320);
    [headerView addSubview:imgAd];
    return headerView;
}


-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 320;
}


-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 492;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [tableView dequeueReusableCellWithIdentifier:rentDelegateFormCellId];
    self.cell.navigationController = self.navigationController;
    return self.cell;
}

-(void) selectArea
{
    [UIView animateWithDuration:0.2 animations:^{
//        [self.selectView showLastSelected];
        self.selectView.frame = CGRectMake(0, 64, screen_width, screen_height-64);
    }];   
}

-(void) selectCircle
{
    [UIView animateWithDuration:0.2 animations:^{
//        [self.selectView showLastSelected];
        self.selectView.frame = CGRectMake(0, 64, screen_width, screen_height-64);
    }];
}

-(void) selectedAreaAndCircle
{
    self.cell.selectedChengQu = self.selectView.selectedChengQu;
    self.cell.selectedShangQuan = self.selectView.selectedShangQuan;
    [self.cell.quyu setTitle:[NSString stringWithFormat:@"%@  >" , self.selectView.selectedChengQu] forState:UIControlStateNormal];
    [self.cell.shangquan setTitle:[NSString stringWithFormat:@"%@  >" , self.selectView.selectedShangQuan] forState:UIControlStateNormal];
}

/**
 * 进入委托出租流程页面
 */
-(void) showRentDelegateFlow
{
    RentDelegateFlowViewController *flowViewController = [[RentDelegateFlowViewController alloc] init];
    [self.navigationController pushViewController:flowViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
