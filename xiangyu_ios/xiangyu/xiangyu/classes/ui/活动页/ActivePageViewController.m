//
//  ActivePageViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/5.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "ActivePageViewController.h"

@interface ActivePageViewController ()

@end

@implementation ActivePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"活动页" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}


-(void) initBodyView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64)];
    [self.webView setScalesPageToFit:YES];
    NSURL *url = [NSURL URLWithString:[self.banner valueForKey:@"detailUrl"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
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
