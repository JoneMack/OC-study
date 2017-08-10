//
//  OrderDetailInfoController.m
//  styler
//
//  Created by System Administrator on 14-4-7.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UIView+Custom.h"
#import "OrderDetailInfoController.h"
#import "User.h"
#import "OrderNavigationBar.h"
#import "SpecialEvent.h"
#import "CommonItemTxt.h"
#import "StylistProfileController.h"
#import "OrderServiceItemsController.h"
#import "OrganizationMapController.h"
#import "AppDelegate.h"
#import "StylerTabbar.h"
#import "WebContainerController.h"
#import "OrderStore.h"
#import "PushProcessor.h"
#import "PostEvaluationController.h"
#import "UIViewController+Custom.h"
#import "DateUtils.h"
#import "UILabel+Custom.h"
#import "StylistStore.h"

#define out_of_stack_x      270
#define out_of_stack_y      9
#define out_of_stack_width  42
#define out_of_stack_height 21
#define image_width    23
#define image_x        83
#define image_y        20
@interface OrderDetailInfoController ()

@end

@implementation OrderDetailInfoController
@synthesize outOfStack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrder:(ServiceOrder *)order orderUIStatus:(int)orderUIStatus{
    self = [super init];
    self.order = order;
    self.orderUIStatus = orderUIStatus;
    return self;
}


//title.text = @"备注事件";
//content.text = self.order.specialRemark;
//break;
//case 1:
//title.text = @"机构名称";
//content.text = self.order.stylist.organization.name;
//break;
//case 2:
//title.text = @"机构地址";
//content.text = self.order.stylist.organization.address;
//break;
//case 3:
//title.text = @"机构电话";
//content.text = self.order.stylist.organization.phoneNo;

-(id)initWithOrderId:(int)orderId{
    self = [super init];
    self.orderId = orderId;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self adaptive];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (self.orderUIStatus != order_ui_status_success_first) {
        [self setRightSwipeGestureAndAdaptive];
    }
    if (self.order == nil) {
        [self.mainContent setHidden:YES];
        [self.bottomView setHidden:YES];
        [SVProgressHUD showWithStatus:network_status_loading maskType:SVProgressHUDMaskTypeGradient];
        OrderStore *orderStore = [OrderStore sharedStore];
        [orderStore getMyOrder:^(ServiceOrder *order, NSError *err) {
            self.order = order;
            [self updateOrderUIStatus];
            [[StylistStore sharedStore] getStylist:^(Stylist *stylist, NSError *err) {
                self.order.stylist = stylist;
                
                [self.mainContent setHidden:NO];
                [self.bottomView setHidden:NO];
                [self initUI];
                
                [SVProgressHUD dismiss];
                [[PushProcessor sharedInstance] checkUnreadOrderPush];
            } stylistId:self.order.stylistId refresh:YES];
        } orderId:self.orderId];
    }else{
        [SVProgressHUD showWithStatus:network_status_loading maskType:SVProgressHUDMaskTypeGradient];
        [[StylistStore sharedStore] getStylist:^(Stylist *stylist, NSError *err) {
            self.order.stylist = stylist;
            [self initUI];
            
            [SVProgressHUD dismiss];
            [[PushProcessor sharedInstance] checkUnreadOrderPush];
        } stylistId:self.order.stylistId refresh:YES];
    }
}

-(void)orderStatusChanged
{
    [SVProgressHUD showWithStatus:@"正在更新数据..." maskType:SVProgressHUDMaskTypeGradient];
    OrderStore *orderStore = [OrderStore sharedStore];
    [orderStore getMyOrder:^(ServiceOrder *order, NSError *err) {
        self.order = order;
        [self updateOrderUIStatus];
        [self initUI];
//        self.bottomView.hidden = YES;
        
        [[PushProcessor sharedInstance] checkUnreadOrderPush];
        [SVProgressHUD dismiss];
    } orderId:self.order.id];
}

-(void)initUI{
    [self initView];
    [self initHeader];
//    [self initOrderNavigationBar];
    [self initBottomView];
    [self initMainContent];
}

-(void)initView
{
    if (self.orderUIStatus != order_ui_status_success_first) {
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBack)];
        [right setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:right];
    }
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_order_detail_info navigationController:self.navigationController];
    [self.view addSubview:self.header];
    if (self.orderUIStatus == order_ui_status_success_first) {
        self.header.backBut.hidden = YES;
    }else{
        self.header.backBut.hidden = NO;
    }
}

