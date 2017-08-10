//
//  WorkDetailController.m
//  styler
//
//  Created by wangwanggy820 on 14-6-5.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "WorkDetailController.h"
#import "UIView+Custom.h"
#import "WorkListController.h"
#import "StylistProfileController.h"
#import "UserLoginController.h"
#import "WorkListController.h"
#import "UserStore.h"
#import "StylistWorkStore.h"
#import "ShareContent.h"
#import "ShareSDKProcessor.h"


#define stylist_wapper_height 75
#define collect_btn_x        236
#define share_btn_x           275
#define tag_name_font         13
#define work_tag_height       40
#define tag_name_btn_height   40
#define hasAddWork            [UIImage imageNamed:@"collect_icon"]
#define hasNoAddWork          [UIImage imageNamed:@"cancel_collect_icon"]
@interface WorkDetailController ()

@end

@implementation WorkDetailController
{
    float y;//用来记录作品图片y
    int count;
    float scrollViewHeight;
    float lastOffsetY;
    BOOL isOperateWork;
    UIImageView *imageView;
    UIButton *rewardActivityBtn;
//    id<ISSContent> publishContent;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithWorkId:(int)workId{
    self = [super init];
    if (self) {
        self.workId = workId;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    [self initHeader];
    
    if (self.work != nil) {
        [self initScrollView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFavWork) name:@"add_stylist_work" object:nil];
    }else{
        [StylistWorkStore getStylistWork:^(StylistWork *work, NSError *err) {
            if (work != nil) {
                self.work = work;
                [self initScrollView];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFavWork) name:@"add_stylist_work" object:nil];
            }
        } workId:self.workId refresh:YES];
    }
    RewardActivityProcessor *rap = [RewardActivityProcessor sharedInstance];
    self.activityBannerUrl = [rap getActivityBannerUrl:shareStylistWorkPage];
    if ([self hasRewardActivity]) {
        [self initRewardActivityBtn];
    }
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:self.work.title navigationController:self.navigationController];
    [self.view addSubview:self.header];
    [self initCollectView];
    self.header.title.font = [UIFont systemFontOfSize:bigger_font_size];
    int btny = status_bar_height;
    if (IOS6) {
        btny = 0;
    }
    shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(share_btn_x, btny, navigation_height, navigation_height)];
    shareBtn.backgroundColor = [UIColor whiteColor];
    [shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share_organization"] forState:UIControlStateHighlighted];
    [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareWork:) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:shareBtn];
}

-(void)initCollectView{
    int btny = status_bar_height;
    if (IOS6) {
        btny = 0;
    }
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectBtn.backgroundColor = [UIColor clearColor];
    self.collectBtn.frame = CGRectMake(collect_btn_x, btny, navigation_height, navigation_height);
    [self.collectBtn addTarget:self action:@selector(collectWork:) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:self.collectBtn];
    AppStatus *as = [AppStatus sharedInstance];
    if ([as.user hasAddFavWork:self.work.id]) {
        [self.collectBtn setImage:hasAddWork forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:hasNoAddWork forState:UIControlStateNormal];
    }
    isOperateWork = NO;
}

#pragma mark - -----------------ShareSDK实现分享功能------------------
-(void)shareWork:(id)sender{
    ShareContent *shareContent = [self collectionShareContent];
    ShareSDKProcessor *shareSDKProcessor = [ShareSDKProcessor new];
    [shareSDKProcessor share:shareContent hideShareTypes:nil shareViewDelegate:self sender:sender shareSuccessBlock:^(ShareSceneType *shareSceneType){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_shared_success_show_reward_activity
                                                            object:shareSceneType];

        //  分享作品后会回调一下代码重新排序作品列表
        NSString *urlString = [NSString stringWithFormat:@"/works/%d/lastShareTime",self.work.id];
        [[StylistWorkStore sharedStore] shareStylistWork:^(NSError *err) {
        } url:urlString];
    }];
}

-(ShareContent *) collectionShareContent{
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/works/%@", as.webPageUrl, @(self.work.id)];
    NSString *title = [NSString stringWithFormat:@"%@的作品", self.work.stylist.name];
    NSString *content = share_work_txt;
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@  %@",content , url];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.work.cover.thumbnailUrl]];
    self.shareImage = [[UIImage alloc] initWithData:data];
    
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:title
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:url
                                                               image:self.shareImage
                                                            imageUrl:nil
                                                    shareContentType:shareStylistWorkPage];
    return shareContent;
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    [ShareSDKProcessor customShareView:viewController shareType:shareType];
}

