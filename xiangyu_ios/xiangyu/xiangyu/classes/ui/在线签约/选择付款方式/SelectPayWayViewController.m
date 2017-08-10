//
//  SelectPayWayViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectPayWayViewController.h"
#import "SelectPayWayCell.h"
#import "PayOrderViewController.h"
#import "HouseStore.h"
#import "ContractTermsViewController.h"

static NSString *selectPayWayHouseSourceCellId = @"selectPayWayHouseSourceCellId";
static NSString *selectPayWayCellId = @"selectPayWayCellId";

@interface SelectPayWayViewController ()

@end

@implementation SelectPayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self initBottomView];
    [self setRightSwipeGestureAndAdaptive];
    [self loadData];
}

-(void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"在线签约" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView{
    CGRect frame = CGRectMake(0, 64, screen_width, screen_height - 64 - 60);
    self.bodyView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    
    UINib *nib = [UINib nibWithNibName:@"MainHouseSourceCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:selectPayWayHouseSourceCellId];
    
    nib = [UINib nibWithNibName:@"SelectPayWayCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:selectPayWayCellId];
    
    [self.view addSubview:self.bodyView];
    
}

-(void) initBottomView{
    self.bottomBlock = [[UIView alloc] init];
    self.bottomBlock.frame = CGRectMake(0, self.bodyView.bottomY, screen_width, 60);
    [self.bottomBlock setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    [self.view addSubview:self.bottomBlock];
    
    self.nextBtn = [[UIButton alloc] init];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"去支付" forState:UIControlStateNormal];
    self.nextBtn.frame = CGRectMake(10, 10, screen_width-20, 40);
    [self.nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    [self.nextBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.bottomBlock addSubview:self.nextBtn];
    
    [self.nextBtn addTarget:self action:@selector(nextEvent) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) loadData
{   
    [[HouseStore sharedStore] getPaymentPattern:^(NSArray *payTypes, NSError *err) {
        if(err == nil){
            NSLog(@"-------------------------->payTypes:%@" , payTypes);
            self.payTypes = payTypes;
            self.currentPayTypeRow = 0;
            self.currentPayType= payTypes[0];
            [self.bodyView reloadData];
        }else{
            ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
            [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
        
    } houseId:self.houseInfo.houseId roomId:self.houseInfo.roomId rentType:self.houseInfo.rentType sfContractId:self.sfContractId];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    return self.payTypes.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1 || section == 2){
        return 26;
    }
    return 0.00001f;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 130;
    }
    return 56;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *bodyHeaderView = [[UITableViewHeaderFooterView alloc] init];
    UILabel *bodyHeaderTitle = [UILabel new];
    bodyHeaderTitle.frame = CGRectMake(10, 0, screen_width-20, 27);
    [bodyHeaderTitle setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    [bodyHeaderTitle setFont:[UIFont systemFontOfSize:11]];
    [bodyHeaderView.contentView addSubview:bodyHeaderTitle];
    if(section == 1){
        [bodyHeaderTitle setText:@"付款方式"];
    }
    return bodyHeaderView;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(self.houseSourceCell == nil){
            self.houseSourceCell = [tableView dequeueReusableCellWithIdentifier:selectPayWayHouseSourceCellId forIndexPath:indexPath];
        }
        [self.houseSourceCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.houseSourceCell renderData:self.house];
        return self.houseSourceCell;
    }else if(indexPath.section == 1){
        SelectPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:selectPayWayCellId forIndexPath:indexPath];
        
        if(indexPath.row == 0 || indexPath.row == 1){
            [cell.line2View setHidden:YES];
        }
        
        if (self.payTypes != nil && self.payTypes.count >0) {
            NSString *payType = self.payTypes[indexPath.row];
            [cell.payType setTitle:payType forState:UIControlStateNormal];
        }
        
        if(indexPath.row == self.currentPayTypeRow){
            [cell.payType setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
        }else{
            [cell.payType setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        self.currentPayType = self.payTypes[indexPath.row];
        self.currentPayTypeRow = indexPath.row;
        [self.bodyView reloadData];
    }
}

-(void) nextEvent{
    
    NSString *startDate = [self.rentPeriod valueForKey:@"startDate"];
    startDate = [NSString stringWithFormat:@"%@-%@-%@" , [startDate substringWithRange:NSMakeRange(0, 4)] ,
                           [startDate substringWithRange:NSMakeRange(4, 2)] ,[startDate substringWithRange:NSMakeRange(6, 2)]];
    NSString *endDate = [self.rentPeriod valueForKey:@"endDate"];
    endDate = [NSString stringWithFormat:@"%@-%@-%@" , [endDate substringWithRange:NSMakeRange(0, 4)] ,
                 [endDate substringWithRange:NSMakeRange(4, 2)] ,[endDate substringWithRange:NSMakeRange(6, 2)]];
    
    if([NSStringUtils isBlank:self.houseInfo.roomId]){
        self.houseInfo.roomId = @"";
    }
    
    if([NSStringUtils isBlank:self.currentPayType]){
        [self.view makeToast:@"您还没有选择付款方式" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return ;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.rentPeriod valueForKey:@"sfContractId"] forKey:@"sfContractId"];
    [params setObject:self.houseInfo.houseId forKey:@"houseId"];
    [params setObject:self.houseInfo.roomId forKey:@"roomId"];
    [params setObject:self.houseInfo.rentType forKey:@"rentType"];
    [params setObject:self.customerInfo.userName forKey:@"tenantName"];
    [params setObject:self.customerInfo.mobile forKey:@"tenantPhone"];
//    self.customerInfo.idNo
    [params setObject:@"" forKey:@"tenantCredentailNo"];
    [params setObject:@"" forKey:@"roompeopleid"];
    [params setObject:self.houseInfo.rentPrice forKey:@"monthRent"];
    [params setObject:startDate forKey:@"contractStartDate"];
    [params setObject:endDate forKey:@"contractEndDate"];
//
    [params setObject:self.currentPayType forKey:@"paymentTypeDisp"];
    [[HouseStore sharedStore] saveCfContractXS:^(NSMutableDictionary *result , NSError *err) {
        if(err != nil){
            ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
            [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }else{
            NSString *cfcontractid = [result valueForKey:@"cfcontractid"];
            ContractTermsViewController *contractTermsViewController = [[ContractTermsViewController alloc] init];
            contractTermsViewController.cfcontractid = cfcontractid;
            contractTermsViewController.houseInfo = self.houseInfo;
            contractTermsViewController.house = self.house;
            [self.navigationController pushViewController:contractTermsViewController animated:YES];
        }
    } param:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
