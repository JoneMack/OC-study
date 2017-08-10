//
//  StylistProfileController.m
//  styler
//
//  Created by System Administrator on 14-1-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistProfileController.h"
#import "StylistSummaryView.h"
#import "CommonInfoCell.h"
#import "SimpleEvaluationCell.h"
#import "StylistStore.h"
#import "StylistEvaluationsController.h"
#import "UserLoginController.h"
#import "OrganizationDetailInfoController.h"
#import "StylistIntroductionController.h"
#import "OrganizationMapController.h"
#import "PriceListController.h"
#import "SpecialOfferListController.h"
#import "EvaluationStore.h"
#import "StylistWorkStore.h"
#import "UserStore.h"
#import "StylistPriceList.h"
#import "StylistSpecialOffer.h"
#import "WorkListController.h"
#import "PostEvaluationController.h"
#import "ChooseServicePackageController.h"
#import "UIViewController+Custom.h"
#import "HdcQuery.h"
#import "HdcStore.h"
#import "HairDressingCard.h"
#import "OrgHdcView.h"
#import "WebContainerController.h"
#import "OrderOnlineController.h"
#import "shareContent.h"
#import "ShareSDKProcessor.h"
#import "ShareEnableWebController.h"
#import "NSStringUtils.h"
#import "ShareContentType.h"
#import "ShareSceneType.h"
#import "NSStringUtils.h"



#define collect_view_x              236
#define share_btn_x                 275
#define order_view_height                 40
#define stylist_production_cell_height    107
#define general_cell_height         44
#define right_arrow_x               290
#define right_arrow_width           22
#define author_Info_btn_width           160
#define work_cover_width            86.5
#define close_date_height           25
#define address_btn_width           223

@interface StylistProfileController ()

@end

@implementation StylistProfileController
{
    NSString *stylistHdcCellIdentifier;
    id<ISSContent> publishContent;
    NSString *hdcStr;
    NSMutableString *newString;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(id) initWithStylistId:(int)stylistId{
    self = [super init];
    self.stylistId = stylistId;
    return self;
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paidSuccessCollectionStylist) name:notification_name_paid_success_collection_stylist object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:notification_name_reload_table_view object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hdcs = [[NSArray alloc] init];
    stylistHdcCellIdentifier  = @"stylistHdcCell";
    self.orderStylistView.clipsToBounds=YES;
    [self initView];
    [self setRightSwipeGestureAndAdaptive];
    if (self.stylist != nil ) {
        [self initUI];
    }
}

