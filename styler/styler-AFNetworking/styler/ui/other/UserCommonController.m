//
//  UserCommonController.m
//  styler
//
//  Created by wangwanggy820 on 14-5-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserCommonController.h"
#import "UIViewController+Custom.h"
#import "FeedbackController.h"
#import "UserStore.h"
#import "StylistStore.h"
#import "LoadingStatusView.h"
#import "StylistTableCell.h"
#import "StylistProfileController.h"
#import "PushProcessor.h"
#import "UserLoginController.h"
#import "ChatViewController.h"
#import "EaseMobProcessor.h"

#define touch_down_bg_color @"#d1d1d1"
#define kTabBarHeight       51.0f
#define stylist_cell_height 75
#define no_login            @"登录后您收藏和预约的发型师\n将会出现在这里"
#define no_stylist          @"您收藏和预约的发型师将会\n出现在这里"
@interface UserCommonController ()

@end

@implementation UserCommonController
{
    UITableView *tableView;
    BOOL hasMore;
    int loadStatus;
    int currentPageNo;
    BOOL isLoad;
    NSMutableArray *stylists;
    UIButton *reloadBtn;
    LoadingStatusView *loadingView;
    float scrollViewHeight;
    float lastOffsetY;
    int currentRow;
    UIView *line;
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
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    [self adaptive];
    [self initHeader];
    [self initScrollView];
    //预约后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStylist:) name:notification_name_user_order_stylist object: nil];
     //登录或者退出登录
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStylist:) name:notification_name_session_update object: nil];

    //收藏发型师或者移除发型师
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStylist:) name:notification_name_update_fav_stylist object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStylist:) name:@"remove_out_of_stack_stylist" object:nil];
    
    //监听会话状态更新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushDotImage) name:notification_name_session_update object:nil];
    
    //监听IM消息状态更新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushDotImage) name:notification_name_im_message_status_update object:nil];
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_common navigationController:self.navigationController];
    self.header.backBut.hidden = YES;
    [self.view addSubview:self.header];
}

-(void)initScrollView{
    CGRect frame = self.scrollView.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.height = self.view.frame.size.height - self.header.frame.size.height - kTabBarHeight;
    self.scrollView.frame = frame;
    self.scrollView.delegate = self;
    [self initWarpper];
    [self initTableView];
    AppStatus *as = [AppStatus sharedInstance];
    if (as.logined) {
        [self requestdata];
        self.reminder.hidden = YES;
    }else{
        self.reminder.hidden = NO;
        self.reminder.text = no_login;
    }
    lastOffsetY = 0;
    scrollViewHeight = self.scrollView.frame.size.height;
    self.scrollView.scrollsToTop = NO;
}

//初始化热线和在线客服
-(void)initWarpper{
    CGRect frame = self.warpper.frame;
    frame.origin.y = general_margin;
    frame.size.height = 2*self.telphone.frame.size.height;
    self.warpper.frame = frame;
    self.warpper.backgroundColor = [UIColor whiteColor];
    [self.warpper addStrokeBorderWidth:splite_line_height cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
    //400热线
    self.serviceLable.backgroundColor = [UIColor clearColor];
    self.serviceLable.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.serviceLable.font = [UIFont boldSystemFontOfSize:big_font_size];
    
    self.phoneNoLable.backgroundColor = [UIColor clearColor];
    self.phoneNoLable.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.phoneNoLable.font = [UIFont systemFontOfSize:default_font_size];
    
    //在线客服
    self.onlineServiceLable.backgroundColor = [UIColor clearColor];
    self.onlineServiceLable.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.onlineServiceLable.font = [UIFont boldSystemFontOfSize:big_font_size];
    
    self.customerServiceLable.backgroundColor = [UIColor clearColor];
    self.customerServiceLable.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.customerServiceLable.font = [UIFont systemFontOfSize:default_font_size];
    //分割线
    frame = self.spliteLine.frame;
    frame.size.height = splite_line_height;
    self.spliteLine.frame = frame;
    self.spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.telphoneBtn addTarget:self action:@selector(controlStateNormal:) forControlEvents:UIControlEventTouchUpOutside];
    [self.onlineServiceBtn addTarget:self action:@selector(controlStateNormal:) forControlEvents:UIControlEventTouchUpOutside];
    [self pushDotImage];
}