#pragma mark -----渲染头部下面的bar
-(void)initOrderNavigationBar{
    if (self.orderBar != nil) {
        [self.orderBar removeFromSuperview];
        self.orderBar = nil;
    }
    
    CGRect frame;
    int currentIndex = 3;
    
    if (self.orderUIStatus != order_ui_status_canceled) {
        frame =  CGRectMake(0, self.header.frame.size.height + splite_line_height, screen_width, order_navigation_bar_height);
    }else if(self.orderUIStatus == order_ui_status_canceled){
        frame = CGRectMake(0, self.header.frame.size.height + splite_line_height, screen_width, 0);
    }
    
    if (self.orderUIStatus == order_ui_status_canceled) {
        //占位
    }else if(self.orderUIStatus == order_ui_status_complete_evaluation || self.orderUIStatus == order_ui_status_wait_evaluation){
        currentIndex = 3;
    }else if(self.orderUIStatus == order_ui_status_success_first || self.orderUIStatus == order_ui_status_success_second){
        currentIndex = 2;
    }
    
    self.orderBar = [[OrderNavigationBar alloc] initWithFrame:frame currentIndex:currentIndex];
    [self.view addSubview:self.orderBar];
}

-(void) initMainContent
{
    //初始化maincontent布局的坐标
    self.mainContent.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    CGRect frame = self.mainContent.frame;
    frame.origin.y = [self.header bottomY];
    int height = self.view.frame.size.height - frame.origin.y - self.bottomView.frame.size.height;

    frame.size.height = height;
    self.mainContent.frame = frame;
    //依次初始化maincontent的子视图
    [self initStatusAndNoView];
    [self initOrderSuccessNavView];
    [self initUserInfoView];
    [self initScheduleTimeView];
    [self initStylistAndServiceItemView];
    [self initOrderAmountView];
    [self initRemarkAndOrgInfoTableView];
    [self initOrderServiceDescriptionView];
    [self initSafeguardBtn];

    
    //初始化maincontent布局的尺寸
    CGSize size = self.mainContent.contentSize;
    size.height = [self.safeguardBtn bottomY]-self.safeguardBtn.frame.size.height;
    self.mainContent.contentSize = size;
}

-(void) initStatusAndNoView{
    CGRect frame = self.statusAndNoView.frame;
    frame.origin.y = 0;
    self.statusAndNoView.frame = frame;
    
    [self.orderStatus setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
    [self.orderStatus.titleLabel setFont:[UIFont boldSystemFontOfSize:biggest_font_size]];
    [self.orderStatus setTitle:[self.order statusTxt] forState:UIControlStateNormal];
    
    self.orderNo.text = [NSString stringWithFormat:@"订单号 %@", self.order.orderNumber];
    [self.orderNo setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.orderNo setFont:[UIFont systemFontOfSize:default_font_size]];

    if (self.orderUIStatus == order_ui_status_success_first) {
        UIImageView *orderSuccessImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_success_icon"]];
        orderSuccessImage.frame = CGRectMake(image_x, image_y, image_width, image_width);
        [self.statusAndNoView addSubview:orderSuccessImage];
    }
}

-(void) initOrderSuccessNavView{
    CGRect frame = self.orderSuccessNavView.frame;
    if (self.orderUIStatus != order_ui_status_success_first) {
        frame.size.height = 0;
    }
    frame.origin.y = [self.statusAndNoView bottomY];
    self.orderSuccessNavView.frame = frame;
    
    [self addBorder:self.orderSuccessNavView];
    
    [self.goBackStylistProfileBtn setTitle:@"购买超值美发卡" forState:UIControlStateNormal];
    [self.goBackStylistProfileBtn.titleLabel setFont:[UIFont systemFontOfSize:big_font_size]];
    [self.goBackStylistProfileBtn setTitleColor:[ColorUtils colorWithHexString:red_color] forState:UIControlStateNormal];
    [self addBorder:self.goBackStylistProfileBtn];
    
    [self.goMyOrderBtn setTitle:@"查看预约" forState:UIControlStateNormal];
    [self.goMyOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:big_font_size]];
    [self.goMyOrderBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
}
//购买超值美发卡
- (IBAction)goHome:(id)sender {

    
    if(self.navigationController.viewControllers.count >= 3 && [self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] isKindOfClass:[StylistProfileController class]]){
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
    }
    else {
        StylistProfileController *spc = [[StylistProfileController alloc] initWithStylistId:self.order.stylist.id];
        [self.navigationController pushViewController:spc animated:YES];
    }
    [MobClick event:log_event_name_goback_stylist_profile attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name, @"发型师名字",nil]];
}
//查看预约
- (IBAction)goMyOrder:(id)sender {
    StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
    
    //将当前的视图堆栈pop到根视图
    if ([tabBar getSelectedIndex] != tabbar_item_index_me) {
        UINavigationController *navController = [tabBar getSelectedViewController];
        [navController popToRootViewControllerAnimated:YES];
    }
    
    //切换视图堆栈到“个人中心”
    [tabBar setSelectedIndex:tabbar_item_index_me];
    UINavigationController *navController = [tabBar getSelectedViewController];
    [navController popToRootViewControllerAnimated:YES];
    
    [MobClick event:log_event_name_goback_myself_center attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name, @"发型师名字",nil]];
}