//整个View
-(void) initView{
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

#pragma mark -------控制整个View
//整个ui
-(void) initUI{
    [self initHeader];
    [self initTableView];
    [self initBottom];
//    [self performSelector:@selector(loadDisplayMovement) withObject:nil afterDelay:3];
    
}
//头部
-(void) initHeader{
    self.header = [[HeaderView alloc] initWithTitle:self.stylist.nickName navigationController:self.navigationController];
    [self.view addSubview:self.header];
    [self initRightBtn];
}
//头部右边按钮
-(void)initRightBtn
{
    int y = status_bar_height;
    if (IOS6) {
        y = 0;
    }
    self.collectBtn = nil;
    if (self.collectBtn == nil) {
        self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.collectBtn.frame = CGRectMake(collect_view_x, y, general_cell_height, general_cell_height);
        [self.collectBtn addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.collectBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
        self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:small_font_size];
        [self.collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(3,-2, 0, 0)];
        [self.header addSubview:self.collectBtn];
    }
    
    AppStatus * appStatus = [AppStatus sharedInstance];
    if([appStatus.user hasAddFavStylist:self.stylist.id])
    {
        [self.collectBtn setImage:[UIImage loadImageWithImageName:@"collect_icon"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage loadImageWithImageName:@"collect_icon"] forState:UIControlStateHighlighted];
    }else{
        [self.collectBtn setImage:[UIImage loadImageWithImageName:@"cancel_collect_icon"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage loadImageWithImageName:@"cancel_collect_icon"] forState:UIControlStateHighlighted];
    }
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(share_btn_x, y, general_cell_height, general_cell_height);
    [self.shareBtn setImage:[UIImage loadImageWithImageName:@"share_organization"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:self.shareBtn];
}

-(void)clickCollectBtn:(UIButton *)button
{
    AppStatus * appStatus = [AppStatus sharedInstance];
    if (![appStatus logined]) {
        UserLoginController *ulc = [[UserLoginController alloc] initWithFrom:account_session_from_add_favorite_stylist];
        [self.navigationController pushViewController:ulc animated:YES];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(addFavStylist) name:notification_name_user_login object:nil];
        return ;
    }
    BOOL hasCollected = [appStatus.user hasAddFavStylist:self.stylist.id];
    self.collectBtn.enabled = NO;
    if (!hasCollected) {
        [[UserStore sharedStore] addFavStylist:^(NSError *err){
             if (err == nil) {
                 [[UserStore sharedStore] favStylists:^(NSArray *stylists, NSError *err) {
                     self.collectBtn.enabled = YES;
                     if (err == nil) {
                         [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
                         
                         [self.collectBtn setImage:[UIImage loadImageWithImageName:@"collect_icon"] forState:UIControlStateNormal];
                         [self.collectBtn setImage:[UIImage loadImageWithImageName:@"collect_icon"] forState:UIControlStateHighlighted];
                         [appStatus.user addFavStylist:self.stylistId];
                         NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @(self.stylist.id), @"发型师id", nil];
                         [MobClick event:log_event_name_add_fav_stylist attributes:dict];
                         [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_fav_stylist object:nil];
                     }else
                     {
                         [SVProgressHUD showErrorWithStatus:@"收藏失败" duration:1.0];
                     }
                     
                     [button setEnabled:YES];
                 } userId:appStatus.user.idStr refresh:YES];
             }else
             {
                 [SVProgressHUD showErrorWithStatus:@"收藏失败" duration:1.0];
                 self.collectBtn.enabled = YES;
             }
         }userId:[appStatus.user.idStr intValue] stylistId:self.stylist.id];
    }else
    {
        [[UserStore sharedStore] removeFavstylist:^(NSError *err)
         {
             if (err == nil) {
                 [[UserStore sharedStore] favStylists:^(NSArray *stylists, NSError *err) {
                     self.collectBtn.enabled = YES;
                     if (err == nil) {
                         [SVProgressHUD showSuccessWithStatus:@"取消成功" duration:1.0];
                         [self.collectBtn setImage:[UIImage imageNamed:@"cancel_collect_icon"] forState:UIControlStateNormal];
                         [self.collectBtn setImage:[UIImage imageNamed:@"cancel_collect_icon"] forState:UIControlStateHighlighted];
                         [appStatus.user removeFavStylist:self.stylistId];
                         NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @(self.stylist.id), @"发型师id", nil];
                         [MobClick event:log_event_name_remove_fav_stylist attributes:dict];
                         [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_fav_stylist object:nil];
                     }else
                     {
                         [SVProgressHUD showErrorWithStatus:@"取消失败" duration:1.0];
                     }
                 } userId:appStatus.user.idStr refresh:YES];
             }else
             {
                 [SVProgressHUD showErrorWithStatus:@"取消失败" duration:1.0];
                 self.collectBtn.enabled = YES;
             }
             
             [button setEnabled:YES];
         }userId:[appStatus.user.idStr intValue] stylistId:self.stylist.id];
    }
}

-(void) paidSuccessCollectionStylist{
    self.collectBtn.enabled = YES;
    [self.collectBtn setImage:[UIImage loadImageWithImageName:@"collect_icon"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage loadImageWithImageName:@"collect_icon"] forState:UIControlStateHighlighted];
    [self.collectBtn setEnabled:YES];
}

