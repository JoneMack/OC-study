//
//  AllHairStyleController.m
//  styler
//
//  Created by System Administrator on 14-2-13.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "AllHairStyleController.h"
#import "UIViewController+Custom.h"
#import "UIView+Custom.h"

@interface AllHairStyleController ()

@end

@implementation AllHairStyleController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
//程序进入后台后，再次打开后回调用此通知
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
    [self initHeader];
    [self initWebView];
    // TODO: 加载 学习
    [self initBigRetryBut];
}
    
-(void) initView{
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.view.autoresizesSubviews = NO;
}

-(void) initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_all_hair_style navigationController:self.navigationController];
    [self.view addSubview:self.header];
    [self.header.backBut setHidden:NO];
}

#pragma mark - WebView相关
-(void) initWebView
{
    [[AppStatus sharedInstance] setStylerUA];
    [self.loadingTxt setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
    [self.loadingTxt setFont:[UIFont systemFontOfSize:default_font_size]];
    
    CGRect frame = self.webView.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.height = UIScreen.mainScreen.bounds.size.height-frame.origin.y - 4;
    self.webView.frame = frame;
    
    for (UIView *subView in [self.webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    [self.webView setDelegate:self];
    [self loadAllHairWebPage];
}

-(void) loadAllHairWebPage{
    self.loadingView.hidden = NO;
    self.bigRetryBut.hidden = YES;
    AppStatus *as = [AppStatus sharedInstance];
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/allHairStyle", as.webPageUrl]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    self.bigRetryBut.hidden = YES;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingView setHidden:YES];
    self.bigRetryBut.hidden = YES;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
        self.bigRetryBut.hidden = NO;
        self.loadingView.hidden = YES;
}

-(void) initBigRetryBut{
    self.bigRetryBut = [[UIButton alloc] initWithFrame:CGRectMake(80, self.header.bottomY + 80, 200, 130)];
    self.bigRetryBut.backgroundColor = [UIColor clearColor];
    [self.bigRetryBut setTitle:network_request_fail forState:UIControlStateNormal];
    [self.bigRetryBut setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateNormal];
    [self.bigRetryBut.titleLabel setFont:[UIFont boldSystemFontOfSize:default_font_size]];
    [self.bigRetryBut setImage:[UIImage imageNamed:@"network_disconnect_icon"] forState:UIControlStateNormal];
    
    [self.bigRetryBut setTitleEdgeInsets:UIEdgeInsetsMake(100, -150, 0, 0)];
    [self.bigRetryBut setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.bigRetryBut addTarget:self action:@selector(loadAllHairWebPage) forControlEvents:UIControlEventTouchUpInside];
    self.bigRetryBut.hidden = YES;
    [self.view addSubview:self.bigRetryBut];
}

-(void)appWillEnterForegroundNotification{
    [self.webView reload];
}

-(NSString *)getPageName{
    return page_name_all_hair_style;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