-(void)initScrollView{
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];

    count = 0;
    CGRect frame = self.scrollView.frame;
   frame.origin.y = self.header.frame.size.height;

    frame.size.height = self.view.frame.size.height - self.header.frame.size.height;
    self.scrollView.frame = frame;
    
    [self initServicePictures];
    [self initWapper];
    [self initWorkTag];
    scrollViewHeight = self.scrollView.frame.size.height;

}

//处理有红包活动
-(void) initRewardActivityBtn{
    rewardActivityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rewardActivityBtn.frame = CGRectMake(0, 0, screen_width, reward_activity_banner_height);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.activityBannerUrl]];
    [rewardActivityBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    [rewardActivityBtn addTarget:self action:@selector(shshareStylistWorkPageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:rewardActivityBtn];
}

-(BOOL) hasRewardActivity{
    if ([[RewardActivityProcessor sharedInstance] hasRewardActivityInSharedContentType:shareStylistWorkPage]) {
        return YES;
    }
    return NO;
}

-(void)shshareStylistWorkPageBtnClick{
    [[RewardActivityProcessor sharedInstance] tryDisplayMovement:self];
}

//初始化并渲染 作品
-(void)initServicePictures{
    if ([self hasRewardActivity]) {
        y = reward_activity_banner_height;
    }else{
        y = 0;
    }
    for (ServicePicture *servicePicture in self.work.servicePictures) {
        CGSize size = [servicePicture getBigCGSize];
        float height = (size.height*screen_width)/size.width;
        
        imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0,y, screen_width, height);
        
        if ([self.work getCover].id == servicePicture.id) {
            self.shareImageView = [UIImageView new];
            [self.shareImageView setImageWithURL:[NSURL URLWithString:servicePicture.thumbnailUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        }
        [imageView setBackgroundColor:[[Constant sharedInstance] getWaterfallBgColor]];
        imageView.contentMode = UIControlStateNormal;
        [imageView setImageWithURL:[NSURL URLWithString:servicePicture.fileUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        [self.scrollView addSubview:imageView];
        y += height +general_padding;
    }
    self.wapper.backgroundColor = [ColorUtils colorWithHexString:white_text_color];
    self.wapper.frame = CGRectMake(0, y+3*general_padding, screen_width, stylist_wapper_height);
    
    self.workTag.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.workTag.frame =CGRectMake(0, y-general_padding, screen_width, work_tag_height);
    
    self.scrollView.contentSize = CGSizeMake(screen_width, y +work_tag_height +stylist_wapper_height+3*general_padding);
}

-(void)initWorkTag{
    
    //    CGRect frame = self.workTag.frame;
    //    frame.origin.y = y + self.wapper.frame.size.height;
    //    frame.size.height = work_tag_height;
    //    self.workTag.frame = frame;
    [self.workTag addStrokeBorderWidth:splite_line_height cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
    
    int i = 0;
    int x = 2*general_margin;
    for (NSString *tagName in self.work.tagNames) {
        CGSize size = [tagName sizeWithFont:[UIFont systemFontOfSize:tag_name_font] forWidth:screen_width lineBreakMode:NSLineBreakByWordWrapping];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, size.width, tag_name_btn_height)];
        [btn setTitle:tagName forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor purpleColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:tag_name_font];
        [btn setTitleColor:[ColorUtils colorWithHexString:red_default_color] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(workPage:) forControlEvents:UIControlEventTouchUpInside];
        [self.workTag addSubview:btn];
        i++;
        x += size.width + general_padding;
    }
    //分割线
    
    //    frame = self.spliteLine.frame;
    //    frame.origin.y = 2*general_padding;
    //    frame.size.height = splite_line_height;
    //    self.spliteLine.frame = frame;
    //    self.spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    //    self.numOfCollect.backgroundColor = [UIColor whiteColor];
    //    frame = self.numOfCollect.frame;
    //    frame.origin.y = splite_line_height;
    //    self.numOfCollect.frame = frame;
    //    self.numOfCollect.font = [UIFont systemFontOfSize:tag_name_font];
    //    self.numOfCollect.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
    //    self.numOfCollect.text = [NSString stringWithFormat:@"   有%d个用户收藏了该作品",self.work.collectedCount];
    
    UIView *midSpliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, work_tag_height, screen_width, splite_line_height)];
    midSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.workTag addSubview:midSpliteLine];
    
    
    self.line.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    CGRect frame = self.line.frame;
    frame.origin.x = 0;
    frame.origin.y = self.wapper.frame.size.height-splite_line_height;
    frame.size.width = screen_width;
    frame.size.height = splite_line_height;
    self.line.frame = frame;
    [self.wapper addSubview:self.line];
    
    
}

