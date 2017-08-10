//
//  SystemPromptController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/21.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "SystemPromptController.h"

@interface SystemPromptController ()

@end

@implementation SystemPromptController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightSwipeGesture];
    [self initHeaderView];
    [self initBodyView];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"系统提示" navigationController:self.navigationController];
    self.headerView.needPop2Root = YES;
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
}

-(void) initBodyView
{
    self.bodyView = [[UIView alloc] init];
    self.bodyView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY);
    [self.bodyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.bodyView];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = CGRectMake(10 , 10 , screen_width - 20 , self.bodyView.frame.size.height - 20);
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webView.scrollView.scrollEnabled =YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView setOpaque:NO];
    [self.webView loadHTMLString:self.appInfo.unPayInfo baseURL:nil];
    [self.bodyView addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
