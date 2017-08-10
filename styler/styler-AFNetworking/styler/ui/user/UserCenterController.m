//
//  UserCenterController.m
//  styler
//
//  Created by wangwanggy820 on 14-3-6.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//



#import "UserCenterController.h"
#import "CustomIconTextCell.h"
#import "ImageUtils.h"
#import "StylistListController.h"
#import "WorkListController.h"
#import "StylistWorkStore.h"
#import "MyOrderController.h"
#import "UserSettingController.h"
#import "UserRegController.h"
#import "MoreController.h"
#import "PushProcessor.h"
#import "MyEvaluationsController.h"
#import "UserStore.h"
#import "UserLoginController.h"
#import "OrderStore.h"
#import "StylistView.h"
#import "UserHdcController.h"
#import "UserRedEnvelopeController.h"
#import "Reminder.h"

#define red_dot_x      110
#define red_dot_hdc_x  123

@interface UserCenterController ()

@end

@implementation UserCenterController
{
    UIImageView *unreadFeedbackPushDotImage;
    UIImageView *unreadOrderPushDotImage;
    UIImageView *unreadUnPaymentHdcDotImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //在这个页面即将出现的时候判断是否登录 再做相应的操作
    if (![[AppStatus sharedInstance] logined]) {
        UserLoginController *ulc = [[UserLoginController alloc] initWithFrom:account_session_from_user_home];
        [self.navigationController pushViewController:ulc animated:NO];
        return ;
    }
    [self renderUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    [self initTopView];
    [self initTableView];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(renderUnPostStatus) name:notification_name_update_has_unevaluate_order object:nil];
    [nc addObserver:self selector:@selector(renderUI) name:notification_name_update_push object:nil];
    [nc addObserver:self selector:@selector(renderUnPaymentStatus) name:notification_name_update_has_unpayment_hdc object:nil];
    
}