-(void) initUserInfoView
{
    CGRect frame = self.userInfoView.frame;
    frame.origin.y = [self.orderSuccessNavView bottomY] + general_margin;
    self.userInfoView.frame = frame;
    [self addBorder:self.userInfoView];
    
    User *user = [AppStatus sharedInstance].user;
    
    //初始化用户名
    self.userName.text = [NSString stringWithFormat:@"顾客 %@", user.name];
    [self.userName setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.userName setFont:[UIFont systemFontOfSize:default_font_size]];
    
    //初始化性别
    [self.userGender setText:[NSString stringWithFormat:@"性别 %@", [user genderTxt]]];
    [self.userGender setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.userGender setFont:[UIFont systemFontOfSize:default_font_size]];
    [self addBorder:self.userGender];

    //初始化手机号码
    NSString *mobileNoTxt = [NSString stringWithFormat:@"%@****%@", [user.loginMobileNo substringWithRange:NSMakeRange(0, 3)], [user.loginMobileNo substringWithRange:NSMakeRange(7, 4)]];
    [self.userMobileNo setText:[NSString stringWithFormat:@"手机 %@", mobileNoTxt]];
    [self.userMobileNo setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.userMobileNo setFont:[UIFont systemFontOfSize:default_font_size]];
}

-(void) initScheduleTimeView
{
    CGRect frame = self.scheduleTimeView.frame;
    frame.origin.y = [self.userInfoView bottomY] + general_margin;
    self.scheduleTimeView.frame = frame;
    
    [self addBorder:self.scheduleTimeView];
    NSString *timeTxt = [DateUtils stringFromDate:[self.order getScheduleTime]];
    self.scheduleTimeLabel.text = [NSString stringWithFormat:@"预约时间         %@", timeTxt];
    [self.scheduleTimeLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.scheduleTimeLabel setFont:[UIFont systemFontOfSize:big_font_size]];
}

-(void) initStylistAndServiceItemView
{
    CGRect frame = self.stylistAndServiceItemView.frame;
    frame.origin.y = [self.scheduleTimeView bottomY] + general_margin;
    self.stylistAndServiceItemView.frame = frame;
    
    [self addBorder:self.stylistAndServiceItemView];
    
    self.stylistNameLabel.text = [NSString stringWithFormat:@"发型师 %@", self.order.stylist.nickName];
    [self.stylistNameLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.stylistNameLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    [self.stylistNameLabel setUserInteractionEnabled:YES];
    
    if (self.order.stylist.dataStatus == stylist_data_status_out_of_stack) {
        self.gotoNextImageView.hidden = YES;
        self.stylistNameLabel.alpha = 0.6;
        //设置下架状态
        outOfStack.frame = CGRectMake(out_of_stack_x, out_of_stack_y, out_of_stack_width, out_of_stack_height);
        outOfStack.text = @"下架";
        outOfStack.font = [UIFont systemFontOfSize:big_font_size];
        outOfStack.textColor = [ColorUtils colorWithHexString:white_text_color];
        outOfStack.backgroundColor = [ColorUtils colorWithHexString:gray_text_color];
        outOfStack.textAlignment = NSTextAlignmentCenter;
        [outOfStack addStrokeBorderWidth:0.5 cornerRadius:2 color:[ColorUtils colorWithHexString:gray_text_color]];
        outOfStack.alpha = 0.8;
        outOfStack.hidden = NO;
    }else{
        outOfStack.hidden = YES;
        UITapGestureRecognizer *tapStylistName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewStylist:)];
        [self.stylistNameLabel addGestureRecognizer:tapStylistName];
    }
    self.stylistAndServiceItemSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    frame = self.stylistAndServiceItemSpliteLine.frame;
    frame.size.height = 0.5;
    self.stylistAndServiceItemSpliteLine.frame = frame;
    
    self.orderName.text = [NSString stringWithFormat:@"预约项目 %@", self.order.orderTitle];
    [self.orderName setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    [self.orderName setFont:[UIFont boldSystemFontOfSize:big_font_size]];
    [self.orderName setUserInteractionEnabled:YES];
    
//    UITapGestureRecognizer *tapOrderName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewOrderServiceItems:)];
//    [self.orderName addGestureRecognizer:tapOrderName];
}

