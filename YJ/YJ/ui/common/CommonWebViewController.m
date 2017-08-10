//
//  CommonWebViewController.m
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/22.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "CommonWebViewController.h"
#import "LoadingStatusView.h"
@interface CommonWebViewController ()
{
    LoadingStatusView *loading;
}
@end

@implementation CommonWebViewController
- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title{
    self = [super init];
    if (self) {
        self.branchUrl = url;
        self.titleName = title;
        NSLog(@">>>>>>self.branchUrl>>>>>>>>>%@",self.branchUrl);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSURL *nsurl =[NSURL URLWithString:self.branchUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:request];
    
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
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
}

//-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest   navigationType:(UIWebViewNavigationType)inType
//{
//    NSLog(@">>>>> to:%@", inRequest.URL);
//    return YES;
//}
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    NSLog(@"scheme = %@",scheme);
    //判断是不是https
//    if ([scheme isEqualToString:@"https"]) {
//        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
//        if (!self.isAuthed) {
//            originRequest = request;
//            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            [conn start];
//            [awebView stopLoading];
//            return NO;
//        }
//    }
//    
//    NSURL *theUrl = [request URL];
//    self.currenURL = theUrl;
    return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@">>>> web load error:%@", webView.request.URL);
    loading.hidden = YES;
    [loading updateStatus:@"" animating:NO];
}


//#pragma mark ================= NSURLConnectionDelegate <NSObject>
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    
//}
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
//{
//    
//    return YES;
//}
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    
//    if ([challenge previousFailureCount]== 0) {
//        _authed = YES;
//        
//        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
//        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
//    }
//    else
//    {
//        [challenge.sender cancelAuthenticationChallenge:challenge];
//    }
//    
//}
//
//// Deprecated authentication delegates.
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    return [protectionSpace.authenticationMethod
//            isEqualToString:NSURLAuthenticationMethodServerTrust];
//    
//    return YES;
//}
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    
//    NSLog(@"challenge == %@",challenge);
//    
//    //    if (([challenge.protectionSpace.authenticationMethod
//    //          isEqualToString:NSURLAuthenticationMethodServerTrust])) {
//    //        if ([challenge.protectionSpace.host isEqualToString:@"111.200.87.69:8443/ccard"]) {
//    //            NSLog(@"Allowing bypass...");
//    //            NSURLCredential *credential = [NSURLCredential credentialForTrust:
//    //                                           challenge.protectionSpace.serverTrust];
//    //            [challenge.sender useCredential:credential
//    //                 forAuthenticationChallenge:challenge];
//    //        }
//    //    }
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//    
//}
//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    
//    
//}
//
//
//#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>
//
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
//{
//    
//    NSLog(@"%@",request);
//    return request;
//    
//}
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    
//    self.authed = YES;
//    //webview 重新加载请求。
//    [self.webView loadRequest:originRequest];
//    [connection cancel];
//}


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