//初始化背景色
-(void) initView
{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

//初始化topView
-(void) initTopView
{
    if ([[[UIDevice currentDevice]systemVersion] intValue] < 7) {
        self.topView.frame = CGRectMake(0, -status_bar_height, screen_width, self.topView.frame.size.height);
    }
    CGRect evaluationFrame = self.evluation.frame;
    evaluationFrame.origin.y = self.topView.frame.size.height+self.topView.frame.origin.y;
    self.evluation.frame = evaluationFrame;
    
    AppStatus *as = [AppStatus sharedInstance];
    
    //设置头像
    [self.userAvatar setImageWithURL:[NSURL URLWithString:as.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"user_default_image_before_load@2x"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    CALayer *layer  = self.userAvatar.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:self.userAvatar.frame.size.width/2];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[ColorUtils colorWithHexString:black_text_color].CGColor];
    
    //设置名字xiangmu
    self.userName.text = as.user.name;
    self.userName.textColor = [UIColor whiteColor];
    self.userName.font = [UIFont boldSystemFontOfSize:default_font_size];
    
    //设置手机号
    self.userPhoneNumber.titleLabel.text = as.user.loginMobileNo;
    [self.userPhoneNumber setTitle:as.user.loginMobileNo forState:UIControlStateNormal];
    self.userPhoneNumber.titleLabel.textColor = [UIColor whiteColor];
    self.userPhoneNumber.titleLabel.font = [UIFont systemFontOfSize:small_font_size];
    
    //设置我的评价按钮
    [self.myEvaluation setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
    [self.myEvaluation.titleLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    [self.myEvaluation setBackgroundImage:[UIImage imageNamed:@"my_evaluate"]  forState:UIControlStateNormal];
    
    //设置我的评价个数
    self.evaluationCount.textColor = [ColorUtils colorWithHexString:orange_text_color];
    self.evaluationCount.font = [UIFont boldSystemFontOfSize:default_font_size];
    self.evaluationCount.hidden = YES;

    //设置待评价按钮
    [self.unPostEvaluations setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
    [self.unPostEvaluations.titleLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    [self.unPostEvaluations setBackgroundImage:[UIImage imageNamed:@"unPost_evluate"] forState:UIControlStateNormal];
}

-(void)renderUnPostStatus{
    AppStatus *as = [AppStatus sharedInstance];
    if(as.hasUnevaluationOrder){
        [self.unPostEvaluations setImage:[UIImage imageNamed:@"red_dot.png"] forState:UIControlStateNormal];
    }else{
        [self.unPostEvaluations setImage:nil forState:UIControlStateNormal];
    }
}

-(void)renderUnPaymentStatus{
    AppStatus *as = [AppStatus sharedInstance];
    if(as.hasUnpaymentHdc){
        unreadUnPaymentHdcDotImage.hidden = NO;
    }else{
        unreadUnPaymentHdcDotImage.hidden = YES;
    }
}

//初始化
-(void) initTableView
{
    //设置布局
    
    CGRect frame = self.tableView.frame;

    frame.origin.y = self.topView.frame.size.height+self.evluation.frame.size.height+general_margin;
    
    if ([UIApplication sharedApplication].keyWindow.frame.size.height == self.view.frame.size.height) {
        frame.size.height = self.view.frame.size.height-self.topView.frame.size.height-self.evluation.frame.size.height-tabbar_height;
    }else{
    
        frame.size.height = self.view.frame.size.height-self.topView.frame.size.height-self.evluation.frame.size.height-tabbar_height-general_margin;
    }
    
    self.tableView.frame = frame;

    UINib *nib = [UINib nibWithNibName:@"CustomIconTextCell" bundle:nil];
   
    [self.tableView registerNib:nib forCellReuseIdentifier:@"userInfoNavCell"];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setScrollsToTop:NO];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    //未读的客服通知
    unreadFeedbackPushDotImage = [[UIImageView alloc] init];
    unreadFeedbackPushDotImage.frame = CGRectMake(red_dot_x, (general_cell_height -red_dot_width)/2, red_dot_width, red_dot_width);
    unreadFeedbackPushDotImage.image = [UIImage imageNamed:@"red_dot"];
    //未看的订单通知
    unreadOrderPushDotImage = [[UIImageView alloc] init];
    unreadOrderPushDotImage.frame = CGRectMake(red_dot_x, (general_cell_height - red_dot_width)/2, red_dot_width, red_dot_width);
    unreadOrderPushDotImage.image = [UIImage imageNamed:@"red_dot"];
    //未看的未付款的美发卡通知
    unreadUnPaymentHdcDotImage = [[UIImageView alloc] init];
    unreadUnPaymentHdcDotImage.frame = CGRectMake(red_dot_hdc_x, (general_cell_height - red_dot_width)/2, red_dot_width, red_dot_width);
    unreadUnPaymentHdcDotImage.image = [UIImage imageNamed:@"red_dot"];
}

#pragma mark - 列表dateSourse代理
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return general_margin;
    }
    return 0;
}


#pragma mark - 列表view代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomIconTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoNavCell"];
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [cell renderUI:[UIImage imageNamed:@"my_hdc_icon"] contentTxt:@"我的美发卡"];
            [cell.contentView addSubview:unreadUnPaymentHdcDotImage];
            
        }
        else if(indexPath.row == 1){
            [cell renderUI:[UIImage imageNamed:@"white_envelope"] contentTxt:@"我的红包"];
            
        }
        else if(indexPath.row == 2)
        {
            [cell renderUI:[UIImage imageNamed:@"clock_big_icon"] contentTxt:@"我的预约"];
            //如果有未读的订单显示提示红点
            [cell addSubview:unreadOrderPushDotImage];
            if ([[PushProcessor sharedInstance] hasUnreadOrderPush])
            {
                unreadOrderPushDotImage.hidden = NO;
            }
            else
            {
                unreadOrderPushDotImage.hidden = YES;
            }
        }
        else if (indexPath.row == 3){
        
            [cell renderUI:[UIImage imageNamed:@"my_hairstylist_icon"] contentTxt:@"我收藏的发型师"];
        }
        else if (indexPath.row == 4)
        {
            [cell renderUI:[UIImage imageNamed:@"my_fav_icon"] contentTxt:@"我收藏的发型"];
        }
    }else if (indexPath.section == 1) {
        if ([unreadUnPaymentHdcDotImage isDescendantOfView:cell.contentView]) {
            [unreadUnPaymentHdcDotImage removeFromSuperview];
        }

        [cell renderUI:[UIImage imageNamed:@"setting_icon"] contentTxt:@"设置"];
    }
    
    //设置分割线
    if (cell) {
        UIView *upSpliteLine = [[UIView alloc]init];
        for (UIView *view in cell.contentView.subviews) {
            if ([view isMemberOfClass:upSpliteLine.class]) {
                 [view removeFromSuperview];
            }
        }
        if (indexPath.row == 0) {
            upSpliteLine.frame = CGRectMake(0, 0, screen_width, splite_line_height);
        }else
        {
            upSpliteLine.frame = CGRectMake(10, 0, screen_width - 10, splite_line_height);
        }
        upSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell addSubview:upSpliteLine];
        
        if((indexPath.section == 0 && indexPath.row == 4) || (indexPath.section == 1 && indexPath.row == 0)){
            float y = general_cell_height - splite_line_height;
            UIView * downSpliteLine = [[UIView alloc]initWithFrame:CGRectMake(0, y, screen_width, splite_line_height)];
            downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            [cell.contentView addSubview:downSpliteLine];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return general_cell_height;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 1) {
        [[(UITableViewHeaderFooterView *)view contentView] setBackgroundColor:[UIColor clearColor]];
        //[[(UITableViewHeaderFooterView *)view backgroundView] setHidden:YES];
        
    }
    view.alpha = 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomIconTextCell *cell = (CustomIconTextCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    if (indexPath.section == 1) {
        [self.navigationController pushViewController:[[UserSettingController alloc]init] animated:YES];
        [MobClick event:log_event_name_goto_user_set];
    }else{
        if (indexPath.row == 0) {
            NSArray *hdcStatuses = [[NSArray alloc] initWithObjects:@(user_card_status_paid), nil];
            UserHdcController *udc = [[UserHdcController alloc] initWithCardStatus:hdcStatuses];
            [self.navigationController pushViewController:udc animated:YES];
            
            [MobClick event:log_event_name_view_my_hdcs];
        }else if (indexPath.row == 1) {
            UserRedEnvelopeController *urec = [UserRedEnvelopeController new];
            [self.navigationController pushViewController:urec animated:YES];
            [MobClick event:log_event_name_view_my_red_envelope];
        }else if (indexPath.row == 2){
            MyOrderController *myOrderController = [[MyOrderController alloc] initWithOrders:self.myOrders filteType:filte_type_all];
            [self.navigationController pushViewController:myOrderController animated:YES];
            
            [MobClick event:log_event_name_goto_my_order];
        }else if (indexPath.row == 3){
            AppStatus *as = [AppStatus sharedInstance];
            NSString *url = [UserStore getUriForUserFavStylists:as.user.idStr];
            StylistListController *slc = [[StylistListController alloc] initWithRequestUrl:url title:@"我收藏的发型师" type:my_fav_styler_type];
            [self.navigationController pushViewController:slc animated:YES];
            
            [MobClick event:log_event_name_goto_my_stylist];
        }
        else if(indexPath.row == 4)
        {
            AppStatus *as = [AppStatus sharedInstance];
            NSString *url = [StylistWorkStore getUrlForFavWorks:as.user.idStr];
            WorkListController * wlc = [[WorkListController alloc] initWithRequestURL:url title:@"我收藏的发型" type:my_fav_work];
            wlc.type = my_fav_work;
            [self.navigationController pushViewController:wlc animated:YES];
            
            [MobClick event:log_event_name_goto_my_collect_work_list];
        }
    }
}

