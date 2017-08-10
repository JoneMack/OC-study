//
//  LiveViewController.m
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()

@end

@implementation LiveViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadWeixinUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];
    
}

- (void)loadWeixinUserInfo{

    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSDictionary *rawDataDict = user.rawData;
        NSLog(@">>>>>rawDataDict>>>>>>--------%@",rawDataDict);
        NSString *nicName = [rawDataDict[@"nickname"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *encodedUrl = [rawDataDict[@"headimgurl"] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        NSString *rigistrStr = [NSString stringWithFormat:@"http://www.zjwepan.com/baihongapp/wx/registerUser?sex=%d&nickname=%@&unionid=%@&headimgurl=%@",[rawDataDict[@"sex"] intValue],nicName,rawDataDict[@"unionid"],encodedUrl];
        [self loadWebView:rigistrStr];
    }];
}

-(void)initHeadView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    topView.backgroundColor = [ColorUtils colorWithHexString:bar_common_color];
    [self.view addSubview:topView];
    
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

-(void)loadWebView:(NSString *)url{
    if (self.webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, screen_width, screen_height-20-tabbar_height)];
        self.webView.delegate = self;
        self.webView.scrollView.delegate = self;
        [self.view addSubview:self.webView];
        [self.webView setBackgroundColor:[UIColor clearColor]];
    }
    NSURL *nsurl =[NSURL URLWithString:url];
    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:request];
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
