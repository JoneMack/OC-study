//
//  SelectOrderTimeController.m
//  styler
//
//  Created by wangwanggy820 on 14-4-7.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ChooseOrderTimeController.h"
#import "UIView+Custom.h"
#import "CommonItemTxtView.h"
#import "CommonItemTxt.h"
#import "SpecialEvent.h"
#import "NewServiceOrder.h"
#import "OrderStore.h"
#import "StylerException.h"
#import "OrderDetailInfoController.h"
#import "UIView+Custom.h"
#import "OrderedHour.h"
#import "UserStore.h"
#import "UIViewController+Custom.h"
#import "StylistStore.h"

#define name_width  130
#define sex_width   60
@interface ChooseOrderTimeController ()

@end

@implementation ChooseOrderTimeController
{
    CommonItemTxtView *itemTxtView;
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
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
}
//初始化整个View
-(void)initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];

    [self initHeader];
    [self inittarBar];
    [self initConfirmBtn];
    [self initScrollView];
    [self initMaskView];
}

#pragma mark -------初始化头部---
-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_choose_order_time navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

#pragma mark ----初始化头部下边的tarbbar
-(void)inittarBar{
    CGRect frame =  CGRectMake(0,self.header.frame.size.height + splite_line_height, screen_width, order_navigation_bar_height);
    self.navBar = [[OrderNavigationBar alloc] initWithFrame:frame currentIndex:1];
    [self.view addSubview:self.navBar];
}

-(void)initScrollView{
    self.scrollView.backgroundColor = [UIColor clearColor];
    float orderNavBarHeight = [self.navBar bottomY];
    float height = self.view.frame.size.height - tabbar_height - orderNavBarHeight - general_padding;
    self.scrollView.frame = CGRectMake(0, self.header.frame.size.height, screen_width, height);

    [self initUserInfoTableView];
    [self initScheduleTimeView];
    [self initSpecialRemarkView];
    [self initOrderServiceDescription];
  
    float contentHeight  =  general_margin
                            + self.userInfoTableView.frame.size.height
                            + general_margin
                            + self.scheduleTimeView.frame.size.height
                            + self.specialRemarkView.frame.size.height
                            + itemTxtView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(screen_width, contentHeight);
}

#pragma mark ----初始化userInfoTableView
-(void)initUserInfoTableView{
    CGRect frame = self.userInfoTableView.frame;
    frame.origin.y = general_margin;
    self.userInfoTableView.frame = frame;
    self.userInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.userInfoTableView.layer.masksToBounds = YES;
    self.userInfoTableView.layer.borderColor = [[ColorUtils colorWithHexString:splite_line_color] CGColor];
    self.userInfoTableView.layer.borderWidth = splite_line_height;
    self.userInfoTableView.scrollEnabled = NO;
    self.userInfoTableView.dataSource = self;
    self.userInfoTableView.delegate = self;
}
#pragma mark -------dataSource---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.userInfoTableView.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    AppStatus *as = [AppStatus sharedInstance];
    //设置名字
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(2*general_padding, 0, name_width - 2*general_padding, self.userInfoTableView.frame.size.height)];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont systemFontOfSize:default_font_size];
    name.textColor = [ColorUtils colorWithHexString:black_text_color];
    name.text = [NSString stringWithFormat:@"顾客 %@", as.user.name];
    [cell addSubview:name];
    
    //设置性别
    UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake([name rightX], 0, sex_width, self.userInfoTableView.frame.size.height)];
    sex.backgroundColor = [UIColor clearColor];
    sex.font = [UIFont systemFontOfSize:default_font_size];
    sex.textColor = [ColorUtils colorWithHexString:black_text_color];
    NSString *gender = (as.user.gender == 0)?@"女":@"男";
    sex.text = [NSString stringWithFormat:@"性别 %@", gender];
    sex.textAlignment = NSTextAlignmentCenter;
    [sex addStrokeBorderWidth:splite_line_height cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
    [cell addSubview:sex];

    //设置手机号
    UILabel *mobile = [[UILabel alloc] initWithFrame:CGRectMake([sex rightX], 0, name_width, self.userInfoTableView.frame.size.height)];
    mobile.backgroundColor = [UIColor clearColor];
    mobile.font = [UIFont systemFontOfSize:default_font_size];
    mobile.textAlignment = NSTextAlignmentCenter;
    mobile.textColor = [ColorUtils colorWithHexString:black_text_color];
    //NSString *mobileNoTxt = [NSString stringWithFormat:@"%@****%@", [as.user.loginMobileNo substringWithRange:NSMakeRange(0, 3)], [as.user.loginMobileNo substringWithRange:NSMakeRange(7, 4)]];
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:as.user.loginMobileNo];
    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    mobile.text = [NSString stringWithFormat:@"手机 %@", str];
    [cell addSubview:mobile];
    
    return cell;
}

