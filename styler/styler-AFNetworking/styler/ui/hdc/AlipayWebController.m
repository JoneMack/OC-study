//
//  AlipayWebController.m
//  styler
//
//  Created by System Administrator on 14-7-30.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "AlipayWebController.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"
#import "URLDispatcher.h"

@interface AlipayWebController ()

@end

@implementation AlipayWebController{
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

-(id) initWithUrl:(NSString *)url{
    self = [self init];
    self.url = url;
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
    self.header = [[HeaderView alloc] initWithTitle:page_name_alipay_payment navigationController:self.navigationController];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:self.header.backBut.frame];
    [backBtn setImage:self.header.backBut.imageView.image forState:UIControlStateNormal];
    [self.header.backBut removeFromSuperview];
    
    self.header.backBut = backBtn;
    [self.header addSubview:backBtn];
    [self.header.backBut addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.header];
}

-(void) initWebView{
    [[AppStatus sharedInstance] removeStylerUA];
    
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

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [loading updateStatus:network_status_loading animating:YES];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [loading updateStatus:nil animating:NO];
    [SVProgressHUD dismiss];
    NSString *js = @"var aElements = document.getElementsByTagName('a');"
                     "var result = '';"
                     "for(var i = 0; i < aElements.length; i++){"
                       "if(aElements[i].innerHTML=='返回商户'){"
                           "result = aElements[i].getAttribute('href');"
                       "}"
                     "}"
                    "result;";
    self.backUrl = [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    [SVProgressHUD showWithStatus:network_status_loading];
    return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [loading updateStatus:network_unconnect_note animating:NO];
    [SVProgressHUD dismiss];
}

-(void)goBack:(id)sender{
    if(self.backUrl == nil || [self.backUrl isEqualToString:@""]){
        self.backUrl = @"styler://webAlipay";
    }
    [URLDispatcher dispatch:[[NSURL alloc] initWithString:self.backUrl] nav:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *)getPageName{
    return page_name_alipay_payment;
}
@end