-(void)initWapper{
    
    Stylist *stylist = self.work.stylist;
    [self.stylistAvatar setImageWithURL:[NSURL URLWithString:stylist.avatarUrl] placeholderImage:[UIImage imageNamed:@"stylist_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    [self.stylistAvatar addStrokeBorderWidth:0 cornerRadius:self.stylistAvatar.frame.size.height/2 color:nil];
    
    self.stylistName.backgroundColor = [UIColor clearColor];
    self.stylistName.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.stylistName.font = [UIFont boldSystemFontOfSize:big_font_size];
    self.stylistName.text = self.work.stylist.nickName;
    CGRect frame = self.stylistName.frame;
    CGSize nameSize = [self.stylistName.text sizeWithFont:self.stylistName.font constrainedToSize:CGSizeMake(screen_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    frame.size.width = nameSize.width + general_padding;
    self.stylistName.frame = frame;
    
    [self.scoreView updateStarStatus:[stylist.expertTotalCount getAverageScore] viewMode:evaluation_score_view_mode_view];
    self.scoreView.backgroundColor = [UIColor clearColor];
    self.scoreView.hidden = YES;
    
    if (nameSize.width > [@"四个汉字" sizeWithFont:self.stylistName.font constrainedToSize:CGSizeMake(screen_width, 3000) lineBreakMode:NSLineBreakByWordWrapping].width) {
        CGRect frame = self.scoreView.frame;
        frame.origin.x = [self.stylistName rightX] +general_padding/2;
        self.scoreView.frame = frame;
    }
         
    
    NSString *text = [NSString stringWithFormat:@"共%d个作品",stylist.expertTotalCount.worksCount];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字体颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:gray_text_color] range:NSMakeRange(0,text.length)];

    //设置字体大小
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:small_font_size] range:NSMakeRange(0, text.length)];
    
    self.haircutPriceAndWorkNum.attributedText = attrStr;
    CGSize size2 = [text sizeWithFont:[UIFont systemFontOfSize:default_font_size] constrainedToSize:CGSizeMake(screen_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    frame = self.haircutPriceAndWorkNum.frame;
    frame.size.width = size2.width;
    self.haircutPriceAndWorkNum.frame = frame;
    
    
    //添加手势跳转profile页面
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stylistProfilePage:)];
    [self.wapper addGestureRecognizer:tap];
}

-(void)stylistProfilePage:(UIGestureRecognizer *)gesture{
    
    if(self.navigationController.viewControllers.count >= 3 && [self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] isKindOfClass:[StylistProfileController class]]){
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
        return;
    }
        StylistProfileController *spc = [[StylistProfileController alloc] initWithStylistId:self.work.stylist.id];
        [self.navigationController pushViewController:spc animated:YES];
        
        [MobClick event:log_event_name_view_stylist_from_work attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.work.stylist.id), @"作品", nil]];
}

//跳转到作品列表
-(void)workPage:(UIButton *)button{
    NSString *tagName = self.work.tagNames[button.tag];
    NSString *url = [NSString stringWithFormat:@"/works?tagName=%@&orderType=8",tagName];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WorkListController *wclc = [[WorkListController alloc] initWithRequestURL:urlStr title:tagName type:tag_name_work];
    [self.navigationController pushViewController:wclc animated:YES];
    
    [MobClick event:log_event_name_view_stylist_work_list attributes:[NSDictionary dictionaryWithObjectsAndKeys:tagName, @"作品", nil]];
}

#pragma mark --------收藏-------------
-(void)collectWork:(UIButton *)sender{
    if (isOperateWork) {
        return;
    }
    AppStatus *as = [AppStatus sharedInstance];
    if (!as.logined) {
        UserLoginController *ulc = [[UserLoginController alloc] initWithFrom:account_session_from_add_favorite_works];
        [self.navigationController pushViewController:ulc animated:YES];
    }else if([as.user hasAddFavWork:self.work.id]){
        [self removeFavWork];
    }else if(![as.user hasAddFavWork:self.work.id]){
        [self addFavWork];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:binding_sina_weibo_key]) {
            [self shareSinaWeiBo];
        }
    }
}

