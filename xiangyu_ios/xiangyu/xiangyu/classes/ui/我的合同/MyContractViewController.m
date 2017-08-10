//
//  MyContractViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MyContractViewController.h"
#import "MyContractViewCell.h"

static NSString *myContractViewCellId = @"myContractViewCellId";

@interface MyContractViewController ()

@end

@implementation MyContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
//    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
    [self initCustomSegmentView];
    [self selectSegment:0];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"我的合同" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    if ([self.pushTypeStr isEqualToString:push_from_fill_user_vc]) {
        self.headerView.type = from_fill_user_pay_vc;
    }
    [self.view addSubview:self.headerView];
}


-(void)initCustomSegmentView
{
    NSArray *btnTitleArray = [[NSArray alloc] initWithObjects:@"租客",@"业主", nil];
    self.xbCustomSegmentView = [[XBCustomSegmentView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height+splite_line_height, screen_width, 45)];
    [self.xbCustomSegmentView render:btnTitleArray currentIndex:[self getSelectIndex]];
    self.xbCustomSegmentView.delegate = self;
    self.xbCustomSegmentView.backgroundColor = [ColorUtils colorWithHexString:white_text_color];
    [self.view addSubview:self.xbCustomSegmentView];
}

//根据当前的美发卡状态获取选中的位序
-(int)getSelectIndex{
    if ([self.currentGameStatuses isEqualToArray:[[NSArray alloc] initWithObjects:@"租客", nil]]) {
        NSLog(@">>>>>>>>>>>租客>>>>>>>>>>");
        return 0;
        
    }else if ([self.currentGameStatuses isEqualToArray:[[NSArray alloc] initWithObjects:@"业主", nil]]) {
        NSLog(@">>>>>>>>>>>>业主>>>>>>>>>>>>>");
        return 1;
    }
    return 0;
}

-(void)selectSegment:(int)inx
{
    NSLog(@">>>>当前选择>>>>>>>%d",inx);
    switch (inx) {
        case 0:{
            self.zuKeViewController = [[ZuKeViewController alloc] init];
            self.zuKeViewController.view.frame = CGRectMake(0, self.xbCustomSegmentView.frame.origin.y+self.xbCustomSegmentView.frame.size.height, screen_width,screen_height-64-45);
            self.zuKeViewController.delegate = self;
            [self.view addSubview:self.zuKeViewController.view];
        }
            break;
        case 1:{
            self.yeZhuViewController = [[YeZhuViewController alloc] init];
            self.yeZhuViewController.view.frame = CGRectMake(0, self.xbCustomSegmentView.frame.origin.y+self.xbCustomSegmentView.frame.size.height, screen_width,screen_height-64-45);
            self.yeZhuViewController.delegate = self;
            [self.view addSubview:self.yeZhuViewController.view];
        }
            break;
              default:
            break;
    }
}

- (void)didZuKeViewControllerIndexPathRow:(NSInteger)row contractInfoList:(ContractInfoList *)contractInfoList{
        ContractDetailViewController *contractDetailViewController = [[ContractDetailViewController alloc] init];
        //    contractDetailViewController.userType = self.userType;
        [self.navigationController pushViewController:contractDetailViewController animated:YES];
}

- (void)didYeZhuViewControllerIndexPathRow:(NSInteger)row contractInfoList:(ContractInfoList *)contractInfoList{
        ContractDetailViewController *contractDetailViewController = [[ContractDetailViewController alloc] init];
        //    contractDetailViewController.userType = self.userType;
        [self.navigationController pushViewController:contractDetailViewController animated:YES];
}

//-(void) initBodyView
//{
//    self.bodyView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY) style:UITableViewStylePlain];
//    [self.view addSubview:self.bodyView];
//    self.bodyView.delegate = self;
//    self.bodyView.dataSource = self;
//    
//    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    UINib *nib = [UINib nibWithNibName:@"MyContractViewCell" bundle:nil];
//    [self.bodyView registerNib:nib forCellReuseIdentifier:myContractViewCellId];
//    
//    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
//    
//}
//
//
//-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 2;
//}

//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 45;
//}

//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 183;
//}

//-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(self.bodyHeaderView == nil){
//        self.bodyHeaderView = [[UITableViewHeaderFooterView alloc] init];
//        [self.bodyHeaderView.contentView setBackgroundColor:[UIColor whiteColor]];
//        
//        self.zukeBtn = [[UIButton alloc] init];
//        self.zukeBtn.frame = CGRectMake(0, 0, screen_width/2, 45);
//        [self.zukeBtn setTitle:@"租 客" forState:UIControlStateNormal];
//        [self.zukeBtn setTitleColor:[ColorUtils colorWithHexString:text_color_purple] forState:UIControlStateNormal];
//        [self.zukeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [self.bodyHeaderView.contentView addSubview:self.zukeBtn];
//        
//        self.yezhuBtn = [[UIButton alloc] init];
//        self.yezhuBtn.frame = CGRectMake(screen_width/2, 0, screen_width/2, 45);
//        [self.yezhuBtn setTitle:@"业 主" forState:UIControlStateNormal];
//        [self.yezhuBtn setTitleColor:[ColorUtils colorWithHexString:text_color_gray] forState:UIControlStateNormal];
//        [self.yezhuBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [self.bodyHeaderView.contentView addSubview:self.yezhuBtn];
//        
//        self.lineView = [[UIView alloc] init];
//        self.lineView.frame = CGRectMake(0, 44.5, screen_width, 0.5);
//        [self.lineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
//        [self.bodyHeaderView.contentView addSubview:self.lineView];
//        
//        
//        self.userType = @"user";
//        
//        [self.zukeBtn addTarget:self action:@selector(showUserContractDetail) forControlEvents:UIControlEventTouchUpInside];
//        [self.yezhuBtn addTarget:self action:@selector(showOwnerContractDetail) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    if([self.userType isEqualToString:@"user"]){
//        [self.zukeBtn setTitleColor:[ColorUtils colorWithHexString:text_color_purple] forState:UIControlStateNormal];
//        [self.yezhuBtn setTitleColor:[ColorUtils colorWithHexString:text_color_gray] forState:UIControlStateNormal];
//    }else{
//        [self.yezhuBtn setTitleColor:[ColorUtils colorWithHexString:text_color_purple] forState:UIControlStateNormal];
//        [self.zukeBtn setTitleColor:[ColorUtils colorWithHexString:text_color_gray] forState:UIControlStateNormal];
//    }
//    
//    return self.bodyHeaderView;
//}

//-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MyContractViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myContractViewCellId forIndexPath:indexPath];
//    return cell;
//}
//
//
//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    ContractDetailViewController *contractDetailViewController = [[ContractDetailViewController alloc] init];
////    contractDetailViewController.userType = self.userType;
//    [self.navigationController pushViewController:contractDetailViewController animated:YES];
//}


//-(void) showUserContractDetail{
//    
//    self.userType = @"user";
//    [self.bodyView reloadData];
//    
//}
//
//
//-(void) showOwnerContractDetail{
//    
//    self.userType = @"owner";
//    [self.bodyView reloadData];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