//点击后没效果
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark ---初始化scheduleTimeView
-(void)initScheduleTimeView
{
    //设置整个时间view
    CGRect frame = self.scheduleTimeView.frame;
    frame.origin.y = [self.userInfoTableView bottomY] + general_margin;
    self.scheduleTimeView.frame = frame;
    self.scheduleTimeView.userInteractionEnabled = YES;
    self.scheduleTimeView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    [self.chooseTime setText:@"     时间        请选择到店时间"];
    [self.chooseTime setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    self.chooseTime.layer.masksToBounds = YES;
    self.chooseTime.layer.borderWidth = splite_line_height;
    self.chooseTime.layer.borderColor = [[ColorUtils colorWithHexString:splite_line_color] CGColor];
    self.chooseTime.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentChooseTimeModalView:)];
    [self.scheduleTimeView addGestureRecognizer:tap];
    
    self.orderDescription.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.orderDescription.font = [UIFont systemFontOfSize:small_font_size];
    self.orderDescription.backgroundColor = [UIColor clearColor];
    self.orderDescription.text = @"预约时间前一个小时可以取消预约或更改预约时间";

    frame = self.orderDescription.frame;
    frame.origin.y = bottomY(self.chooseTime) + splite_line_height;
    self.orderDescription.frame = frame;
    
    [self initChooseScheduleTimePicker];
}

#pragma mark ----------ScheduleTimePicker -----
-(void)initChooseScheduleTimePicker
{
    self.daysCanOrder = [self.stylist daysCanDate];
    self.hoursCanOrder = [self.stylist hoursCanDate:(NSDate*)self.daysCanOrder[0]];
    [[OrderStore sharedStore] getOrderedHours:^(NSArray *orderedHours, NSError *err) {
        if (err == nil) {
            self.orderedHours = orderedHours;
            self.hoursCanOrder = [self filteHoursCanOrder:self.hoursCanOrder dayDate:self.daysCanOrder[0]];
        }
    } stylistId:self.stylist.id];
    
    self.scheduleTimePicker.dataSource = self;
    self.scheduleTimePicker.delegate = self;
    
    self.scheduleTimePicker.showsSelectionIndicator = YES;
    self.scheduleTimePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

-(NSArray *)filteHoursCanOrder:(NSArray *)hoursCanOrder dayDate:(NSDate *)dayDate{
    if (self.orderedHours == nil) {
        return hoursCanOrder;
    }
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < hoursCanOrder.count; i++) {
        int hourCanOrder = [hoursCanOrder[i] intValue];
        BOOL hasOrdered = NO;
        for (OrderedHour *orderedHour in self.orderedHours) {
            if ([orderedHour compareDayAndHour:dayDate hour:hourCanOrder] && orderedHour.orderCount>=2) {
                hasOrdered = YES;
                break;
            }
        }
        if (!hasOrdered) {
            [result addObject:hoursCanOrder[i]];
        }
    }
    return result;
}

-(void)presentChooseTimeModalView:(id)sender{
    [self.view addSubview:self.maskView];
    
    CGRect frame = self.chooseTimeModalView.frame;
    frame.origin.y = self.view.frame.size.height;
    self.chooseTimeModalView.frame = frame;
    [self.view addSubview:self.chooseTimeModalView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.chooseTimeModalView.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.chooseTimeModalView.frame = frame;
    }];
}