- (IBAction)myEvaluations:(UIButton *)sender {
    if (sender.tag == 1) {
        [self.navigationController pushViewController:[[MyEvaluationsController alloc]init] animated:YES];
        [MobClick event:log_event_name_goto_my_evaluations];
    }else
    {
        MyOrderController *unevaluation = [[MyOrderController alloc] init];
        unevaluation.filteType = filte_type_unevaluation;
        [self.navigationController pushViewController:unevaluation animated:YES];
        
        [MobClick event:log_event_name_goto_unevaluation];
    }
}

- (IBAction)moreSetting:(id)sender {
    [self.navigationController pushViewController:[[MoreController alloc]init] animated:YES];
    [MobClick event:log_event_name_goto_feedback];
}

-(void)renderUI{
    AppStatus *as = [AppStatus sharedInstance];
    [self.userAvatar setImageWithURL:[NSURL URLWithString:as.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"user_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    [self.userPhoneNumber setTitle:as.user.loginMobileNo forState:UIControlStateNormal];
    self.userName.text = as.user.name;
    self.evaluationCount.text = [NSString stringWithFormat:@"%d", as.user.evaluationCount];

    self.userPhoneNumber.titleLabel.text = [AppStatus sharedInstance].user.loginMobileNo;
    [self renderUnPostStatus];
    [self renderUnPaymentStatus];
    
    [self.tableView reloadData];
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString *)getPageName{
    return page_name_user_center;
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
