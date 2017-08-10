//
//  ContentNavController.m
//  styler
//
//  Created by System Administrator on 14-2-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ContentNavController.h"
#import "ImageUtils.h"
#import "AllBrandController.h"
#import "SearchStore.h"
#import "OrganizationListController.h"
#import "AllBusinessCirclesController.h"
#import "UIView+Custom.h"

#define search_btn_x       270
#define positon_text_color @"#0099ff"
@interface ContentNavController ()

@end

static NSDate *lastUpdate;
@implementation ContentNavController
{
    AppStatus *as;
    NSTimer *timer;
    float lastOffsetY;//记录上一次的偏移量
    float webViewHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    as = [AppStatus sharedInstance];
    [self initView];
    [self initHeader];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationUpdate) name:@"user_location_change" object:nil];
}

#pragma mark - 初始化最父级视图
- (void)initView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.view.autoresizesSubviews = NO;
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 头部相关
//初始化头部
- (void)initHeader{
    //初始化布局与背景
    self.header  = [[HeaderView alloc] initWithTitle:page_name_special_offers_title navigationController:self.navigationController];
    self.header.backBut.hidden = YES;
    [self.view addSubview:self.header];
    
    //设置左侧按钮
    [self.locBut setImage:[UIImage imageNamed:@"beijing_touchupinside"] forState:UIControlStateHighlighted];
    [self.locBut setTitle:@"北京" forState:UIControlStateNormal];
    [self.locBut setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateNormal];
    [self.locBut setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateHighlighted];
    self.locBut.titleLabel.font = [UIFont systemFontOfSize:small_font_size];
    CGRect frame = self.locBut.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        frame.origin.y = 25;
    }else
    {
        frame.origin.y = 8;
    }
    self.locBut.frame = frame;
    [self.header addSubview:self.locBut];

    
//    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(search_btn_x, self.header.backBut.frame.origin.y-3, navigation_height, navigation_height)];
//    [searchBtn setImage:[UIImage imageNamed:@"branch_search_default"] forState:UIControlStateNormal];
//    [searchBtn setImage:[UIImage imageNamed:@"branch_search_select"] forState:UIControlStateHighlighted];
//    [searchBtn addTarget:self action:@selector(searchBranch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.header addSubview:searchBtn];
}

//-(void)searchBranch:(id)snder{
//    AllBrandController *abc = [[AllBrandController alloc] init];
//    [self.navigationController pushViewController:abc animated:YES];
//    [MobClick event:log_event_name_select_brand];
//}

//左侧城市icon点击后进行提示
- (IBAction)showCityNote:(id)sender {
    [SVProgressHUD showWithStatus:@"时尚猫暂时只开放了北京，您在哪座城市请通过个人中心在线客服告诉我们：）。" maskType:SVProgressHUDMaskTypeBlack duration:1.5];
}

- (IBAction)selectPosition:(id)sender {
    AllBusinessCirclesController *abcc = [[AllBusinessCirclesController alloc] init];
    [self.navigationController pushViewController:abcc animated:YES];
    
    [MobClick event:log_event_name_select_businesscirlces];
}