-(void) viewStylist:(id)sender{
    StylistProfileController *spc = [[StylistProfileController alloc] init];
    spc.stylist = self.order.stylist;
    [self.navigationController pushViewController:spc animated:YES];
    
    [MobClick event:log_event_name_goto_stylist_profile attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylistName, @"发型师名字",nil]];
}

//-(void) viewOrderServiceItems:(id)sender{
//    OrderServiceItemsController *osic = [[OrderServiceItemsController alloc] initWithOrder:self.order];
//    [self.navigationController pushViewController:osic animated:YES];
//}

-(void) initOrderAmountView
{
        self.orderAmountView.hidden = YES;
}

-(void) viewServiceCare:(id)sender{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppStatus sharedInstance].webPageUrl, @"/app/serviceCare"];
    WebContainerController *wcc = [[WebContainerController alloc] initWithUrl:url title:@"时尚猫 美丽无忧"];
    [self.navigationController pushViewController:wcc animated:YES];
}

-(void) initRemarkAndOrgInfoTableView
{
    CGRect frame = self.remarkAndOrgInfoTableView.frame;
    frame.origin.y = [self.stylistAndServiceItemView bottomY] + general_margin;
    self.remarkAndOrgInfoTableView.frame = frame;

    [self addBorder:self.remarkAndOrgInfoTableView];
    self.remarkAndOrgInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.remarkAndOrgInfoTableView.dataSource = self;
    self.remarkAndOrgInfoTableView.delegate = self;
    
   
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 4;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getRemarkAndOrginfoTableCellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(general_padding, 0, 70, [self getRemarkAndOrginfoTableCellHeight])];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake([title rightX], 0, screen_width-[title rightX]-3*general_padding, self.remarkAndOrgInfoTableView.frame.size.height/4)];
    content.numberOfLines = 0;
    switch (indexPath.row) {
        case 0:
            title.text = @"预约留言";
            content.text = self.order.orderMessage;
            break;
        case 1:
            title.text = @"机构名称";
            content.text = self.order.organizationName;
            break;
        case 2:
            title.text = @"机构地址";
            content.text = self.order.organizationAddress;
            break;
        case 3:
            title.text = @"机构电话";
            content.text = self.order.organizationPhone;
            break;
        default:
            break;
    }
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        arrow.frame = CGRectMake(screen_width-3*general_padding, ([self getRemarkAndOrginfoTableCellHeight]-25)/2, 25, 25);
        [cell.contentView addSubview:arrow];
    }
    title.textColor = [ColorUtils colorWithHexString:black_text_color];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:default_font_size];
    
    content.textColor = [ColorUtils colorWithHexString:black_text_color];
    content.backgroundColor = [UIColor clearColor];
    content.font = [UIFont systemFontOfSize:default_font_size];
    
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:content];
    
    if (indexPath.row < 3) {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(general_padding, [self getRemarkAndOrginfoTableCellHeight]-splite_line_height, screen_width-general_padding, splite_line_height)];
        separator.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell.contentView addSubview:separator];
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<2) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if (indexPath.row == 2) {
        if (self.order.stylist.organization.address && ![self.order.stylist.organization.address isEqual:@""]) {
            OrganizationMapController *omc = [[OrganizationMapController alloc]initWithOrganization:self.order.stylist.organization];
            [self.navigationController pushViewController:omc animated:YES];
            
            [MobClick event:log_event_name_view_org_map attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name, @"发型师名字",nil]];
        }
    }else if(indexPath.row == 3){
        if (self.order.stylist.organization.phoneNo && ![self.order.stylist.organization.phoneNo isEqual:@""]) {
            [MobClick event:log_event_name_call_org_phone attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name, @"发型师名字",nil]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.order.stylist.organization.phoneNo message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 10000+1;
            [alert show];
        }
    }
}

-(float)getRemarkAndOrginfoTableCellHeight{
    return self.remarkAndOrgInfoTableView.frame.size.height/4;
}

