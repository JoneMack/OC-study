//
//  UserHdcDetailController.m
//  styler
//
//  Created by wangwanggy820 on 14-10-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserHdcDetailController.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"
#import "NSStringUtils.h"
#import "ShareContent.h"
#import "ShareSDKProcessor.h"

#define share_btn_x 267
@interface UserHdcDetailController ()
{
    LoadingStatusView *loading;
}
@end

@implementation UserHdcDetailController

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
    [self renderShareBtn];
}

-(void)renderShareBtn{
    //   右边分享按钮
    int y = 0;
    if (IOS7) {
        y = status_bar_height;
    }
    UIButton *presentBtn = [[UIButton alloc] initWithFrame:CGRectMake(share_btn_x, y, navigation_height+80, navigation_height)];
    [presentBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateNormal];
    [presentBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateHighlighted];
    [presentBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
    presentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -38, 15, 0);
    [presentBtn setTitle:@"送朋友" forState:UIControlStateNormal];
    presentBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -70, 5, 30);
    presentBtn.titleLabel.font = [UIFont systemFontOfSize:default_2_font_size];
    [presentBtn addTarget:self action:@selector(presentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:presentBtn];
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
}

-(void)presentBtnClick:(UIButton *)sender{
    NSString *sendPresent = @"赠送给你的好盆友，赠送后在我的美发卡--赠送中查看";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:sendPresent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        [self givePreset:alertView];
    }
}

-(void)givePreset:(id)sender{
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
    return page_name_user_hdc_detail;
}

@end