#pragma mark - WebView相关
-(void) initWebView
{
    [[AppStatus sharedInstance] setStylerUA];
    if (lastUpdate == nil) {
        lastUpdate = [NSDate date];
    }else {
        NSDate *yesterday = [[NSDate alloc] initWithTimeInterval:-60*60*12 sinceDate:[NSDate date]];
        if([lastUpdate compare:yesterday] == NSOrderedAscending){
            lastUpdate = [NSDate date];
            [self loadWebPage];
            return;
        }else{
            return ;
        }
    }

    CGRect frame = self.webView.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.height = [UIScreen mainScreen].bounds.size.height- frame.origin.y - tabbar_height;
    self.webView.frame = frame;
    self.webView.scrollView.scrollsToTop = NO;
    for (UIView *subView in [self.webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    self.webView.scrollView.delegate = self;
    lastOffsetY = 0;
    webViewHeight = self.webView.frame.size.height;
    
    [self initBigRetryBut];
    
    [self loadWebPage];
}

-(void)handleLocationUpdate{
//    [self renderPosition];
    [self loadWebPage];
}

-(void) loadWebPage{
    NSString * urlString = [NSString  stringWithFormat:@"%@/app/index?poi=%f,%f", as.webPageUrl, as.lastLat, as.lastLng];
    if (as.lastLat == 0 || as.lastLng == 0) {
        urlString = [NSString  stringWithFormat:@"%@/app/index?poi=%f,%f", as.webPageUrl, 39.974101, 116.348413];
    }
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView.scrollView setBackgroundColor:[UIColor clearColor]];
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.webView loadRequest:request];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    if (self.bigRetryBut != nil) {
        [self.bigRetryBut removeFromSuperview];
    }
    self.webView.scrollView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.hasLoadContent = YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.bigRetryBut.hidden = YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([error code] != NSURLErrorCancelled && !self.hasLoadContent) {
        [self displayRequestFailAndRetry];
    }
}


//上推，下拉操作
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self driveScrollView:scrollView lastOffsetY:lastOffsetY scrollViewHeight:webViewHeight topView:self.header];
    lastOffsetY = scrollView.contentOffset.y;
}

-(void)driveScrollView:(UIScrollView *)scrollView lastOffsetY:(float)_lastOffsetY scrollViewHeight:(float)_scrollViewHeight topView:(UIView *)view{
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) && scrollView.contentSize.height > (view.frame.size.height + _scrollViewHeight + general_margin)) {
        if (_lastOffsetY - scrollView.contentOffset.y > 0) {//下拉
            if (view.frame.origin.y != 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self showTopView];
                }];
            }
        }else if (_lastOffsetY - scrollView.contentOffset.y < 0 && _lastOffsetY > 0 ){//上推

            if (view.frame.origin.y != -view.frame.size.height) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self hiddenTopView];
                }];
            }
        }
    }
}


-(void)showTopView{
    self.header.frame = CGRectMake(0, 0, screen_width, self.header.frame.size.height);
    self.webView.frame = CGRectMake(0, self.header.frame.size.height, screen_width, webViewHeight);
}

-(void)hiddenTopView{
    self.header.frame = CGRectMake(0, -self.header.frame.size.height - splite_line_height, screen_width, self.header.frame.size.height);
    self.webView.frame = CGRectMake(0, 0, screen_width, webViewHeight+self.header.frame.size.height);
}

-(void) initBigRetryBut{
    self.bigRetryBut = [[UIButton alloc] initWithFrame:CGRectMake(80, 100, 200, 130)];
    self.bigRetryBut.backgroundColor = [UIColor clearColor];
    [self.bigRetryBut setTitle:network_request_fail forState:UIControlStateNormal];
    [self.bigRetryBut setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateNormal];
    [self.bigRetryBut.titleLabel setFont:[UIFont boldSystemFontOfSize:default_font_size]];
    [self.bigRetryBut setImage:[UIImage imageNamed:@"network_disconnect_icon"] forState:UIControlStateNormal];
    
    [self.bigRetryBut setTitleEdgeInsets:UIEdgeInsetsMake(100, -150, 0, 0)];
    [self.bigRetryBut setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.bigRetryBut addTarget:self action:@selector(loadWebPage) forControlEvents:UIControlEventTouchUpInside];
    self.bigRetryBut.hidden = YES;
    [self.view addSubview:self.bigRetryBut];
}

-(void) displayRequestFailAndRetry{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.bigRetryBut.hidden = NO;
}

-(NSString *)getPageName{
    return page_name_special_offers_title;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:page_name_home];
    
    [self initWebView];
}

-(void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:page_name_home];
}

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