-(void)shareBtnClick:(id)sender{
    ShareContent *shareContent = [self collectionShareContent];
    ShareSDKProcessor *shareSDKProcessor = [ShareSDKProcessor new];
    [shareSDKProcessor share:shareContent hideShareTypes:nil shareViewDelegate:self sender:sender shareSuccessBlock:^(ShareSceneType *shareSceneType) {
        // 分享成功后的回调
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_shared_success_show_reward_activity
                                                            object:shareSceneType];
    }];
}

-(ShareContent *) collectionShareContent{
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/stylists/%d",as.webPageUrl ,self.stylist.id];
    NSString *title = share_profile_title_txt;
    //    发型师名+剪发折后价+推荐美发卡价格
    newString = [NSMutableString new];
    for (int i = 0; i < self.hdcs.count; i++) {
        for (HairDressingCard *hdc in self.hdcs[i]) {
            if (hdc.saleRule.recommendStatus == YES) {
                hdcStr = [NSString stringWithFormat:@"%@%@ ",hdc.title,hdc.specialOfferPriceTxt];
                [newString appendString:hdcStr];
            }
        }
    }
    NSString *content = [NSString stringWithFormat:@"强烈推荐发型师%@ 剪发%d元 %@",self.stylist.nickName,self.stylist.hairCutPriceInfo.specialOfferPrice,newString];
    NSString *contentWithUrl = [NSString stringWithFormat:@"%@  %@ ", content, url];
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:title
                                                             content:content
                                                    sinaWeiBoContent:contentWithUrl
                                                                 url:url
                                                               image:self.shareImage
                                                            imageUrl:nil
                                                    shareContentType:shareStylistPage];
    return shareContent;
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    [ShareSDKProcessor customShareView:viewController shareType:shareType];
}

-(void)addFavStylist
{
    [self clickCollectBtn:self.collectBtn];
}

//初始化内容
-(void) initTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    CGRect tableViewFrame = self.tableView.frame;
    if ([UIApplication sharedApplication].keyWindow.frame.size.height == self.view.frame.size.height) {
        tableViewFrame.size.height = self.view.frame.size.height-self.header.frame.size.height-self.orderStylistView.frame.size.height;
    }else{
        
        tableViewFrame.size.height = self.view.frame.size.height-self.header.frame.size.height-self.orderStylistView.frame.size.height-general_margin;
    }
    tableViewFrame.origin.y = self.header.frame.size.height;
    self.tableView.frame = tableViewFrame;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    if ([self hasRewardActivity]) {
        UIButton *rewardActivityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        rewardActivityBtn.frame = CGRectMake(0, 0, screen_width, reward_activity_banner_height);
        rewardActivityBtn.titleLabel.font = [UIFont systemFontOfSize:default_font_size];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.activityBannerUrl]];
        [rewardActivityBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        [rewardActivityBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
        [rewardActivityBtn addTarget:self action:@selector(rewardActivityBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //            [tableView addSubview:rewardActivityBtn];
        [self.tableView setTableHeaderView:rewardActivityBtn];
    }

    [self loadWorkInfo];
    [self loadHdcs];
}

-(void) loadWorkInfo
{
    NSString *url = [StylistWorkStore getUrlForStylistWorks:self.stylist.id];
    [[StylistWorkStore sharedStore] getStylistWorksBySearcher:^(Page *page, NSError *err) {
        if (page.items != nil) {
            self.works = page.items;
        }else{
            self.works = [[NSArray alloc] init];
        }
        
        [self.tableView reloadData];
    } url:url refresh:YES];
}

-(void)loadHdcs
{
    [HdcStore getAllHdcTypes:^(NSArray *hdcCatalogs, NSError *error) {
    
        NSMutableArray *ids = [[NSMutableArray alloc] init];
        [ids addObject:[[NSNumber alloc] initWithInt:self.stylist.id]];
        HdcQuery *query = [[HdcQuery alloc] initWithStylistIds:ids];
        [HdcStore searchHdc:^(Page *page, NSError *error) {
            if (error == nil && page.items.count>0) {
                self.hdcs = [HairDressingCard sortHdcs:page.items hdcCatalogs:hdcCatalogs];
            }
            [self.tableView reloadData];
        } query:query];
        
    }];
}

-(BOOL) hasRewardActivity{
    if ([[RewardActivityProcessor sharedInstance] hasRewardActivityInSharedContentType:shareStylistPage]) {
        RewardActivityProcessor *rap = [RewardActivityProcessor sharedInstance];
        self.activityBannerUrl = [rap getActivityBannerUrl:shareStylistPage];
        return YES;
    }
    return NO;
}

-(void)reloadTableView{
    [self.tableView reloadData];
}

#pragma mark --dataSource ------
-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.hdcs == nil || self.hdcs.count == 0) {
        return 3;
    }
    return 4;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else if (section == 3)
    {
        return self.hdcs.count;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if ([self.stylist hasCloseDate]) {
            return close_date_height;
        }
        else{
            return general_padding;
        }
    }
    else if (section == 1) {
        return 0 ;
    }
    else if (section == 2){
        if(self.works != nil && self.works.count == 0){
            return 0;
        }
        return splite_line_height;
    }
    else if (section == 3)
    {
        return splite_line_height;
    }

   return general_padding;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3)
    {
        return general_height;
    }
    return 0;
}