-(void)pushDotImage{
    if ([EaseMobProcessor unreadSupportMessageCount] > 0) {
        self.unreadPushDotImage.hidden = NO;
    }else{
        self.unreadPushDotImage.hidden = YES;
    }
}

-(void)controlStateNormal:(id)sender{
    self.telphone.backgroundColor = [UIColor whiteColor];
    self.onlineService.backgroundColor = [UIColor whiteColor];
}

-(void)initTableView{
    tableView = [[UITableView alloc] init];
    CGRect frame = tableView.frame;
    frame.origin.x = 0;
    frame.size.width = screen_width;
    frame.origin.y = 2*general_margin +self.warpper.frame.size.height;
    frame.size.height = tableView.contentSize.height;
    tableView.frame = frame;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[StylistTableCell class] forCellReuseIdentifier:@"StylistTableCell"];
    tableView.scrollsToTop = NO;
    [self.scrollView addSubview:tableView];
    [tableView addStrokeBorderWidth:splite_line_height cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
    hasMore = YES;
    isLoad = NO;
    currentPageNo = 1;
    stylists = [[NSMutableArray alloc] init];
    loadingView = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, general_margin, screen_width, stylist_cell_height)];
    [loadingView updateStatus:network_status_loading animating:YES];
}

-(void)requestdata{
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [UserStore getUriForUserFavStylists:as.user.idStr];
    url = [NSString stringWithFormat:@"/users/%@/stylistCollections/page?pageSize=20&orderType=2",as.user.idStr];
    reloadBtn.hidden = YES;
    tableView.hidden = NO;
    [loadingView updateStatus:network_status_loading animating:YES];
    if (!isLoad && hasMore) {
        url = [url stringByAppendingFormat:@"&pageNo=%d",currentPageNo];
        isLoad = YES;
        StylistStore *stylistStore = [StylistStore sharedStore];
        [stylistStore getStylist:^(Page *page, NSError *err) {
            isLoad = NO;
            if (err == nil) {
                currentPageNo += 1;
                [stylists addObjectsFromArray:page.items];
                if ([page isLastPage]) {
                    [loadingView updateStatus:network_status_no_more animating:NO];
                    hasMore = NO;
                }else{
                    [loadingView updateStatus:network_status_loading animating:YES];
                }
                [self updateTableView];
                
                if (stylists.count == 0) {
                    tableView.hidden = YES;
                    self.reminder.hidden = NO;
                    self.reminder.text = no_stylist;
                }
            }else//网络异常
            {
                if (currentPageNo == 1) {
                    //第一次加载失败，显示刷新按钮
                    if (!reloadBtn) {
                        reloadBtn = [[UIButton alloc] init];
                        reloadBtn.frame = CGRectMake((self.view.frame.size.width-220)/2, self.scrollView.frame.size.height/2, 220, 156);
                        [reloadBtn setImage:[UIImage imageNamed:@"network_disconnect_icon"] forState:UIControlStateNormal];
                        [reloadBtn addTarget:self action:@selector(requestdata) forControlEvents:UIControlEventTouchUpInside];
                        [self.scrollView addSubview:reloadBtn];
                    }
                    reloadBtn.hidden = NO;
                }else{
                    [loadingView updateStatus:network_request_fail animating:NO];
                }
            }
        } uriStr:url refresh:NO];
    }
}

//重新设置tableView
-(void)updateTableView{
    [tableView reloadData];
    CGRect frame = tableView.frame;
    frame.size.height = tableView.contentSize.height;
    tableView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(screen_width, frame.size.height + [self.warpper bottomY] +general_margin);
}