- (IBAction)cancelChooseTime:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.chooseTimeModalView.frame;
        frame.origin.y = self.view.frame.size.height;
        self.chooseTimeModalView.frame = frame;
    } completion:^(BOOL finished) {
        [self.chooseTimeModalView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

- (IBAction)confirmChooseTime:(id)sender {
    int selectedRow = [self.scheduleTimePicker selectedRowInComponent:0];
    NSDate *date = self.daysCanOrder[selectedRow];
    selectedRow = [self.scheduleTimePicker selectedRowInComponent:1];
    int hour = [self.hoursCanOrder[selectedRow] intValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit|NSHourCalendarUnit) fromDate:date];
    comps.hour = hour;
    self.scheduleDate = [calendar dateFromComponents:comps];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年M月dd日 H点 EEE"];
    self.chooseTime.text=[NSString stringWithFormat:@"     时间        %@", [dateFormatter stringFromDate:self.scheduleDate]];
    [self cancelChooseTime:sender];
}


#pragma mark --- 初始化备注事件
-(void)initSpecialRemarkView{
    CGRect frame = self.specialRemarkView.frame;
    frame.origin.y = [self.scheduleTimeView bottomY];
    self.specialRemarkView.frame = frame;
    self.specialRemarkView.backgroundColor = [UIColor whiteColor];
    self.specialRemarkView.layer.masksToBounds = YES;
    self.specialRemarkView.layer.borderWidth = splite_line_height;
    self.specialRemarkView.layer.borderColor = [[ColorUtils colorWithHexString:splite_line_color] CGColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentChooseSpecialRemarkView:)];
    [self.specialRemarkView addGestureRecognizer:tap];
    
    
    self.specialEventArray = [SpecialEvent allEvents];
    self.specialEvent = [self.specialEventArray objectAtIndex:0];
    
    self.specialRemark.text = [NSString stringWithFormat:@"备注事件     %@", self.specialEvent.eventName];
    self.specialRemark.font = [UIFont systemFontOfSize:default_font_size];
    self.specialRemark.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.specialRemark.backgroundColor = [UIColor clearColor];
    
    [self initSpecialRemarkPicker];
}

-(void) initSpecialRemarkPicker{
    self.specialRemarkPicker.dataSource = self;
    self.specialRemarkPicker.delegate = self;
    [self.specialRemarkPicker selectRow:0 inComponent:0 animated:NO];
    
    self.specialRemarkPicker.showsSelectionIndicator = YES;
    self.specialRemarkPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    CGSize ps = [self.specialRemarkPicker sizeThatFits: CGSizeZero];
//    self.specialRemarkPicker.frame = CGRectMake(0, 37, ps.width, ps.height + 150);
}

//弹出选择备注的模态视图
-(void)presentChooseSpecialRemarkView:(id)sender{
    [self.view addSubview:self.maskView];
    
    CGRect frame = self.chooseSpecialRemarkModalView.frame;
    frame.origin.y = self.view.frame.size.height;
    self.chooseSpecialRemarkModalView.frame = frame;
    [self.view addSubview:self.chooseSpecialRemarkModalView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.chooseSpecialRemarkModalView.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.chooseSpecialRemarkModalView.frame = frame;
    }];
}

- (IBAction)cancelChooseSpecialRemark:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.chooseSpecialRemarkModalView.frame;
        frame.origin.y = self.view.frame.size.height;
        self.chooseSpecialRemarkModalView.frame = frame;
    } completion:^(BOOL finished) {
        [self.chooseSpecialRemarkModalView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
    [MobClick event:log_event_name_choose_order_time attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.stylist.name, @"发型师名字",nil]];
}

- (IBAction)confirmChooseSpecialRemark:(id)sender {
    [self cancelChooseSpecialRemark:sender];
    int selectedInx = [self.specialRemarkPicker selectedRowInComponent:0];
    self.specialEvent = [self.specialEventArray objectAtIndex:selectedInx];
    self.specialRemark.text = [NSString stringWithFormat:@"备注事件     %@", self.specialEvent.eventName];
}

# pragma mark- ----PickerView datasource-----
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.specialRemarkPicker) {
        return 1;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.specialRemarkPicker)
    {
        return [self.specialEventArray count];
    }
    else
    {
        if (component == 0) {
            return [self.daysCanOrder count];
        }
        NSLog(@">>>>> row count:%d", [self.hoursCanOrder count]);
        return [self.hoursCanOrder count]*2;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.specialRemarkPicker) {
        return ((SpecialEvent *)[self.specialEventArray objectAtIndex:row]).eventName;
    }
    else
    {
        //日期选择器部分
        if(component == 0){
            NSDate *date = (NSDate *)self.daysCanOrder[row];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE M月d日"];
    
            return [dateFormatter stringFromDate:date];
        }
        
        //小时选择器部分
        int hour = [self.hoursCanOrder[row/2] intValue];
        NSString *hourTxt = @"";
        if (hour <= 12) {
            hourTxt = [NSString stringWithFormat:@"上午%d%@", hour, row%2==0?@"点":@"半"];
        }else{
            hourTxt = [NSString stringWithFormat:@"下午%d%@", hour-12, row%2==0?@"点":@"半"];
        }
        return hourTxt;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 33;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == self.scheduleTimePicker && component == 0) {
        NSDate *date = self.daysCanOrder[row];
        self.hoursCanOrder = [self.stylist hoursCanDate:date];
        self.hoursCanOrder = [self filteHoursCanOrder:self.hoursCanOrder dayDate:date];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
    }
}