-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    return stylist_summary_height;
                }
                else if(indexPath.row == 1){
                         return general_cell_height;
                }
                break;
            case 1:
                    return 0;
                break;
            case 2://作品
                if (self.works != nil && self.works.count == 0) {
                    return 0;
                }
                
                return stylist_production_cell_height;
                break;
            case 3:
                if ((self.hdcs.count-1) == indexPath.row) {
                    return [self.hdcs[self.hdcs.count-1] count]*general_cell_height;
                }
                return [self.hdcs[indexPath.row] count]*(general_cell_height) + general_padding;
                break;
                
            default:
                break;
        }
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView *downSpliteLine = [[UIView alloc]init];
    downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        if (indexPath.section == 0) {//发型师信息，简介
            if (indexPath.row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                StylistSummaryView *stylistSummary = [[StylistSummaryView alloc] initWithStylist:self.stylist frame:CGRectMake(0, 0, self.view.frame.size.width, stylist_summary_height+general_cell_height)];
                self.shareImage = stylistSummary.avatar.image;
                self.contentStr = stylistSummary.scoreLabel.text;
                downSpliteLine.frame = CGRectMake(0, stylist_summary_height - splite_line_height, screen_width, splite_line_height);
                [stylistSummary addSubview:downSpliteLine];
                [cell addSubview:stylistSummary];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                return cell;
            }else if (indexPath.row == 1){//地址和个人价目表
                CommonInfoCell *cell = [[CommonInfoCell alloc] init];
                cell.clipsToBounds = YES;
                [cell renderContent:nil content:nil contentLine:1];
                UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                addressBtn.frame = CGRectMake(0, 0, address_btn_width, general_cell_height);
                [addressBtn setTitle:self.stylist.organization.name forState:UIControlStateNormal];
                addressBtn.tag = 1000;
                [addressBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
                addressBtn.contentEdgeInsets = UIEdgeInsetsMake(0, general_padding, 0, 0);
                addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                addressBtn.titleLabel.font = [UIFont systemFontOfSize:default_font_size];
                [addressBtn addTarget:self action:@selector(addressAndPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:addressBtn];

                UIView *midLine = [[UIView alloc] init];
                midLine.frame = CGRectMake(address_btn_width, 5, splite_line_height, general_cell_height-general_padding);
                midLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
                [cell addSubview:midLine];
                
                UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                priceBtn.frame = CGRectMake(address_btn_width+splite_line_height, 0, screen_width-address_btn_width, general_cell_height);
                [priceBtn setTitle:@"价目表" forState:UIControlStateNormal];
                [priceBtn setShowsTouchWhenHighlighted:YES];
                priceBtn.tag = 1001;
                priceBtn.titleLabel.font = [UIFont systemFontOfSize:default_font_size];
                [priceBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
                [priceBtn addTarget:self action:@selector(addressAndPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:priceBtn];
//                UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(right_arrow_x, (general_cell_height-right_arrow_width)/2, right_arrow_width, right_arrow_width)];
//                [arrow setContentMode:UIViewContentModeCenter];
//                [arrow setImage:[UIImage imageNamed:@"right_arrow"]];
//                [cell addSubview:arrow];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else if(indexPath.section == 1){
            
        }else if(indexPath.section == 2){//作品
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.clipsToBounds = YES;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            downSpliteLine.frame = CGRectMake(0, stylist_production_cell_height - splite_line_height, screen_width, splite_line_height);
            [cell addSubview:downSpliteLine];
            UIView *topSpliteLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
            topSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            [cell addSubview:topSpliteLine];
            if (self.works != nil && self.works.count > 0) {
                for (int i = 0; i < 3 && i < self.works.count; i++) {
                    StylistWork *work = self.works[i];
                    UIImageView *workCover = [[UIImageView alloc] initWithFrame:CGRectMake(general_padding+work_cover_width*i+general_padding*i, general_padding, work_cover_width, work_cover_width)];
                    [workCover setBackgroundColor:[[Constant sharedInstance] getWaterfallBgColor]];
                    [workCover setContentMode:UIViewContentModeScaleAspectFill];
                    [workCover setImageWithURL:[NSURL URLWithString:[work getCover].thumbnailUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
                    [workCover setClipsToBounds:YES];
                    [cell addSubview:workCover];
                }
            }else if(self.stylist.expertTotalCount.worksCount > 0){
                [cell setContentMode:UIViewContentModeCenter];
                [cell.textLabel setText:@"                           正在加载作品..."];
                CGRect frame = cell.textLabel.frame;
                frame.origin.x = 135;
                cell.textLabel.frame = frame;
                [cell.textLabel setFont:[UIFont systemFontOfSize:default_font_size]];
                [cell.textLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                indicator.frame = CGRectMake(100, 45, general_margin, general_margin);
                [indicator startAnimating];
                [cell addSubview:indicator];
            }
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(right_arrow_x, 42, right_arrow_width, right_arrow_width)];
            [arrow setContentMode:UIViewContentModeCenter];
            [arrow setImage:[UIImage imageNamed:@"right_arrow"]];
            [cell addSubview:arrow];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            return cell;
        }
        else if (indexPath.section == 3)//在售美发卡
        {
            
            UITableViewCell *cell = [[UITableViewCell alloc] init];

            for(UIView *view in cell.contentView.subviews){
                [view removeFromSuperview];
            }
        
            float y = 0;
            int count = 0;
            for (HairDressingCard *hdc in self.hdcs[indexPath.row]) {
                CGRect frame = CGRectMake(general_padding,
                                          y,
                                          self.view.frame.size.width-general_padding,
                                          cell.frame.size.height);
                OrgHdcView *hdcView = [[OrgHdcView alloc] initWithFrame:frame
                                                                    hdc:hdc
                                                           displayScene:display_in_stylist_profile];
                [cell addSubview:hdcView];
                UITapGestureRecognizer *tapHdcView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewCardDetail:)];
                [hdcView addGestureRecognizer:tapHdcView];

                if(count > 0){
                    CGRect frame = CGRectMake(general_padding, y-splite_line_height, self.view.frame.size.width-general_padding, splite_line_height);
                    UIView *spliteL = [[UIView alloc] initWithFrame:frame];
                    [spliteL setBackgroundColor:[ColorUtils colorWithHexString:splite_line_color]];
                    [cell addSubview:spliteL];
                }
                y += general_cell_height;
                count ++;
            }
            
            //造成单元行间距的视图，其中该视图还包含了一个用作单元格之间的分割线
            UIView *view = [[UIView alloc] init];
            UIView *spliteLab = [[UIView alloc]init];
            spliteLab.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            if (self.hdcs.count-1 == indexPath.row) {
                view.frame = CGRectMake(0,0,0,0 );
                downSpliteLine.frame = CGRectMake(0, 0,0,0);
            }
            else
            {
                view.frame = CGRectMake(0,count*general_cell_height,screen_width,general_padding );
                downSpliteLine.frame = CGRectMake(0, count*general_cell_height-splite_line_height, screen_width, splite_line_height);
                spliteLab.frame = CGRectMake(0, general_padding-splite_line_height, screen_width, splite_line_height);
            }
            view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
            [view addSubview:spliteLab];
            [cell addSubview:view];
            [cell addSubview:downSpliteLine];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.section > 2 || (indexPath.section == 0 && indexPath.row == 2)){
            CommonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StylistProfileContentCell"];
            if(cell == nil){
                cell = [[CommonInfoCell alloc] init];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            return cell;
        }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        view.frame = CGRectMake(0, 0, screen_width, close_date_height);
        view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
        if (![self.stylist hasCloseDate]) {
            return view;
        }
        UILabel *closeDateLab = [[UILabel alloc] initWithFrame:CGRectMake(general_padding, 0, screen_width, 25)];
        closeDateLab.text = [NSString stringWithFormat:@"休假：%@-%@",[self.stylist getCloseStartDate],[self.stylist getCloseEndDate]];
        closeDateLab.textAlignment = NSTextAlignmentCenter;
        closeDateLab.textColor = [ColorUtils colorWithHexString:red_color];
        closeDateLab.font = [UIFont systemFontOfSize:smaller_font_size];
        [view addSubview:closeDateLab];
    }
    else if (section == 3)
    {
        view.frame = CGRectMake(0, order_view_height-general_padding, screen_width, splite_line_height);
        view.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    }
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, general_padding)];
        view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
        UILabel *onSaleTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(general_padding, 0, screen_width, order_view_height)];
        onSaleTitleLab.text = @"适用美发卡(预约前请务必购买，以享受优惠)";
        onSaleTitleLab.textColor = [ColorUtils colorWithHexString:red_color];
        onSaleTitleLab.font = [UIFont systemFontOfSize:default_font_size];
        [view addSubview:onSaleTitleLab];
        
        UIView *spliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, order_view_height-splite_line_height, screen_width, splite_line_height)];
        spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [view addSubview:spliteLine];
        return view;
    }
    return nil;
}

