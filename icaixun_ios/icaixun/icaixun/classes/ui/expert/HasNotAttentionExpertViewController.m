//
//  HasNotAttentionExpertViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/7.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "HasNotAttentionExpertViewController.h"
#import "MyExpertsController.h"
#import "AddAttentionExpertViewController.h"
#import "UserStore.h"

@interface HasNotAttentionExpertViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerBlock;

@property (strong, nonatomic) IBOutlet UIButton *attentionNowBtn;

@property (nonatomic , strong) HeaderView *headerView;

@property (nonatomic , strong) UIAlertView *alertView;

- (IBAction)attentionNow:(id)sender;

@end

@implementation HasNotAttentionExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *bgImg = [UIImage imageNamed:@"bg_big_header@2x.jpg"];
    self.headerBlock.layer.contents = (id) bgImg.CGImage;
    self.headerView = [[HeaderView alloc] initWithTitle:@"爱财讯" navigationController:self.navigationController];
    self.headerView.backBut.hidden = YES;
    [self.headerBlock addSubview:self.headerView];
    
    self.alertView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPageView) name:notification_name_network_not_reachable object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)attentionNow:(id)sender {
    
    AddAttentionExpertViewController *addExpertController = [AddAttentionExpertViewController new];
    [self.navigationController pushViewController:addExpertController animated:YES];
    
}

-(void) refreshPageView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