-(void)initOrderServiceDescription
{
    NSString *content = @"需1人一次性使用完毕；\n不同时享受店内其他优惠；\n所有费用向沙龙前台进行支付；\n预约后到沙龙消费时向沙龙前台出示您的订单或短信；\n临时增加项目享受您消费当日时尚猫会员优惠，费用向沙龙前台支付。";
    CommonItemTxt *item1 = [[CommonItemTxt alloc]init:1 title:@"*使用规则：" content:content];

    content = @"提前1小时可以取消预约或更改预约时间。\n更改预约时间请先取消预约后再进行新的预约。";
    
    UIFont *font = [UIFont systemFontOfSize:small_font_size];
    CommonItemTxt *item2 = [[CommonItemTxt alloc]init:1 title:@"*预约说明：" content:content];
    NSArray *array = [NSArray arrayWithObjects:item1, item2, nil];
    
    float height = [CommonItemTxtView judgeHeight:array font:font];
    float y = [self.specialRemarkView bottomY];
    CGRect frame = CGRectMake(0, y, screen_width - general_padding, height+100);
    
    itemTxtView = [[CommonItemTxtView alloc] initWithFrame:frame
                                        commonItemTxtArray:array
                                                      font:font];
    frame.origin.x = general_padding*3/2;
    itemTxtView.frame = frame;
    [self.scrollView addSubview:itemTxtView];
}

# pragma mark --- 确认按钮  --
-(void)initConfirmBtn{
    float y = self.view.frame.size.height - self.confirmBtn.frame.size.height - general_padding/2;

    self.confirmBtn.frame  = CGRectMake(general_padding, y, screen_width - 2*general_padding, self.confirmBtn.frame.size.height);
    [self.confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:big_font_size]];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"button_default"] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateHighlighted];
}

- (IBAction)confirmOrder:(id)sender {
    if (self.scheduleDate == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择预约时间!" duration:1];
        return ;
    }
    NewServiceOrder *serviceOrder = [[NewServiceOrder alloc] init];
    serviceOrder.stylistId = self.stylist.id;
    serviceOrder.scheduleTime = self.scheduleDate;
    serviceOrder.targetServiceItems = self.targetServiceItems.targetServiceItems;
    serviceOrder.orderTitle = self.servicePackage.name;
    AppStatus *as = [AppStatus sharedInstance];
    serviceOrder.poi = [NSString stringWithFormat:@"%f,%f", as.lastLat, as.lastLng];
    serviceOrder.address = [as currentLocation];
    [SVProgressHUD showWithStatus:@"正在提交..."];
    
    [[OrderStore sharedStore] submitOrder:^(ServiceOrder *order, NSError *err) {
        if (err != nil) {
            StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
            [SVProgressHUD showErrorWithStatus:exception.message duration:1.0];
        }else
        {
            [SVProgressHUD dismiss];
            OrderDetailInfoController *odic = [[OrderDetailInfoController alloc] initWithOrder:order orderUIStatus:order_ui_status_success_first];
            [self.navigationController pushViewController:odic animated:YES];
            
            //预约成功后自动完成对当前发型师的收藏
            AppStatus *as = [AppStatus sharedInstance];
            User *user = as.user;
            if (![user hasAddFavStylist:self.stylist.id]) {
                [[UserStore sharedStore] addFavStylist:^(NSError *err) {
                    AppStatus *as = [AppStatus sharedInstance];
                    NSString *url = [UserStore getUriForUserFavStylists:as.user.idStr];
                    url = [NSString stringWithFormat:@"/users/%@/stylistCollections/page?pageSize=5000&orderType=2&pageNo=1",as.user.idStr];
   
                    StylistStore *stylistStore = [StylistStore sharedStore];
                    [stylistStore getStylist:^(Page *page, NSError *err) {
                        if (err == nil) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_order_stylist object:nil];
                        }
                    } uriStr:url refresh:YES];
                    
                } userId:user.idStr.intValue stylistId:self.stylist.id];
            }
        }
    } newServiceOrder:serviceOrder];
    
    [MobClick event:log_event_name_order attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.stylist.name, @"发型师名字",nil]];
}


-(void) initMaskView
{
    self.maskView.frame = self.view.frame;
    self.maskView.backgroundColor = [ColorUtils colorWithHexString:@"#000000" alpha:0.4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_choose_order_time;
}

@end
