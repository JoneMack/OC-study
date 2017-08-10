//
//  RegisterController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/3.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void) setupView
{
    // 设置大背景
    UIImage *bgImg = [UIImage imageNamed:@"bg_reg_640@2x.jpg"];
    self.view.layer.contents = (id) bgImg.CGImage;
    
    // header View
    self.headerView = [[HeaderView alloc] initWithTitle:@"注册用户" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    
    // body view
    CGRect bodyFrame = CGRectMake(0, self.headerView.bottomY,
                                  screen_width, screen_height-self.headerView.frame.size.height);
    self.bodyView = [[RegisterBodyView alloc] initWithNavigationController:self.navigationController];
    self.bodyView.backgroundColor = [UIColor clearColor];
    self.bodyView.frame = bodyFrame;
    [self.view addSubview:self.bodyView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
