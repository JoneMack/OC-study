//
//  FinanceViewController.m
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "FinanceViewController.h"
#import "LoadingStatusView.h"
@interface FinanceViewController ()
{
    LoadingStatusView *loading;
}
@end

@implementation FinanceViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.webView != nil) {
        [self.webView removeFromSuperview];
    }
    [self loadWebView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initHeadView];
}

//加载菊花
-(void)initActivityIndicatorView{
    self.activity =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    self.view.userInteractionEnabled = NO;
    //设置活动指示器的中间位置
    self.activity.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-10);
    [self.activity startAnimating];
    //添加到视图
    [self.view addSubview:self.activity];
}

-(void)initStopActivityIndicatorView{
    [self.activity stopAnimating];
    self.activity.hidden = YES;
}

//初始化自定义导航
-(void)initHeadView{
//    self.headerView = [[HeaderView alloc] initWithTitle:@"财经" navigationController:self.navigationController];
//    self.headerView.backBut.hidden = YES;
//    self.headerView.userInteractionEnabled = YES;
//    [self.view addSubview:self.headerView];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    topView.backgroundColor = [ColorUtils colorWithHexString:bar_common_color];
    [self.view addSubview:topView];
}

-(void)loadWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, screen_width, screen_height-20-tabbar_height)];
    NSURL *nsurl =[NSURL URLWithString:@"https://www.jin10.com/example/jin10.com.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:request];
    
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.view bringSubviewToFront:loading];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self initActivityIndicatorView];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [self initStopActivityIndicatorView];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest   navigationType:(UIWebViewNavigationType)inType
{
    NSLog(@">>>>> to:%@", inRequest.URL);
    return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@">>>> web load error:%@", webView.request.URL);
    [self initStopActivityIndicatorView];
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
