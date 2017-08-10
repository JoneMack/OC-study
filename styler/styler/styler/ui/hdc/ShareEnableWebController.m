//
//  HdcDetailController.m
//  styler
//
//  Created by wangwanggy820 on 14-8-5.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ShareEnableWebController.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"
#import "ShareContent.h"
#import "ShareSDKProcessor.h"
#import "RewardActivityProcessor.h"


#define share_btn_x 275

@interface ShareEnableWebController ()

@end

@implementation ShareEnableWebController
{
    LoadingStatusView *loading;
    id<ISSContent> publishContent;
    NSData *shareData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithUrl:(NSString *)url title:(NSString *)title shareable:(BOOL)shareable{
    self = [self init];
    self.url = url;
    self.title = title;
    self.shareable = shareable;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
    [self initHeader];
    [self initWebView];
    
}

-(void) initView{
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.view.autoresizesSubviews = NO;
    loading = [[LoadingStatusView alloc] initWithFrame:loading_frame];
    [self.view addSubview:loading];
}

-(void) initHeader{
    self.header = [[HeaderView alloc] initWithTitle:self.title navigationController:self.navigationController];
    
//   右边分享按钮
    int y = 0;
    if (IOS7) {
        y = status_bar_height;
    }
    if (self.shareable) {
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(share_btn_x, y, navigation_height, navigation_height)];
        [shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateHighlighted];
        [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareHdc:) forControlEvents:UIControlEventTouchUpInside];
        [self.header addSubview:shareBtn];
    }
    [self.view addSubview:self.header];
}

-(void) initWebView{
    [[AppStatus sharedInstance] setStylerUA];
    CGRect frame = self.webView.frame;
    frame.size.height = self.view.frame.size.height - self.header.frame.size.height;
    frame.origin.y = self.header.frame.size.height;
    self.webView.frame = frame;
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    self.webView.scrollView.decelerationRate = 0.8;
    
    [self.webView setDelegate:self];
    
    // 如果有奖励活动，把奖励活动带上
    RewardActivityProcessor *rap = [RewardActivityProcessor sharedInstance];
    NSString *bannerUrl = @"";
    if ([rap hasRewardActivityInSharedContentType:shareHdcPage]) {
        bannerUrl = [[rap getActivityBannerUrl:shareHdcPage] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    };
    self.url = [NSString stringWithFormat:@"%@&bannerUrl=%@" , self.url , bannerUrl ];
    NSURL *nsurl =[NSURL URLWithString:self.url];
    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:request];
}

-(void)shareHdc:(UIButton *)sender{
    
    NSString *content = [NSString stringWithFormat:@"%@",self.shareContent];
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@",self.shareContent , self.url];
    self.shareImage = [[UIImage alloc] initWithData:shareData];
    
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:self.shareTitle
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:self.shareUrl
                                                               image:self.shareImage
                                                            imageUrl:self.shareImageUrl
                                                    shareContentType:shareHdcPage];
    ShareSDKProcessor *shareSDKProcessor = [ShareSDKProcessor new];
        
    [shareSDKProcessor share:shareContent hideShareTypes:nil shareViewDelegate:self sender:sender shareSuccessBlock:^(ShareSceneType *shareSceneType){
    }];


}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
     [ShareSDKProcessor customShareView:viewController shareType:shareType];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [loading updateStatus:network_status_loading animating:YES];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    if (self.title == nil || [self.title isEqualToString:@""]) {
        self.header.title.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    NSString *js = @"document.getElementById('shareContent').innerHTML";
    self.shareContent = [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    js = @"document.getElementById('shareTitle').innerHTML";
    self.shareTitle = [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    js = @"document.getElementById('shareImage').getAttribute('src');";
    self.shareImageUrl = [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    js = @"document.getElementById('shareUrl').getAttribute('href');";
    self.shareUrl = [self.webView stringByEvaluatingJavaScriptFromString:js];
    if (self.shareUrl == nil || [self.shareUrl isEqualToString:@""]) {
        self.shareUrl = self.url;
    }
    [self initShareHdcImage];
    [loading updateStatus:nil animating:NO];
}

-(void) initShareHdcImage{
    shareData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImageUrl]];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest   navigationType:(UIWebViewNavigationType)inType
{
//    if ([[inRequest.URL absoluteString] rangeOfString:@"http://"].location == 0
//        && [[inRequest.URL absoluteString] isEqualToString:self.url]) {
//        [SVProgressHUD showWithStatus:network_status_loading];
//    }

    return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [loading updateStatus:network_unconnect_note animating:NO];
}

-(ShareContent *) collectionShareContent{
    
    NSString *content = [NSString stringWithFormat:@"%@",self.shareContent];
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@",self.shareContent , self.url];
    self.shareImage = [[UIImage alloc] initWithData:shareData];
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:self.shareTitle
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:self.shareUrl
                                                               image:self.shareImage
                                                            imageUrl:self.shareImageUrl
                                                    shareContentType:shareHdcPage];
    return shareContent;
}

-(NSString *)getPageName{
    return page_name_hdc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
