//
//  SelectOrderTimeController.m
//  styler
//
//  Created by wangwanggy820 on 14-4-7.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderOnlineController.h"
#import "UIView+Custom.h"
#import "SpecialEvent.h"
#import "NewServiceOrder.h"
#import "OrderStore.h"
#import "StylerException.h"
#import "OrderDetailInfoController.h"
#import "UIView+Custom.h"
#import "OrderedTime.h"
#import "UserStore.h"
#import "UIViewController+Custom.h"
#import "StylistStore.h"
#import "ImageUtils.h"
#import "UILabel+Custom.h"
#import "DateUtils.h"
#import "CommonItemTxt.h"


#define name_width  130
#define sex_width   60
#define scrollView_off_height 60
@interface OrderOnlineController ()

@end

@implementation OrderOnlineController
{
    int count;
    int selectedRowOfServicePackage;
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
    [self requestServicePackage];
}
//初始化整个View
-(void)initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder:)];
    [self.scrollView addGestureRecognizer:tap1];
    
    [self initHeader];
    [self initConfirmBtn];
    [self initScrollView];
    [self initMaskView];
}

-(void)resignFirstResponder:(UITapGestureRecognizer *)sender{
    [self.inputRemark resignFirstResponder];
}

#pragma mark -------初始化头部---
-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_choose_order_time navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void)initScrollView{
    self.scrollView.backgroundColor = [UIColor clearColor];
    float height = self.view.frame.size.height-self.header.frame.size.height-tabbar_height;
    self.scrollView.frame = CGRectMake(0, self.header.frame.size.height , screen_width, height);
    
    [self initUserInfoTableView];
    [self initChooseServicePackage];
    [self initScheduleTimeView];
    [self initServicePackageView];
    [self initOrderServiceDescription];
    
    self.scrollView.contentSize = CGSizeMake(screen_width, height+scrollView_off_height+tabbar_height);
    count = 0;
    selectedRowOfServicePackage = -1;
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

#pragma mark ----- 初始化预约种类 -------
-(void)initChooseServicePackage{
    CGRect frame = self.chooseServicePackage.frame;
    frame.origin.y = [self.userInfoTableView bottomY] + general_margin;
    self.chooseServicePackage.frame = frame;
    [self.chooseServicePackage addStrokeBorderWidth:splite_line_height cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
    self.servicePackageName.backgroundColor = [UIColor clearColor];
    self.servicePackageName.font = [UIFont systemFontOfSize:default_font_size];
    self.servicePackageName.textColor = [ColorUtils colorWithHexString: black_text_color];
    self.servicePackageName.text = @"       请选择意向服务项目";
    self.servicePackageName.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentChooseServicePackageView:)];
    [self.chooseServicePackage addGestureRecognizer:tap];
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
    frame.origin.y = [self.chooseServicePackage bottomY] + general_margin;
    self.scheduleTimeView.frame = frame;
    self.scheduleTimeView.userInteractionEnabled = YES;
    self.scheduleTimeView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    [self.chooseTime setText:@"     时间         请选择到店时间"];
    [self.chooseTime setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    self.chooseTime.layer.masksToBounds = YES;
    self.chooseTime.layer.borderWidth = splite_line_height;
    self.chooseTime.layer.borderColor = [[ColorUtils colorWithHexString:splite_line_color] CGColor];
    self.chooseTime.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentChooseTimeModalView:)];
    [self.scheduleTimeView addGestureRecognizer:tap];
    [self initChooseScheduleTimePicker];
    [self.scheduleTimeView setUserInteractionEnabled:NO];
    [self.scheduleTimeView setAlpha:0.4];
}

#pragma mark ----------ScheduleTimePicker -----
-(void)initChooseScheduleTimePicker
{
    self.daysCanOrder = [self.stylist daysCanDate];
    self.hoursCanOrder = [self.stylist hoursCanDate:(NSDate*)self.daysCanOrder[0]];
    
    [[OrderStore sharedStore] getOrderedTime:^(NSArray *orderedTimes, NSError *err) {
        if (err == nil) {
            self.orderedTimes = orderedTimes;
        }
    } stylistId:self.stylist.id];
    
    self.scheduleTimePicker.dataSource = self;
    self.scheduleTimePicker.delegate = self;
    
    self.scheduleTimePicker.showsSelectionIndicator = YES;
    self.scheduleTimePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

-(NSArray *)filteHoursCanOrder:(NSArray *)hoursCanOrder dayDate:(NSDate *)dayDate{
    if (self.orderedTimes == nil) {
        return hoursCanOrder;
    }
    StylistServicePackage *servicePackage = self.servicePackages[selectedRowOfServicePackage];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < hoursCanOrder.count; i++) {
        float hourCanOrder = [hoursCanOrder[i] floatValue];
        
        if ([OrderedTime canOrder:dayDate hour:hourCanOrder serviceIntention:servicePackage.name orderedTimes:self.orderedTimes]) {
            [result addObject:hoursCanOrder[i]];
        }
    }
    return result;
}

