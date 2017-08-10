//
//  AboutUsController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "AboutUsController.h"
#import "SystemStore.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeaderView];
    [self loadData];
}

- (void)initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"关于我们" navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
    CGRect bodyFrame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY);
    self.bodyView = [[AboutUsBodyView alloc] initWithFrame:bodyFrame];
    self.bodyView.frame = bodyFrame;
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    [self.view addSubview:self.bodyView];
    
    
    CGRect dashLineFrame = CGRectMake(45,  screen_height - 200, screen_width - 90, 0.5);
    self.dashLine = [[LineDashView alloc] initWithFrame:dashLineFrame
                                        lineDashPattern:@[@5, @5]
                                              endOffset:0.495];
    self.dashLine.backgroundColor = [ColorUtils colorWithHexString:gray_black_line_color];
    [self.view addSubview:self.dashLine];
    
}

-(void) loadData{
    [[SystemStore sharedInstance] getAppInfo:^(AppInfo *appInfo, NSError *err) {
        [self.bodyView renderAppInfo:appInfo];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