#pragma mark --delegate--
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];

//    StylistIntroductionController *eic = nil;
    WorkListController *wlc = nil;
    StylistEvaluationsController *sec = nil;
    NSString *url = nil;
//    int count = 0;
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0)
                {
                    [MobClick event:log_event_name_view_evaluations attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.stylist.id), @"发型师id", nil]];
                    sec = [[StylistEvaluationsController alloc] init];
                    sec.stylist = self.stylist;
                    [self.navigationController pushViewController:sec animated:YES];
                    
                }
//                else if (indexPath.row == 1) {
//                    [MobClick event:log_event_name_view_stylist_introduction attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.stylist.id), @"发型师id", nil]];
//                    
//                    eic = [[StylistIntroductionController alloc] init];
//                    eic.stylistName = self.stylist.nickName;
//                    eic.introductionTxt = self.infoStr;
//                    [self.navigationController pushViewController:eic animated:YES];
//                }
                break;
                
            case 2:
                [MobClick event:log_event_name_view_stylist_work_list attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.stylist.id), @"发型师id", nil]];
                
                url = [StylistWorkStore getUrlForStylistWorks:self.stylist.id];
                
                wlc = [[WorkListController alloc] initWithRequestURL:url title:self.stylist.name type:stylist_profile_work];
                [self.navigationController pushViewController:wlc animated:YES];
                break;
            case 3:
                [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
                
                break;
            default:
                break;
        }
}

