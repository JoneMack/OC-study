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
#import "HdcStore.h"
#import "StylerTabbar.h"
#import "AppDelegate.h"
#import "UserHdcController.h"

#define share_btn_x 275
@interface UserHdcDetailController ()
{
    LoadingStatusView *loading;
    UIButton *presentBtn;
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

    presentBtn = [[UIButton alloc] initWithFrame:CGRectMake(share_btn_x, y, navigation_height, navigation_height)];
    [presentBtn setImage:[UIImage imageNamed:@"icon_send"] forState:UIControlStateNormal];
    [presentBtn setImage:[UIImage imageNamed:@"icon_send"] forState:UIControlStateHighlighted];
    [presentBtn setBackgroundColor:[UIColor clearColor]];
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
    [loading updateStatus:nil animating:NO];
}

-(void)presentBtnClick:(UIButton *)sender{
    NSString *sendPresent = @"赠送给你的好盆友，赠送后在我的美发卡--赠送中查看";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:sendPresent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        // 生成赠送对象
        [SVProgressHUD showWithStatus:network_status_loading];
        [self performSelector:@selector(givePreset:) withObject:nil afterDelay:0.8];
    }
}


-(void)givePreset:(id)sender{
    
    [HdcStore getInvitationReward:^(HdcInvitationReward *hdcReward , NSError *error) {
        [SVProgressHUD dismiss:^{
            if (error == nil) {
                AppStatus *as = [AppStatus sharedInstance];
                NSString *content = [NSString stringWithFormat:@"您的好友%@赠送您一张时尚猫美发卡，赶快领取吧！",as.user.loginMobileNo];
                NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@",self.shareContent ,hdcReward.invitationUrl];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.userHdc.iconUrl]];
                self.shareImage = [[UIImage alloc] initWithData:data];
                ShareContent *shareContent = [[ShareContent alloc] initWithTitle:@""
                                                                         content:content
                                                                sinaWeiBoContent:contentWithUrl
                                                                             url:hdcReward.invitationUrl
                                                                           image:self.shareImage
                                                                        imageUrl:self.shareImageUrl
                                                                shareContentType:shareBannerPage];
                ShareSDKProcessor *shareSDKProcessor = [ShareSDKProcessor new];
                shareSDKProcessor.delegate = self;
                NSMutableArray *hideShareTypes = [NSMutableArray arrayWithObject:@(ShareTypeWeixiFav)];
                [shareSDKProcessor share:shareContent hideShareTypes:hideShareTypes shareViewDelegate:self sender:sender shareSuccessBlock:^(ShareSceneType *shareSceneType) {}];
            }
        }];
    } hdcNum:self.userHdc.hdcNum];
    
}


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest   navigationType:(UIWebViewNavigationType)inType
{
    if (self.withMask) {
        [SVProgressHUD showWithStatus:network_status_loading];
    }
    return YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@">>>> web load error:%@", webView.request.URL);
    [loading updateStatus:network_unconnect_note animating:NO];
    [SVProgressHUD dismiss];
}


#pragma mark 分享结果的代理
-(void) sharedSuccess{
    // 赠送完成后跳转到赠送页面
    [SVProgressHUD showSuccessWithStatus:@"美发卡已赠送，让好友去领取吧" duration:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
    StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
    [tabBar setSelectedIndex:tabbar_item_index_me];
    UINavigationController *targetNav = [tabBar getSelectedViewController];
    [targetNav popToRootViewControllerAnimated:YES];
    NSArray *hdcStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_donate), nil];
    UserHdcController *udc = [[UserHdcController alloc] initWithCardStatus:hdcStatuses];
    [targetNav pushViewController:udc animated:YES];
}

-(void) sharedFail{
    [HdcStore removeInvitationReward:^(NSError *error) {
    } hdcNum:self.userHdc.hdcNum];
}

-(void) sharedCancel{
    [HdcStore removeInvitationReward:^(NSError *error) {
    } hdcNum:self.userHdc.hdcNum];
}

-(NSString *)getPageName{
    return page_name_user_hdc_detail;
}

@end
