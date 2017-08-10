//
//  PayOrderViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/20.
//  Copyright © 2016年 相寓. All rights reserved.
//



#import "PayOrderViewController.h"
#import "PayOrderInfoCell.h"
#import "SelectCouponCell.h"
#import "PayTypeCell.h"
#import "HouseStore.h"
#import "PayMoneyInfoCell.h"
#import "PayProcessor.h"
#import "PayStore.h"
#import "MyContractViewController.h"
static NSString *payOrderInfoCellId = @"payOrderInfoCellId";
static NSString *selectCouponCellId = @"selectCouponCellId";
static NSString *payTypeCellId = @"payTypeCellId";
static NSString *payMoneyInfoCellId = @"payMoneyInfoCellId";


@interface PayOrderViewController ()

@end

@implementation PayOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToContractVc) name:@"跳转到我的合同" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self initBottomView];
    [self setRightSwipeGestureAndAdaptive];
    self.currentPayType = WX_PAY;
    [self loadData];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"立即支付" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    
}

-(void) initBodyView{
    
    self.bodyView = [[UITableView alloc] init];
    self.bodyView.frame = CGRectMake(0, 64, screen_width, screen_height-64 -60);
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    [self.view addSubview:self.bodyView];
    
    UINib *nib = [UINib nibWithNibName:@"PayOrderInfoCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:payOrderInfoCellId];
    
    nib = [UINib nibWithNibName:@"SelectCouponCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:selectCouponCellId];
    
    nib = [UINib nibWithNibName:@"PayTypeCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:payTypeCellId];
    
    nib = [UINib nibWithNibName:@"PayMoneyInfoCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:payMoneyInfoCellId];
    
    self.currentPayType = WX_PAY;
}

-(void) initBottomView{
    
    self.bottomBlock = [[UIView alloc] init];
    self.bottomBlock.frame = CGRectMake(0, self.bodyView.bottomY, screen_width, 60);
    [self.bottomBlock setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    [self.view addSubview:self.bottomBlock];
    
    self.payBtn = [[UIButton alloc] init];
    self.payBtn.frame = CGRectMake(10, 10, screen_width-20, 40);
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    self.payBtn.frame = CGRectMake(10, screen_height-50, screen_width-20, 40);
    [self.payBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.layer.cornerRadius = 5;
    [self.payBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.view addSubview:self.payBtn];
    
    [self.payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) loadData
{
    [[HouseStore sharedStore] getCfContractXS:^(CfContractXS *cfContractXS, NSError *err) {
    
        self.cfContractXS = cfContractXS;
        [self.bodyView reloadData];
    } contractId:self.cfcontractid];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 4;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }else if(section == 3){
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2){
        return 124;
    }else if (indexPath.section == 1){
        return 0;
    }
    return 54;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2|| section == 3){
        return 11;
    }
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0){
        PayOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:payOrderInfoCellId forIndexPath:indexPath];
        if(indexPath.row == 0){
            [cell.infoLabel setText:@"合同编号 : "];
            [cell.content setText:self.cfContractXS.cfContractId];
        }else if(indexPath.row == 1){
            [cell.infoLabel setText:@"房屋信息 : "];
            [cell.content setText:[NSString stringWithFormat:@"%@ %@" , self.cfContractXS.circleName , self.cfContractXS.projectName]];
        }else if(indexPath.row == 2){
            [cell.infoLabel setText:@"确认租期 : "];
            [cell.content setText:[self.cfContractXS getRentDate]];
        }else if(indexPath.row == 3){
            [cell.infoLabel setText:@"付款方式 : "];
            [cell.content setText:self.cfContractXS.paymentType];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.section == 1){
        SelectCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCouponCellId forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.section == 2){
        PayMoneyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:payMoneyInfoCellId forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.yajin setText:[NSString stringWithFormat:@"%@元", self.cfContractXS.payDeposit]];
        [cell.zujin setText:[NSString stringWithFormat:@"%@元", self.cfContractXS.firstRent]];
        [cell.fuwufei setText:[NSString stringWithFormat:@"%@元", self.cfContractXS.serviceFee]];
        return cell;
    }else if(indexPath.section == 3){
        PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:payTypeCellId forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if(indexPath.row == 0){
            [cell.line2View setHidden:YES];
            [cell.payType setText:@"微信支付"];
            [cell.payIcon setImage:[UIImage imageNamed:@"tenpay"]];
            if ([self.currentPayType isEqualToString:WX_PAY]) {
                [cell.status setImage:[UIImage imageNamed:@"select_yuan"]];
            }else{
                [cell.status setImage:[UIImage imageNamed:@"unselect_yuan"]];
            }
        }else if(indexPath.row == 1){
            [cell.line2View setHidden:YES];
            [cell.payType setText:@"支付宝支付"];
            [cell.payIcon setImage:[UIImage imageNamed:@"alipay"]];
            if ([self.currentPayType isEqualToString:ALI_PAY]) {
                [cell.status setImage:[UIImage imageNamed:@"select_yuan"]];
            }else{
                [cell.status setImage:[UIImage imageNamed:@"unselect_yuan"]];
            }
        }
//        else if(indexPath.row == 2){
//            [cell.payType setText:@"银联支付"];
//            [cell.payIcon setImage:[UIImage imageNamed:@"unionpay"]];
//            if ([self.currentPayType isEqualToString:YI_PAY]) {
//                [cell.status setImage:[UIImage imageNamed:@"select_yuan"]];
//            }else{
//                [cell.status setImage:[UIImage imageNamed:@"unselect_yuan"]];
//            }
//        }
        return cell;
    }
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            self.currentPayType = WX_PAY;
        }else if(indexPath.row == 1){
            self.currentPayType = ALI_PAY;
        }
//        else if(indexPath.row == 2){
//            self.currentPayType = YI_PAY;
//        }
        [self.bodyView reloadData];
    }
}

-(void) pay
{
    NSLog(@">>>>>>>>>>>>>>开始支付：%@",self.currentPayType);
    float totalMoney = [self.cfContractXS.serviceFee floatValue] + [self.cfContractXS.firstRent floatValue] + [self.cfContractXS.payDeposit floatValue];
    
    NSMutableDictionary *payInfo1 = [NSMutableDictionary new];
    [payInfo1 setObject:self.cfContractXS.serviceFee forKey:@"payAmount"];
    [payInfo1 setObject:self.cfContractXS.serviceFeeCode forKey:@"tid"];
    
    NSMutableDictionary *payInfo2 = [NSMutableDictionary new];
    [payInfo2 setObject:self.cfContractXS.serviceFee forKey:@"payAmount"];
    [payInfo2 setObject:self.cfContractXS.serviceFeeCode forKey:@"tid"];
    
    NSMutableDictionary *payInfo3 = [NSMutableDictionary new];
    [payInfo3 setObject:self.cfContractXS.serviceFee forKey:@"payAmount"];
    [payInfo3 setObject:self.cfContractXS.serviceFeeCode forKey:@"tid"];
    
    NSMutableArray *list = [NSMutableArray new];
    [list addObject:payInfo1];
    [list addObject:payInfo2];
    [list addObject:payInfo3];
    /**
     微信及支付宝支付
     */
    PayProcessor *payProcessor = [PayProcessor sharedInstance];
    if ([self.currentPayType isEqualToString:WX_PAY]) {
        WeiXinPayProcessor * wxpay = [WeiXinPayProcessor sharedInstance];
        wxpay.delegate = payProcessor;
        [wxpay doWeixinpay:[NSString stringWithFormat:@"%f" , totalMoney]
            payInfoDtoList:list navigationController:self.navigationController];
    }else if([self.currentPayType isEqualToString:ALI_PAY]){
        [[PayStore sharedStore] payAliOrder:^(AliPay *aliPay, NSError *err) {
            AlipayProceessor *ap = [AlipayProceessor sharedInstance];
            AlixPayOrder *payOrder = [ap buildAlixPayOrder:aliPay];
            [ap doAlipay:payOrder alipaySign:aliPay.sign paymentType:self.currentPayType navigationController:self.navigationController];
        } orderType:@"1" type:@"1000200250002" payChannel:@"1000200420001" payAmount:[NSString stringWithFormat:@"%f" , totalMoney] payInfoDtoList:list];
    }
}

- (void)pushToContractVc{
    MyContractViewController *mcvc = [[MyContractViewController alloc] init];
    mcvc.pushTypeStr = push_from_fill_user_vc;
    [self.navigationController pushViewController:mcvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
