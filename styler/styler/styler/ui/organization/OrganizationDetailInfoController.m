//
//  OrganizationDetailInfoController.m
//  styler
//
//  Created by wangwanggy820 on 14-4-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationDetailInfoController.h"
#import "UIViewController+Custom.h"
#import "ShareContent.h"
#import "ShareSDKProcessor.h"

#define share_btn_x              275
@interface OrganizationDetailInfoController ()
@end

@implementation OrganizationDetailInfoController
{
    UIButton *backBtn;
    LoadingStatusView *loading;
    UILabel *storeName;
    UILabel *brandName;
    NSString *shareImageUrl;
    NSData *shareData;
    NSString *content;
    NSString *organizationName;
    id<ISSContent> publishContent;
    NSString *hdcStr;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrganizationId:(int)organizationId
{
    if (self = [super init]) {
        self.organizationId = organizationId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self renderWebView];
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:nil navigationController:self.navigationController];
    [self.view addSubview:self.header];
    //右边分享按钮
    int y = 0;
    if (IOS7) {
        y = status_bar_height;
    }
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(share_btn_x, y, navigation_height, navigation_height)];
    [self.shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateNormal];
    [self.shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateHighlighted];
    [self.shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareSKU:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setEnabled:NO];
    [self.header addSubview:self.shareBtn];

    if (self.organization == nil) {
        [OrganizationStore getOrganizationById:^(Organization *orginzation, NSError *err) {
            self.organization = orginzation;
            [self initTitle];
        } organizationId:self.organizationId hasStylists:YES];
    }else{
        [self initTitle];
    }
    
    [self initTitle];
}

-(void) initTitle{
    //头部中间造型 和 店名
    
    brandName = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/10, self.header.frame.size.height - 2*status_bar_height, 8*screen_width/10, status_bar_height)];
   
    brandName.text = self.organization.brandName;

    brandName.textColor = [ColorUtils colorWithHexString:black_text_color];
    brandName.backgroundColor = [UIColor clearColor];
    brandName.font = [UIFont boldSystemFontOfSize:bigger_font_size];
    brandName.textAlignment = NSTextAlignmentCenter;
    [self.header addSubview:brandName];
    
    float y = self.header.frame.size.height - status_bar_height;
    if ([brandName.text isEqualToString:@""] || !brandName.text) {
        y = (self.header.frame.size.height - status_bar_height/2 - status_bar_height);
    }
    storeName = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/10, y, 8*screen_width/10, status_bar_height)];
    storeName.text = self.organization.storeName;

    storeName.textColor = [ColorUtils colorWithHexString:black_text_color];
    storeName.backgroundColor = [UIColor clearColor];
    storeName.font = [UIFont systemFontOfSize:default_font_size];
    storeName.textAlignment = NSTextAlignmentCenter;
    [self.header addSubview:storeName];
}

//shareSDK 实现分享
-(void)shareSKU:(UIButton *)sender{
    ShareContent *shareContent = [self collectionShareContent];
    ShareSDKProcessor *shareSDKProcessor = [ShareSDKProcessor new];
    [shareSDKProcessor share:shareContent hideShareTypes:nil shareViewDelegate:self sender:sender shareSuccessBlock:^(ShareSceneType *shareSceneType){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_shared_success_show_reward_activity
                                                            object:shareSceneType];
    }];
}

-(ShareContent *) collectionShareContent{
    AppStatus *as = [AppStatus sharedInstance];
    NSString *urlStr = [NSString stringWithFormat:@"%@/app/organizations/%d",as.webPageUrl, self.organizationId];
    NSString *title = share_organization_txt;
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@",content , urlStr];
    // 如果点分享后，在这先加载数据，弹分享框会很慢，改在加载该页面时就去加载分享数据
    //    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
    self.shareImage = [[UIImage alloc] initWithData:shareData];
    
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:title
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:urlStr
                                                               image:self.shareImage
                                                            imageUrl:nil
                                                    shareContentType:shareOrganizationPage];
    return shareContent;
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    [ShareSDKProcessor customShareView:viewController shareType:shareType];
}

-(void)renderWebView{
    [[AppStatus sharedInstance] setStylerUA];
    
    CGRect frame = self.webView.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.height = self.view.frame.size.height - self.header.frame.size.height;
    self.webView.frame = frame;
    self.webView.delegate = self;
    self.webView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    AppStatus *as = [AppStatus sharedInstance];
    
    RewardActivityProcessor *rap = [RewardActivityProcessor sharedInstance];
    NSString *bannerUrl = @"";
    if ([rap hasRewardActivityInSharedContentType:shareOrganizationPage]) {
        bannerUrl = [[rap getActivityBannerUrl:shareOrganizationPage] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    };
    NSLog(@">>>>商户详情:%@" , bannerUrl);
    NSURL *url =[NSURL URLWithString:[NSString  stringWithFormat:@"%@/app/organizations/%d?app=yes&bannerUrl=%@", as.webPageUrl, self.organizationId , bannerUrl]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark ------delegate-----
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if (!loading) {
        loading = [[LoadingStatusView alloc] initWithFrame:loading_frame];
    }
    [loading updateStatus:network_status_loading animating:YES];
    [self.view addSubview:loading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    loading.hidden = YES;
    shareImageUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('coverPicture').src"];
    
    NSMutableString *organizationInfo = [[NSMutableString alloc] initWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('organizationName').innerHTML"]];
    [organizationInfo replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, organizationInfo.length)];
    content = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('shareContent').innerHTML"];
    
    NSArray *arr = [organizationInfo componentsSeparatedByString:@"/"];
    brandName.text = arr[0];
    storeName.text = arr[1];
    organizationName = arr[2];

    int y = self.header.frame.size.height - status_bar_height;
    
    if ([brandName.text isEqualToString:@""] || !brandName.text) {
        y = (self.header.frame.size.height - status_bar_height/2 - status_bar_height);
    }
    storeName.frame = CGRectMake(screen_width/10, y, 8*screen_width/10, status_bar_height);
    
    [self.shareBtn setEnabled:YES];
    [self initShareOrganizationImage];
}

-(void) initShareOrganizationImage{
    shareData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
}

- (NSString*) escapeStringForJavascript:(NSString*)input
{
    NSMutableString* ret = [NSMutableString string];
    int i;
    for (i = 0; i < input.length; i++)
    {
        unichar c = [input characterAtIndex:i];
        if (c == '\\')
        {
            // escape backslash
            [ret appendFormat:@"\\\\"];
        }
        else if (c == '"')
        {
            // escape double quotes
            [ret appendFormat:@"\\\""];
        }
        else if (c >= 0x20 && c <= 0x7E)
        {
            // if it is a printable ASCII character (other than \ and "), append directly
            [ret appendFormat:@"%c", c];
        }
        else
        {
            // if it is not printable standard ASCII, append as a unicode escape sequence
            [ret appendFormat:@"\\u%04X", c];
        }
    }
    return ret;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loading updateStatus:network_unconnect_note animating:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_organization_detail;

}


@end
