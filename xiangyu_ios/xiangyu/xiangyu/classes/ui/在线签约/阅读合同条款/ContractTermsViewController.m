//
//  ContractTermsViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "ContractTermsViewController.h"
#import "PayOrderViewController.h"
#import "HouseStore.h"

@interface ContractTermsViewController ()

@end

@implementation ContractTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self initBottomView];
    [self setRightSwipeGestureAndAdaptive];
    [self loadData];
}

-(void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"阅读合同条款" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView{
    CGRect frame = CGRectMake(0, 64, screen_width, screen_height - 64-60);
    self.bodyView = [[UIWebView alloc] initWithFrame:frame];
    AppStatus *as = [AppStatus sharedInstance];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/print/contract/getPreviewCfContractXS?token=%@&contractId=%@" , as.apiUrl , as.token , self.cfcontractid ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.bodyView loadRequest:request];
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    [self.bodyView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#e6e6e6'"];
    [self.view addSubview:self.bodyView];
}

-(void) initBottomView
{
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, self.bodyView.bottomY, screen_width, 60);
    [self.bottomView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    [self.view addSubview:self.bottomView];
    
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

-(void) loadData
{
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}


-(void) nextEvent
{
    PayOrderViewController *payOrderViewController = [[PayOrderViewController alloc] init];
    payOrderViewController.cfcontractid = self.cfcontractid;
    [self.navigationController pushViewController:payOrderViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
