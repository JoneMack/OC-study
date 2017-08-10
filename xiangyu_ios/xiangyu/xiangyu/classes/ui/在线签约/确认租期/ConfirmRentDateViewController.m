//
//  ConfirmRentDateViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "ConfirmRentDateViewController.h"
#import "ConfirmRentDateCell.h"
#import "ContractTermsViewController.h"
#import "HouseStore.h"
#import "SelectPayWayViewController.h"

static NSString *confirmRentDateCellId = @"confirmRentDateCellId";

@interface ConfirmRentDateViewController ()

@end

@implementation ConfirmRentDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self initBottomView];
    [self setRightSwipeGestureAndAdaptive];
    [self loadData];
    
}

-(void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"租期确认" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView{
    CGRect frame = CGRectMake(0, 64, screen_width, screen_height - 64);
    self.bodyView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    
    UINib *nib = [UINib nibWithNibName:@"ConfirmRentDateCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:confirmRentDateCellId];
    
    [self.view addSubview:self.bodyView];
    
}

-(void) initBottomView
{
    self.nextBtn = [UIButton new];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextBtn.frame = CGRectMake(10, screen_height-50, screen_width-20, 40);
    [self.nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    [self.nextBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.view addSubview:self.nextBtn];
    
    [self.nextBtn addTarget:self action:@selector(nextEvent) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) loadData{
    
    [[HouseStore sharedStore] getRentPeriod:^(NSDictionary *rentPeriod, NSError *err) {
        if(err == nil){
            self.rentPeriod = rentPeriod;
            [self.bodyView reloadData];
            NSLog(@"rentPeriod :%@" , rentPeriod);
        }else{
            ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
            self.errorMsg = exception.message;
            [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
        
    } houseId:self.houseInfo.houseId roomId:self.houseInfo.roomId rentType:self.houseInfo.rentType];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(10, 0, screen_width-20, 26);
    if(section == 0){
        [label setText:@"起始时间"];
    }else{
        [label setText:@"到期时间"];
    }
    [label setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [label setFont:[UIFont systemFontOfSize:11]];
    [headerView.contentView addSubview:label];
    [headerView.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    return headerView;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ConfirmRentDateCell *cell = [tableView dequeueReusableCellWithIdentifier:confirmRentDateCellId forIndexPath:indexPath];
    if(indexPath.section == 0){
        if(self.rentPeriod != nil){
            NSString *startDate = [self.rentPeriod valueForKey:@"startDate"];
            [cell.dateBtn setTitle:[NSString stringWithFormat:@"%@年%@月%@日" , [startDate substringWithRange:NSMakeRange(0, 4)] ,
                                    [startDate substringWithRange:NSMakeRange(4, 2)] ,[startDate substringWithRange:NSMakeRange(6, 2)]] forState:UIControlStateNormal];
            [cell.dateBtn setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
        }
        
    }else{
        if(self.rentPeriod != nil){
            NSString *endDate = [self.rentPeriod valueForKey:@"endDate"];
            [cell.dateBtn setTitle:[NSString stringWithFormat:@"%@年%@月%@日" , [endDate substringWithRange:NSMakeRange(0, 4)] ,
                                [endDate substringWithRange:NSMakeRange(4, 2)] ,[endDate substringWithRange:NSMakeRange(6, 2)]] forState:UIControlStateNormal];
            [cell.dateBtn setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void) nextEvent
{
    if([NSStringUtils isNotBlank:self.errorMsg]){
        
        [self.view makeToast:self.errorMsg duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    SelectPayWayViewController *selectPayWayViewController = [[SelectPayWayViewController alloc] init];
    selectPayWayViewController.house = self.house;
    selectPayWayViewController.houseInfo = self.houseInfo;
    selectPayWayViewController.rentPeriod = self.rentPeriod;
    selectPayWayViewController.customerInfo = self.customerInfo;
    selectPayWayViewController.sfContractId = [self.rentPeriod valueForKey:@"sfContractId"];
    [self.navigationController pushViewController:selectPayWayViewController animated:YES];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