-(void)presentChooseTimeModalView:(id)sender{
    [self.view addSubview:self.maskView];
    [self.inputRemark resignFirstResponder];
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
    float hour = [self.hoursCanOrder[selectedRow] floatValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    int hourInt = hour * 10;
    if (hourInt % 10 == 0) {
        comps.hour = hour;
        comps.minute = 0;
    }else{
        comps.hour = (int)(hourInt/10);
        comps.minute = 30;
    }
    self.scheduleDate = [calendar dateFromComponents:comps];
    self.chooseTime.text=[NSString stringWithFormat:@"     时间   %@", [DateUtils stringFromDate:self.scheduleDate]];

    [self cancelChooseTime:sender];
    
    [MobClick event:log_event_name_choose_order_time];
}


#pragma mark --- 初始化备注事件
-(void)initServicePackageView{
    CGRect frame = self.specialRemarkView.frame;
    frame.origin.y = [self.scheduleTimeView bottomY] + general_margin;
    self.specialRemarkView.frame = frame;
    self.specialRemarkView.backgroundColor = [UIColor whiteColor];
    self.specialRemarkView.layer.masksToBounds = YES;
    self.specialRemarkView.layer.borderWidth = splite_line_height;
    self.specialRemarkView.layer.borderColor = [[ColorUtils colorWithHexString:splite_line_color] CGColor];

    
    self.specialRemark.text = [NSString stringWithFormat:@"预约留言"];
    self.specialRemark.font = [UIFont systemFontOfSize:default_font_size];
    self.specialRemark.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.specialRemark.backgroundColor = [UIColor clearColor];
    
    self.inputRemark.delegate = self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) initServicePackagePicker{
    self.servicePackagePicker.dataSource = self;
    self.servicePackagePicker.delegate = self;
    [self.servicePackagePicker selectRow:0 inComponent:0 animated:NO];
    
    self.servicePackagePicker.showsSelectionIndicator = YES;
    self.servicePackagePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

//弹出选择服务包的模态视图
-(void)presentChooseServicePackageView:(id)sender{
    [self.inputRemark resignFirstResponder];
    [self.view addSubview:self.maskView];
    [self initServicePackagePicker];
    
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

- (IBAction)cancelChooseServicePackage:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.chooseSpecialRemarkModalView.frame;
        frame.origin.y = self.view.frame.size.height;
        self.chooseSpecialRemarkModalView.frame = frame;
    } completion:^(BOOL finished) {
        [self.chooseSpecialRemarkModalView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

- (IBAction)confirmChooseServicePackage:(id)sender {
    [self cancelChooseServicePackage:sender];
    selectedRowOfServicePackage = [self.servicePackagePicker selectedRowInComponent:0];
    StylistServicePackage *servicePackage = self.servicePackages[selectedRowOfServicePackage];
    self.servicePackageName.text = [NSString stringWithFormat:@"      %@", servicePackage.name];
    
    [self.scheduleTimeView setUserInteractionEnabled:YES];
    [self.scheduleTimeView setAlpha:1.0];
    self.hoursCanOrder = [self filteHoursCanOrder:self.hoursCanOrder dayDate:self.daysCanOrder[0]];
    
    [MobClick event:log_event_name_choose_service_package attributes:[NSDictionary dictionaryWithObjectsAndKeys:servicePackage.name, @"服务意向",nil]];
}

# pragma mark- ----PickerView datasource-----
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.servicePackagePicker) {
        return 1;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.servicePackagePicker)
    {
        return [self.servicePackages count];
    }
    else
    {
        if (component == 0) {
            return [self.daysCanOrder count];
        }
        
        return [self.hoursCanOrder count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.servicePackagePicker) {
        return ((StylistServicePackage *)[self.servicePackages objectAtIndex:row]).name;
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
        float hour = [self.hoursCanOrder[row] floatValue];
        NSString *hourTxt;
        NSMutableString *hourString = [NSMutableString stringWithFormat:@"%.1f", hour];
        [hourString replaceOccurrencesOfString:@".0" withString:@":00" options:NSCaseInsensitiveSearch range:NSMakeRange(0, hourString.length)];
        [hourString replaceOccurrencesOfString:@".5" withString:@":30" options:NSCaseInsensitiveSearch range:NSMakeRange(0, hourString.length)];
        if (hour <= 12.5) {
            hourTxt = [NSString stringWithFormat:@"%@", hourString];
        }else{
            hourTxt = [NSString stringWithFormat:@"%@", hourString];
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
    [self.serviceDescriptionWapper addStrokeBorderWidth:splite_line_height cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
    
    NSString *content = order_reminder;
    CommonItemTxt *item1 = [[CommonItemTxt alloc]init:1 title:@"温馨提示" content:content];
    
    content = order_illustrate;
    UIFont *font = [UIFont systemFontOfSize:default_2_font_size];
    CommonItemTxt *item2 = [[CommonItemTxt alloc]init:1 title:@"预约说明" content:content];
    NSArray *array = [NSArray arrayWithObjects:item1, item2, nil];
    
    float height = [CommonItemTxtView judgeHeight:array font:font]+3*general_margin+general_padding;
    CGRect frame = CGRectMake(general_padding, 0, screen_width - 2*general_padding, height);
    
    self.orderServiceDescriptionView = [[CommonItemTxtView alloc] initWithFrame:frame
                                                             commonItemTxtArray:array
                                                                           font:font];
    [self.serviceDescriptionWapper addSubview:self.orderServiceDescriptionView];
    
    float y = [self.specialRemarkView bottomY] + general_margin;
    frame = self.serviceDescriptionWapper.frame;
    frame.origin.y = y;
    frame.size.height = height;
    self.serviceDescriptionWapper.frame = frame;
}

# pragma mark --- 确认按钮  --
-(void)initConfirmBtn{
    float y = self.view.frame.size.height - self.confirmBtn.frame.size.height - general_padding;
    CGRect frame = self.btnWapper.frame;
    frame.origin.y = y;
    self.btnWapper.frame = frame;
    self.btnWapper.backgroundColor = [ColorUtils colorWithHexString: backgroud_color];
    [self.confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:big_font_size]];
    [self.confirmBtn setBackgroundImage:[ImageUtils createPureColorImage:self.confirmBtn.frame.size andColor:[ColorUtils colorWithHexString:red_default_color]] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"red_phone"] forState:UIControlStateHighlighted];
    [self.confirmBtn addStrokeBorderWidth:0 cornerRadius:3 color:nil];
}

- (IBAction)confirmOrder:(id)sender {
    //校验是否选择了服务包
    if (selectedRowOfServicePackage == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择意向服务项目!" duration:1];
        return ;
    }
    
    if (self.scheduleDate == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择预约时间!" duration:1];
        return ;
    }

    NewServiceOrder *serviceOrder = [[NewServiceOrder alloc] init];
    serviceOrder.stylistId = self.stylist.id;
    serviceOrder.scheduleTime = self.scheduleDate;
    serviceOrder.orderMessage = self.inputRemark.text;
    
    
    StylistServicePackage *servicePackage = self.servicePackages[selectedRowOfServicePackage];
    serviceOrder.targetServiceItems = servicePackage.targetServiceItemSuite.targetServiceItems;
    serviceOrder.orderTitle = servicePackage.name;
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
    
    [MobClick event:log_event_name_submit_order_stylist attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.stylist.name, @"发型师名字",nil]];
}


-(void) initMaskView
{
    self.maskView.frame = self.view.frame;
    self.maskView.backgroundColor = [ColorUtils colorWithHexString:@"#000000" alpha:0.4];
}


-(void)requestServicePackage{
    [[StylistStore sharedStore] getStylistServicePackage:^(NSArray *servicePackages, NSError *err) {
        if (!err) {
            self.servicePackages = servicePackages;
            [self.servicePackagePicker reloadAllComponents];
        }else{
            NSLog(@"== %@",err);
        }
    } stylistId:self.stylist.id];
    count++;
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
