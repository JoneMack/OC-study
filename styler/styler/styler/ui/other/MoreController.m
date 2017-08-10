//
//  MoreController.m
//  styler
//
//  Created by aypc on 13-10-1.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "MoreController.h"
#import "ImageUtils.h"
#import "AboutUsController.h"
#import "SystemNoticeController.h"
#import <ThirdFramework/asihttprequest/ASIDownloadCache.h>
#import <ThirdFramework/asihttprequest/ASIHTTPRequest.h>
#import "AppDelegate.h"
#import "HeaderView.h"
#import "shareContent.h"
#import "ShareSDKProcessor.h"
#import "WebContainerController.h"

#define share_title @"时尚猫"
#define share_icon [UIImage imageNamed:@"logo_114"]

@interface MoreController ()

@end

@implementation MoreController
{
    HeaderView *header;
    id<ISSContent> publishContent;
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
    // Do any additional setup after loading the view from its nib.
    if (!IOS6) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.frame = [UIScreen mainScreen].bounds;
    }else
    {
        self.view.frame = [UIScreen mainScreen].applicationFrame;
    }
    
    [self initHeader];
    
    
    [self initOtherView];
    [self initSupportView];
}

-(void)initHeader
{
    header = [[HeaderView alloc]initWithTitle:page_name_more navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void)initSupportView
{
    self.aboutUs.frame = CGRectMake(0, header.frame.size.height + general_margin, self.aboutUs.frame.size.width, self.aboutUs.frame.size.height);
    int y = self.aboutUs.frame.origin.y + self.aboutUs.frame.size.height +general_margin;
    self.clearAndEvalustion.frame = CGRectMake(0, y, screen_width, self.clearAndEvalustion.frame.size.height);
    
    self.recommend.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.about.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.score.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.cooperationAppLab.textColor = [ColorUtils colorWithHexString:gray_text_color];
    
    self.line1.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.line2.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.line3.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.line4.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.line1.frame = CGRectMake(self.line1.frame.origin.x, self.line1.frame.origin.y, self.line1.frame.size.width,  splite_line_height);
    self.line2.frame = CGRectMake(self.line2.frame.origin.x, self.line2.frame.origin.y, self.line2.frame.size.width,  splite_line_height);
    self.line3.frame = CGRectMake(self.line3.frame.origin.x, self.line3.frame.origin.y, self.line3.frame.size.width,  splite_line_height);
    self.line4.frame = CGRectMake(self.line4.frame.origin.x, self.line4.frame.origin.y, self.line4.frame.size.width,  splite_line_height);

    self.about_us_view.backgroundColor = [UIColor whiteColor];
    self.good_Evaluation.backgroundColor = [UIColor whiteColor];
    self.recommend_to_friend.backgroundColor = [UIColor clearColor];
}

-(void)initOtherView
{
    
    self.systemMessage.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.clear.textColor = [ColorUtils colorWithHexString:gray_text_color];
    
    self.line5.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.line6.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.line7.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.line5.frame = CGRectMake(self.line5.frame.origin.x, self.line5.frame.origin.y, self.line5.frame.size.width,  splite_line_height);
    self.line6.frame = CGRectMake(self.line6.frame.origin.x, self.line6.frame.origin.y, self.line6.frame.size.width,  splite_line_height);
    self.line7.frame = CGRectMake(self.line7.frame.origin.x, self.line7.frame.origin.y, self.line7.frame.size.width,  splite_line_height);
    self.system_img.backgroundColor = [UIColor whiteColor];
    self.clear_view.backgroundColor = [UIColor whiteColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    if ([self folderSizeAtPath:documentDirectory] >= 1) {
        self.cache.text = [NSString stringWithFormat:@"%.1f M",[self folderSizeAtPath:documentDirectory]];
    }else
    {
        self.cache.text = @"小于1 M";
    }
    self.cache.textColor = [ColorUtils colorWithHexString:gray_text_color];
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (IBAction)aboutUs:(id)sender {
    AboutUsController * about = [[AboutUsController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
    
    [MobClick event:log_event_name_goto_about_us];
}

- (IBAction)evaluate:(id)sender {
    NSString *str = @"";
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",APP_ID];
    }else
    {
        str = [NSString stringWithFormat:
                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                 APP_ID ];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    [MobClick event:log_event_name_share_to_sina_weibo attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"时尚猫好评", @"分享",nil]];
}

- (IBAction)recommend:(id)sender {
    [MobClick event:log_event_name_share_to_sina_weibo attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"微博分享", @"分享",nil]];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar.tabbarController hidesTabBar:YES animated:YES];
    
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/index", as.webPageUrl];
    NSString *content = [NSString stringWithFormat:share_app_txt];
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@ ",share_app_txt,url];
    
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:nil
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:url
                                                               image:[UIImage imageNamed:@"logo_1024.png"]
                                                            imageUrl:nil
                                                    shareContentType:shareAppPage];
    ShareSDKProcessor *shareSDKProcessor = [ShareSDKProcessor new];
    [shareSDKProcessor share:shareContent hideShareTypes:nil shareViewDelegate:self sender:sender shareSuccessBlock:^(ShareSceneType *shareSceneType) {
        [SVProgressHUD showSuccessWithStatus:@"推荐成功" duration:1];
    }];
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    [ShareSDKProcessor customShareView:viewController shareType:shareType];
}

- (IBAction)cooperationApp:(id)sender {
    NSString *url = @"http://styler.meilizhuanjia.cn/app/appLinks";
    WebContainerController *wcc = [[WebContainerController alloc] initWithUrl:url title:@"合作应用推荐"];
    [self.navigationController pushViewController:wcc animated:YES];
}

- (IBAction)systemMessage:(id)sender {
    SystemNoticeController * system = [[SystemNoticeController alloc]init];
    [self.navigationController pushViewController:system animated:YES];
}
- (IBAction)cleanCache:(id)sender {
    [MobClick event:log_event_name_share_to_sina_weibo];
    UIAlertView * cleanCacheAlert = [[UIAlertView alloc]initWithTitle:@"清除缓存" message:@"确定清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [cleanCacheAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.cache.text = @"小于1 M";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            NSLog(@"files :%d",[files count]);
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(NSString *)getPageName{
    return page_name_more;
}


@end