-(void)viewCardDetail:(UIGestureRecognizer *)sender{
    OrgHdcView *hdcView = (OrgHdcView*)sender.view;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(self.stylist.id), @"发型师id", nil];
    [MobClick event:log_event_name_view_hdc_in_stylist attributes:dict];
    
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/hairDressingCards/%d?from=stylistProfile&stylistId=%d", as.webPageUrl, hdcView.hdc.id , self.stylist.id];
    ShareEnableWebController *wcc = [[ShareEnableWebController alloc] initWithUrl:url title:hdcView.hdc.title shareable:YES];
    [self.navigationController pushViewController:wcc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [MobClick event:log_event_name_confirm_call_org_phone attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.stylist.id), @"发型师id", nil]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.stylist.organization.phoneNo]]];
    }
}
#pragma mark ---buttonClick---

-(void)addressAndPriceBtnClick:(UIButton *)sender
{
    
    PriceListController *plc = nil;
    OrganizationDetailInfoController *odic = nil;
    int count = 0;
    switch (sender.tag)
    {
        case 1000:
            [MobClick event:log_event_name_select_org attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.stylist.organization.name, @"沙龙", nil]];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                count ++;
                if([controller isKindOfClass:[OrganizationDetailInfoController class]]){
                [self.navigationController popToViewController:controller animated:YES];
                    break;
                }else if (count == self.navigationController.viewControllers.count) {
                    odic = [[OrganizationDetailInfoController alloc] initWithOrganizationId:self.stylist.organization.id];
                    [self.navigationController pushViewController:odic animated:YES];
                }
            }
            break;
        case 1001:
            [MobClick event:log_event_name_view_price_list attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       @(self.stylist.id), @"发型师id", nil]];
            plc = [[PriceListController alloc] init];
            plc.stylist = self.stylist;
            [self.navigationController pushViewController:plc animated:YES];
            break;
    }

}