#pragma mark --------------dataSource-------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stylists.count +1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return stylist_cell_height;
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == stylists.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell addSubview:loadingView];
        return cell;
    }
    static NSString * cellIndentifier = @"StylistTableCell";
    StylistTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];

    Stylist *stylist = [stylists objectAtIndex:indexPath.row];
    [cell renderStylistInfo:stylist];
    
    if (stylist.dataStatus == stylist_data_status_open) {
        if (stylist.jobTitle == nil) {
            stylist.jobTitle = @"";
        }
        cell.gotoNext.hidden = NO;
        cell.scoreView.hidden = NO;
        cell.haircutPriceAndWorkNum.hidden = NO;
        cell.line.hidden = NO;
        cell.outOfStack.hidden = YES;
        cell.deleteBtn.hidden = YES;
        float alpha = 1.0;
        cell.stylistName.alpha = alpha;
        cell.stylistAvatar.alpha = alpha;
    }else{
        cell.gotoNext.hidden = YES;
        cell.scoreView.hidden = YES;
        cell.haircutPriceAndWorkNum.hidden = YES;
        cell.line.hidden = YES;
        cell.workCount.hidden = YES;
        cell.outOfStack.hidden = NO;
        cell.deleteBtn.hidden = NO;
        
        currentRow = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        float alpha = 0.6;
        cell.stylistName.alpha = alpha;
        cell.stylistAvatar.alpha = alpha;
    }
    CGRect separatorFrame =  cell.grayLine.frame;
    if (indexPath.row == (stylists.count-1)) {
        separatorFrame.origin.x = 0;
    }
    else
    {
        separatorFrame.origin.x = 10;
    }
    cell.grayLine.frame = separatorFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//删除下架发型师
-(void)deleteBtnClick{

    Stylist *stylist = [stylists objectAtIndex:currentRow];
    AppStatus *appStatus = [AppStatus sharedInstance];
    [[UserStore sharedStore] removeFavstylist:^(NSError *err){
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功" duration:1.0];
            [appStatus.user removeFavStylist:stylist.id];
            [stylists removeObjectAtIndex:currentRow];
            [tableView setEditing: NO animated: YES ];
            [tableView reloadData];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @(stylist.id), @"发型师id", nil];
            [MobClick event:log_event_name_remove_fav_stylist attributes:dict];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"删除失败" duration:1.0];
        }
    }userId:[appStatus.user.idStr intValue] stylistId:stylist.id];
}
/*
//左滑删除下架发型师
-(void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Stylist *stylist = [stylists objectAtIndex:indexPath.row];
        AppStatus *appStatus = [AppStatus sharedInstance];
        [[UserStore sharedStore] removeFavstylist:^(NSError *err){
            if (err == nil) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功" duration:1.0];
                [appStatus.user removeFavStylist:stylist.id];
                [stylists removeObjectAtIndex:indexPath.row];
                [tableView setEditing: NO animated: YES ];
                [tableView reloadData];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @(stylist.id), @"发型师id", nil];
                [MobClick event:log_event_name_remove_fav_stylist attributes:dict];
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"删除失败" duration:1.0];
            }
        }userId:[appStatus.user.idStr intValue] stylistId:stylist.id];
    }
}
 */

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == stylists.count) {
//        return UITableViewCellEditingStyleNone;
//    }
//    Stylist *stylist = [stylists objectAtIndex:indexPath.row];
//    if (stylist.dataStatus == stylist_data_status_out_of_stack ){
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//}

#pragma mark -----delegate-  --
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != stylists.count) {
        Stylist * stylist = [stylists objectAtIndex:[indexPath row]];
        if (stylist.dataStatus != stylist_data_status_open) {
            [SVProgressHUD showWithStatus:@"此发型师已下架，请点击删除此发型师" maskType:SVProgressHUDMaskTypeNone duration:2];
            return ;
        }
        StylistProfileController *stylistProfileController = [[StylistProfileController alloc]init];
        stylistProfileController.stylist = stylist;
        [self.navigationController pushViewController:stylistProfileController animated:YES];
        
        [MobClick event:log_event_name_goto_stylist_profile attributes:[NSDictionary dictionaryWithObjectsAndKeys:stylist.name, @"发型师名字",nil]];
    }else{
        [self requestdata];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == stylists.count && !hasMore) {
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - stylist_cell_height){
        if (hasMore && !isLoad) {
            [self requestdata];
        }
    }
    self.onlineService.backgroundColor = [UIColor whiteColor];
    self.telphone.backgroundColor = [UIColor whiteColor];
    
    [self driveScrollView:scrollView lastOffsetY:lastOffsetY scrollViewHeight:scrollViewHeight topView:self.header];
    lastOffsetY = scrollView.contentOffset.y;
}

