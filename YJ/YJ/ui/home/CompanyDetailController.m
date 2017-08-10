//
//  CompanyDetailController.m
//  YJ
//
//  Created by xubojoy on 2017/6/30.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "CompanyDetailController.h"
#import "CompanyInfoView.h"
@interface CompanyDetailController ()
@property(nonatomic, strong) HeaderView *headerView;
@property(nonatomic, strong) UIImageView *logoImageView;
@property(nonatomic, strong) UILabel *companyNameLabel;
@property(nonatomic, strong) UILabel *companyCodeLabel;
@property(nonatomic, strong) CompanyInfoView *companyInfoView;

@end

@implementation CompanyDetailController
//视图显示的时候, 隐藏系统导航  使用自定义导航
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeaderView];
    [self initUI];
}

- (void)initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"公司详情" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

- (void)initUI{
    [self initLogoView];
    [self initCompanyInfoView];
}


- (void)initLogoView{
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width-80)/2, self.headerView.frame.size.height+40, 80, 80)];
    self.logoImageView.image = [UIImage imageNamed:@"golf"];
    [self.view addSubview:self.logoImageView];
}

- (void)initCompanyInfoView{
    self.companyInfoView = [[CompanyInfoView alloc] initWithFrame:CGRectMake(0, self.logoImageView.frame.origin.y+self.logoImageView.frame.size.height, screen_width, 220)];
    [self.view addSubview:self.companyInfoView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
