//
//  TransactionViewController.m
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "TransactionViewController.h"
#import "ArticleStore.h"
@interface TransactionViewController ()

@end

@implementation TransactionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initHeadView];
    [self loadSwitchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.autoresizesSubviews = NO;

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


- (void)loadSwitchData{
    [ArticleStore getSwitchFlag:^(NSDictionary *flagDict, NSError *error) {
        NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
        NSString *bundleStr = [dicInfo objectForKey:@"CFBundleShortVersionString"];
        if (flagDict != nil) {
            NSLog(@">>>>>>>>>>>>%@",bundleStr);
            NSString *verStr = [NSString stringWithFormat:@"ios%@",bundleStr];
            self.flagStr = flagDict[verStr];
        }
        [self loadWebView];
    }];
}


-(void)initHeadView{
//    self.headerView = [[HeaderView alloc] initWithTitle:@"交易" navigationController:self.navigationController];
//    self.headerView.backBut.hidden = YES;
//    self.headerView.userInteractionEnabled = YES;
//    [self.view addSubview:self.headerView];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    topView.backgroundColor = [ColorUtils colorWithHexString:bar_common_color];
    [self.view addSubview:topView];
}

-(void)loadWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, screen_width, screen_height-20-tabbar_height)];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    if ([self.flagStr isEqualToString:@"false"]) {
//        NSString *contentStr = @"<p style=\"text-align: center;\"><img style=\"width:100%;\" src=\"http://www.zjwepan.com/images/j/jxltiqvzdfnauyts.jpg\" title=\"jxltiqvzdfnauyts.jpg\" alt=\"upfile\"/></p><p>特色服务功能：</p><p>1、老用户享有多种赠送体验劵活动，（100元/张）&nbsp;</p><p>2、内置在线直播交流室，供用户交流讨论做单策略。</p><p>3、内置即时财经数据，随时掌握第一手财经资讯</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; max-width: 100%; min-height: 1em; color: rgb(62, 62, 62); font-family: &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);\"><br/></p>";
//        
//        [self.webView loadHTMLString:contentStr baseURL:nil];
        NSURL *appUrl = [[NSURL alloc] initWithString:@"https://itunes.apple.com/cn/app/jin-rong-shuapp/id1147075616?mt=8"];
        [[UIApplication sharedApplication] openURL:appUrl];
    }else{
        NSURL *nsurl =[NSURL URLWithString:@"http://shipan.zhongjiangguoji.com/Home/Login"];
        NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
        [self.webView loadRequest:request];
    }
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    [self.webView setBackgroundColor:[UIColor clearColor]];
//    [self.view bringSubviewToFront:loading];
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