-(void)driveScrollView:(UIScrollView *)scrollView lastOffsetY:(float)_lastOffsetY scrollViewHeight:(float)_scrollViewHeight topView:(UIView *)view{
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) && scrollView.contentSize.height > (view.frame.size.height + _scrollViewHeight + general_margin)) {
        if (_lastOffsetY - scrollView.contentOffset.y > 0  && _lastOffsetY < (scrollView.contentSize.height - scrollView.frame.size.height)) {//下拉
            if (view.frame.origin.y != 0) {
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


-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

-(void)updateStylist:(NSNotification *) info{
    AppStatus *as = [AppStatus sharedInstance];
    if (as.logined) {
        hasMore = YES;
        currentPageNo = 1;
        [stylists removeAllObjects];
        [self requestdata];
        tableView.hidden = NO;
        self.reminder.hidden = YES;

    }else{
        tableView.hidden = YES;
        self.reminder.hidden = NO;
        self.reminder.text = no_login;
        self.scrollView.contentSize = CGSizeMake(screen_width, [self.warpper bottomY] + general_margin);
    }
    self.header.frame = CGRectMake(0, 0, screen_width, self.header.frame.size.height);
    self.scrollView.frame = CGRectMake(0, self.header.frame.size.height, screen_width,scrollViewHeight);
}

-(void)initReminder{
    int height = self.view.frame.size.height - [self.warpper bottomY] - general_margin - kTabBarHeight;
    CGRect frame = self.reminder.frame;
    frame.origin.y = [self.warpper bottomY] + height/3;
    frame.origin.x = (screen_width - frame.size.width)/2;
    self.reminder.frame = frame;
    self.reminder.backgroundColor = [UIColor clearColor];
    self.reminder.font = [UIFont systemFontOfSize:default_font_size];
    self.reminder.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
}

-(NSString *)getPageName{
    return page_name_common;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUpInside:(UIButton *)sender {
    if (sender.tag == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"400-156-1618" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        self.telphone.backgroundColor = [UIColor whiteColor];
        self.onlineService.backgroundColor = [UIColor whiteColor];
        
        [MobClick event:log_event_name_phone_service];
    }else if (sender.tag == 2){
        self.onlineService.backgroundColor = [UIColor whiteColor];
        self.telphone.backgroundColor = [UIColor whiteColor];
        if (![AppStatus sharedInstance].logined) {
            UserLoginController *ulc = [[UserLoginController alloc] initWithFrom:account_session_from_feedback];
            [self.navigationController pushViewController:ulc animated:YES];
            return;
        }
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:@"support"];
        chatVC.title = page_name_feedback;
        [self.navigationController pushViewController:chatVC animated:YES];
        [MobClick event:log_event_name_goto_feedback];
    }
}

- (IBAction)touchDown:(UIButton *)sender {
    if (sender.tag == 1) {
        self.telphone.backgroundColor = [ColorUtils colorWithHexString:touch_down_bg_color];
    }else if (sender.tag == 2){
        self.onlineService.backgroundColor = [ColorUtils colorWithHexString:touch_down_bg_color];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4001561618"]]];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
