//
//  CommonContentWebController.m
//  BHZhiBo
//
//  Created by xubojoy on 2017/1/6.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "CommonContentWebController.h"
#import "LoadingStatusView.h"
@interface CommonContentWebController ()
{
    LoadingStatusView *loading;
}
@end

@implementation CommonContentWebController
- (instancetype)initWithArticle:(Article *)article title:(NSString *)title{
    self = [super init];
    if (self) {
        self.article = article;
        self.titleName = title;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeadView];
    [self loadWebView];
}

//初始化自定义导航
-(void)initHeadView{
    self.headerView = [[HeaderView alloc] initWithTitle:self.titleName navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    
    loading = [[LoadingStatusView alloc] initWithFrame:loading_frame];
    [loading updateStatus:@"" animating:YES];
    loading.backgroundColor = [UIColor clearColor];
    loading.center = self.view.center;
    [self.view addSubview:loading];
}

-(void)loadWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height+splite_line_height, screen_width, screen_height-self.headerView.frame.size.height)];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
//    [self.webView loadHTMLString:self.article.content baseURL:nil];
    NSURL *nsurl =[NSURL URLWithString:@"http://test.golfd.cn/admin/testPay.jsp"];
    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.view bringSubviewToFront:loading];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [loading setHidden:NO];
    [loading updateStatus:@"" animating:YES];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [loading setHidden:YES];
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('test').value"];
    
    NSLog(@">>>>>>>>>>>>>获取的值>>>>>>>>>>>%@",content);
}

- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    NSLog(@"scheme = %@",scheme);
    NSString *shareUrl = [NSString stringWithFormat:@"%@",request.URL];
    NSLog(@">>>>> 结果:%@", shareUrl);
    if ([shareUrl containsString:@"weixin://"]) {
        
        
    }
    return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@">>>> web load error:%@", webView.request.URL);
    loading.hidden = YES;
    [loading updateStatus:@"" animating:NO];
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
