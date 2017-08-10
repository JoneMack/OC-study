//
//  CouponViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"

static NSString *couponCellId = @"couponCellId";

@interface CouponViewController ()

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"优惠卷" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.view addSubview:self.headerView];
}


-(void) initBodyView
{
    self.bodyView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY) style:UITableViewStylePlain];
    [self.view addSubview:self.bodyView];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UINib *nib = [UINib nibWithNibName:@"CouponCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:couponCellId];
    
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 79;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.bodyHeaderView == nil){
        self.bodyHeaderView = [[UITableViewHeaderFooterView alloc] init];
        [self.bodyHeaderView.contentView setBackgroundColor:[UIColor whiteColor]];
        
        self.inputCouponField = [[UITextField alloc] init];
        self.inputCouponField.frame =  CGRectMake(20, 20, screen_width - 20*3  - 72, 39);
        [self.inputCouponField setPlaceholder:@"请输入您的兑换码"];
        [self.inputCouponField setFont:[UIFont systemFontOfSize:12]];
        [self.inputCouponField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.bodyHeaderView.contentView addSubview:self.inputCouponField];
        
        self.changeCouponBtn = [[UIButton alloc] init];
        self.changeCouponBtn.frame = CGRectMake(self.inputCouponField.rightX+20, 20, 72, 39);
        [self.changeCouponBtn setTitle:@"兑 换" forState:UIControlStateNormal];
        [self.changeCouponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.changeCouponBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.changeCouponBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
        self.changeCouponBtn.layer.masksToBounds = YES;
        self.changeCouponBtn.layer.cornerRadius = 5;
        [self.bodyHeaderView.contentView addSubview:self.changeCouponBtn];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = CGRectMake(0, 78.5, screen_width, 0.5);
        [self.lineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
        [self.bodyHeaderView.contentView addSubview:self.lineView];
        
    }
    
    return self.bodyHeaderView;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCellId forIndexPath:indexPath];
    [cell setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