-(void)initOrderServiceDescriptionView
{
    NSString *content = order_reminder;
    
    CommonItemTxt *item1 = [[CommonItemTxt alloc]init:1 title:@"温馨提示" content:content];
    if (self.orderUIStatus == order_ui_status_success_first) {
        content = order_illustrate;
    }else if (self.orderUIStatus == order_ui_status_success_second || self.orderUIStatus == order_ui_status_canceled || self.orderUIStatus == order_ui_status_wait_evaluation || self.orderUIStatus == order_ui_status_complete_evaluation ){
        content = order_detail_illustrate;
    }
    
    UIFont *font = [UIFont systemFontOfSize:default_2_font_size];
    CommonItemTxt *item2 = [[CommonItemTxt alloc]init:1 title:@"预约说明" content:content];
    NSArray *array = [NSArray arrayWithObjects:item1, item2, nil];

    float height = [CommonItemTxtView judgeHeight:array font:font]+general_cell_height+general_cell_height;
    float y = [self.remarkAndOrgInfoTableView bottomY];
    CGRect frame = CGRectMake(0, y, screen_width - general_padding, height);
    
    self.orderServiceDescriptionView = [[CommonItemTxtView alloc] initWithFrame:frame
                                        commonItemTxtArray:array
                                                      font:font];
    frame.origin.x = general_padding;
    self.orderServiceDescriptionView.frame = frame;
    [self.mainContent addSubview:self.orderServiceDescriptionView];
}

-(void)initSafeguardBtn{
    CGRect frame = self.safeguardBtn.frame;
    if (self.orderUIStatus == order_ui_status_canceled
        || self.orderUIStatus == order_ui_status_complete_evaluation) {
        frame.size.height = 0;
    }else{
        frame.size.height = order_safeguard_btn_height;
    }
    frame.origin.y = [self.orderServiceDescriptionView bottomY];
    if(self.orderUIStatus == order_ui_status_success_first
       || self.orderUIStatus == order_ui_status_success_second
       || self.orderUIStatus == order_ui_status_wait_evaluation ){
    
        self.safeguardBtn.hidden = YES;
    
    }
    
    self.safeguardBtn.frame = frame;
    [self.safeguardBtn.titleLabel setFont:[UIFont systemFontOfSize:bigger_font_size]];
    [self.safeguardBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateNormal];
    [self.safeguardBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

-(void) initBottomView
{
    CGRect frame = self.bottomView.frame;
    if (self.orderUIStatus == order_ui_status_wait_evaluation) {
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        [self.operationBtn setTitle:@"发表评价" forState:UIControlStateNormal];
        
        [self.operationBtn addTarget:self action:@selector(goPostEvaluation) forControlEvents:UIControlEventTouchUpInside];
    }else if(self.orderUIStatus == order_ui_status_success_first
             || self.orderUIStatus == order_ui_status_success_second){
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        [self.operationBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        [self.operationBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    }else if(self.orderUIStatus == order_ui_status_canceled){
        self.orderServiceDescriptionView.hidden = YES;
        frame.size.height = 0;
    }else{
        frame.size.height = 0;
    }
    self.bottomView.frame = frame;
    [self.operationBtn setBackgroundColor:[ColorUtils colorWithHexString:red_default_color]];
    [self.operationBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:big_font_size]];
    [self.operationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

-(void) goPostEvaluation{
    PostEvaluationController *pec = [[PostEvaluationController alloc] initWithOrder:self.order];
    [self.navigationController pushViewController:pec animated:YES];
    
    [MobClick event:log_event_name_goto_sender_evaluation_page attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name, @"发型师名字",nil]];
}

-(void) cancelOrder{
    [MobClick event:log_event_name_call_org_phone attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.order.stylist.name, @"发型师名字",nil]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"400-156-1618" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10000+2;
    [alert show];
}

#pragma mark -----UIAlertViewDelegate------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ((alertView.tag - 10000) == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.order.stylist.organization.phoneNo]]];
        }else if((alertView.tag - 10000) == 2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4001561618"]]];
        }
    }
}

-(void) addBorder:(UIView *)view{
    CALayer *layer = view.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0];
    [layer setBorderWidth:0.5f];
    [layer setBorderColor:[ColorUtils colorWithHexString:splite_line_color].CGColor];
}

-(void) updateOrderUIStatus{
    if (self.order.orderStatus == order_status_completed
        && self.order.evaluationStatus == evaluation_status_post) {
        self.orderUIStatus = order_ui_status_complete_evaluation;
    }else if(self.order.orderStatus == order_status_completed
             && self.order.evaluationStatus == evaluation_status_unpost){
        self.orderUIStatus = order_ui_status_wait_evaluation;
    }else if(self.order.orderStatus == order_status_confirmed
             || self.order.orderStatus == order_status_waiting_confirm){
        self.orderUIStatus = order_ui_status_success_second;
    }else if(self.order.orderStatus == order_status_canceled){
        self.orderUIStatus = order_ui_status_canceled;
    }
}


-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_order_detail_info;
}

@end