- (IBAction)orderAction:(UIButton *)sender {
    switch (sender.tag)
    {
        case 200:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"400-156-1618" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];            
            [MobClick event:log_event_name_phone_order];
        }
            break;
            
        case 201:
        {
            AppStatus * as = [AppStatus sharedInstance];
            if ([as logined]) {
                OrderOnlineController * coc = [[OrderOnlineController alloc]init];
                
                coc.stylist = self.stylist;
                [MobClick event:log_event_name_order_stylist attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.stylist.id), @"预约发型师ID", nil]];
                [self.navigationController pushViewController:coc animated:YES];
            }else
            {
                [self.navigationController pushViewController:[[UserLoginController alloc] initWithFrom:account_session_from_stylist_order] animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void) initBottom{
    CGRect frame = self.orderStylistView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height-splite_line_height;
    self.orderStylistView.frame = frame;
    
    self.bottomUpLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    [self.telOrderStylistBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
    self.telOrderStylistBtn.titleLabel.font=[UIFont systemFontOfSize:default_font_size];
    
    [self.onLineOrderStylistBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
    self.onLineOrderStylistBtn.titleLabel.font=[UIFont systemFontOfSize:default_font_size];
}

-(NSString *)getPageName{
    return page_name_stylist_profile;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.stylist == nil && self.stylistId > 0){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        StylistStore *es = [StylistStore sharedStore];
        [es getStylist:^(Stylist *stylist, NSError *err) {
            [SVProgressHUD dismiss];
            if(err == nil){
                self.stylist = stylist;
            }
            [self initUI];
            
        } stylistId:self.stylistId refresh:YES];
    }
}

-(void)rewardActivityBtnClick{
    [[RewardActivityProcessor sharedInstance] tryDisplayMovement:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