//收藏时自动分享到新浪微博
-(void) shareSinaWeiBo{
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/works/%@", as.webPageUrl, @(self.work.id)];
    NSString *content = share_work_follow_sina_weibo;
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@  %@",content , url];
    id<ISSContent> publishContent = [ShareSDK content:contentWithUrl
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:self.work.cover.thumbnailUrl]
                                                title:nil
                                                  url:url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK shareContent:publishContent type:ShareTypeSinaWeibo authOptions:nil shareOptions:nil statusBarTips:NO targets:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess) {
            NSLog(@">>>addFavWork>>>>分享成功");
            [MobClick event:log_event_name_share_to_sina_weibo_collection attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"成功", @"分享结果",nil]];
        }else if (state == SSResponseStateFail){
            NSLog(@">>>>addFavWork>>>分享失败");
            [MobClick event:log_event_name_share_to_sina_weibo_collection attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"失败", @"分享结果",nil]];
        }
    }];
}

-(void)removeFavWork{
    isOperateWork = YES;
    AppStatus *as = [AppStatus sharedInstance];
    [[UserStore sharedStore] removeFavWork:^(NSError *err) {
        if(err == nil){
            [self.collectBtn setImage:hasNoAddWork forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"取消成功!" duration:1.0];
            [MobClick event:log_event_name_remove_fav_work attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.work.stylist.id), @"作品", nil]];
            
            [self updateUserFavStylists];
        }else{
            [SVProgressHUD showErrorWithStatus:@"取消收藏失败，请稍后再试!" duration:1.0];
            isOperateWork = NO;
        }
    } userId:as.user.idStr workId:self.work.id];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(self.work.id), @"作品id", nil];
    [MobClick event:log_event_name_remove_fav_work attributes:dict];
}

-(void)addFavWork{
    //没有收藏，则收藏
    AppStatus *as = [AppStatus sharedInstance];
    if([as.user hasAddFavWork:self.work.id]){
//        self.collectImage.image = hasAddWork;
        [self.collectBtn setImage:hasAddWork forState:UIControlStateNormal];
    }else{
        isOperateWork = YES;
        [[UserStore sharedStore] addFavWork:^(NSError *err) {
            if (err == nil) {
                [self.collectBtn setImage:hasAddWork forState:UIControlStateNormal];
                [SVProgressHUD showSuccessWithStatus:@"收藏成功!" duration:1.0];
                [MobClick event:log_event_name_add_fav_work attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.work.stylist.id), @"作品", nil]];
                [self updateUserFavStylists];
            }else{
                [SVProgressHUD showErrorWithStatus:@"收藏失败，请稍后再试!" duration:1.0];
                isOperateWork = NO;
            }
        } userId:as.user.idStr workId:self.work.id];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(self.work.id), @"作品id", nil];
        [MobClick event:log_event_name_add_fav_work attributes:dict];
    }
    
}

-(void)updateUserFavStylists{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AppStatus *as = [AppStatus sharedInstance];
        NSString *url = [NSString stringWithFormat:@"/users/%@/favWorks" , as.user.idStr];
        [[StylistWorkStore sharedStore] getStylistWorksByApi:^(Page *page, NSError *err) {
            isOperateWork = NO;
            
            self.numOfCollect.text = [NSString stringWithFormat:@"   有%d个用户收藏了该作品",++self.work.collectedCount];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_fav_stylist object:nil];
        } url:url refresh:YES];
    });
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        [self driveScrollView:scrollView lastOffsetY:lastOffsetY scrollViewHeight:scrollViewHeight topView:self.header];
        lastOffsetY = scrollView.contentOffset.y;
    }
    
}

-(void)driveScrollView:(UIScrollView *)scrollView lastOffsetY:(float)_lastOffsetY scrollViewHeight:(float)_scrollViewHeight topView:(UIView *)view{
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) && scrollView.contentSize.height > (view.frame.size.height + _scrollViewHeight + general_margin)) {
        if (_lastOffsetY - scrollView.contentOffset.y > 0  && _lastOffsetY < (scrollView.contentSize.height - scrollView.frame.size.height)) {//下拉
            if (view.frame.origin.y != 0 && scrollView.tracking == YES) {
                [UIView animateWithDuration:0.5 animations:^{
                    view.frame = CGRectMake(0, 0, screen_width, view.frame.size.height);
                    scrollView.frame = CGRectMake(0, view.frame.size.height, screen_width,_scrollViewHeight);
                }];
            }
        }else if (_lastOffsetY - scrollView.contentOffset.y < 0){//上推
            if (view.frame.origin.y != -view.frame.size.height) {
                [UIView animateWithDuration:0.5 animations:^{
                    view.frame = CGRectMake(0, -view.frame.size.height - splite_line_height, screen_width, view.frame.size.height);
                    scrollView.frame = CGRectMake(0, 0, screen_width, _scrollViewHeight+view.frame.size.height);
                }];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *)getPageName{
    return page_name_work_detail;
}



@end
