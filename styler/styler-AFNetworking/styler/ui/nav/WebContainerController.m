//
//  WebContainerController.m
//  styler
//
//  Created by System Administrator on 14-2-18.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WebContainerController.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"
#import "NSStringUtils.h"
#import "ShareContent.h"
#import "ShareSDKProcessor.h"


#define share_btn_x 275
@interface WebContainerController ()

@end

@implementation WebContainerController
{
    LoadingStatusView *loading;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(id) initWithUrl:(NSString *)url title:(NSString *)title{
    self = [self init];
    if (self) {
        self.url = url;
        self.title = title;
    }
    return self;
}

- (void) viewDidLoad
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
    [self.view addSubview:self.header];
}

-(void)renderShareBtn{
    //   右边分享按钮
    int y = 0;
    if (IOS7) {
        y = status_bar_height;
    }
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(share_btn_x, y, navigation_height, navigation_height)];
    [shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateHighlighted];
    [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBanner:) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:shareBtn];
}

-(void) initWebView{
    [[AppStatus sharedInstance] setStylerUA];
    
    CGRect frame = self.webView.frame;
    frame.size.height = self.view.frame.size.height - self.header.frame.size.height;
    frame.origin.y = [self.header bottomY];
    self.webView.frame = frame;
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    self.webView.scrollView.decelerationRate = 0.8;
    
    [self.webView setDelegate:self];
    NSURL *nsurl =[NSURL URLWithString:self.url];
    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:request];
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
    
//    NSLog(@">>>>>>>>>>>>>>>>%@",self.shareContent);
//    NSLog(@">>>>>>>>>>>>>>>>%@",self.shareTitle);
//    NSLog(@">>>>>>>>>>>>>>>>%@",self.shareImageUrl);
//    NSLog(@">>>>>>>>>>>>>>>>%@",self.title);
    
    [loading updateStatus:nil animating:NO];
    
    if ([NSStringUtils isNotBlank:self.shareTitle]) {
        [self renderShareBtn];
    }
    [SVProgressHUD dismiss];
}

-(void)shareBanner:(UIButton *)sender{
    NSString *content = [NSString stringWithFormat:@"%@",self.shareContent];
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@",self.shareContent , self.url];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImageUrl]];
    self.shareImage = [[UIImage alloc] initWithData:data];
    
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:self.shareTitle
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:self.url
                                                               image:self.shareImage
                                                            imageUrl:self.shareImageUrl
                                                    shareContentType:shareBannerPage];
    ShareSDKProcessor *shareSDKProcessor = [ShareSDKProcessor new];

    [shareSDKProcessor share:shareContent shareViewDelegate:self sender:sender shareSuccessBlock:^(ShareSceneType *shareSceneType) {
    }];
}


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest   navigationType:(UIWebViewNavigationType)inType
{
    if (self.withMask) {
        [SVProgressHUD showWithStatus:network_status_loading];
    }
    NSLog(@">>>>> to:%@", inRequest.URL);
    return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@">>>> web load error:%@", webView.request.URL);
    [loading updateStatus:network_unconnect_note animating:NO];
    [SVProgressHUD dismiss];
}

-(NSString *)getPageName{
    return self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
