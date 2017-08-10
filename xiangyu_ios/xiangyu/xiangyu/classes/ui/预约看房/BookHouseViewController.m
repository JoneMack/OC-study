//
//  BookHouseViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//


#define book_type_any_time  @"anyTime"
#define book_type_special_time  @"specialTime"


#import "BookHouseViewController.h"
#import "BookViewHouseSuccessViewController.h"
#import "HouseStore.h"
#import "UserStore.h"



@interface BookHouseViewController ()

@end

@implementation BookHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self initDatePickerView];
    [self setRightSwipeGestureAndAdaptive];
}

- (void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"预约看房" navigationController:self.navigationController];
    [self.headerBlock addSubview:self.headerView];
}

- (void) initBodyView
{
    [self.bookAnyTime setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 13)];
    [self.bookSpecialTime setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 13)];

    [self.booTime setImageEdgeInsets:UIEdgeInsetsMake(0, screen_width - 88 - 37, 0, 0)];
    
    [self.sendCheckCode setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.sendCheckCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendCheckCode.layer.masksToBounds = YES;
    self.sendCheckCode.layer.cornerRadius = 5;
    
    [self.submitBook setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.submitBook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBook.layer.masksToBounds = YES;
    self.submitBook.layer.cornerRadius = 5;
    
    self.separatorLine = [[UIView alloc] init];
    [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color ]];
    self.separatorLine.frame = CGRectMake(0, 43.5, screen_width-88-10, splite_line_height);
    [self.bookTimeBlock addSubview:self.separatorLine];
    
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        [self.mobileNo setText:as.user.userId];
        [self.checkCode setHidden:YES];
        [self.sendCheckCode setHidden:YES];
        [self.checkCodeLabel setHidden:YES];
    }
    
    self.currentBookType = book_type_special_time;
    
}

-(void) initDatePickerView
{
    self.selectDateTimePicker = [[SelectDateTimePicker alloc] initWithFrame:CGRectMake(0, screen_height, screen_width, screen_height-64)];
    [self.selectDateTimePicker fillMinuteInterval:15];
    [self.view addSubview:self.selectDateTimePicker];
    
    [self.booTime addTarget:self action:@selector(selectBookTime) forControlEvents:UIControlEventTouchUpInside];
    self.selectDateTimePicker.delegate = self;
}


/**
 * 点击了随时看房
 */
- (IBAction)changeToBookAndTime:(id)sender {
    
    [self.bookAnyTime setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    [self.bookSpecialTime setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    self.currentBookType = book_type_any_time;
    // 设置booktimeblock的高度为0;

    self.bookTimeBlockCons = [NSLayoutConstraint constraintWithItem:self.bookTimeBlock attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    
    [self.bookTimeBlock addConstraint:self.bookTimeBlockCons];
    [self.booTime setHidden:YES];
    
}

/**
 * 点击了指定时间
 */
- (IBAction)changeToBookSpecialTime:(id)sender {
    
    [self.bookAnyTime setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    [self.bookSpecialTime setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    self.currentBookType = book_type_special_time;
    // 设置booktimeblock的高度为44
    [self.booTime setHidden:NO];
    [self.bookTimeBlock removeConstraint:self.bookTimeBlockCons];
}


/**
 * 显示选择时间 datepickerView
 */
-(void) selectBookTime{
    [self.selectDateTimePicker showSelf];
}


/**
 * 选择时间之后的回调
 */
-(void) selectedVal:(NSDate *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 时分秒要齐全
    NSString *destDateString = [dateFormatter stringFromDate:time];
    [self.booTime setTitle:destDateString forState:UIControlStateNormal];
}


/**
 * 发送验证码
 */
- (IBAction)sendCheckCodeEvent:(id)sender {
    
    NSString *mobileNo = self.mobileNo.text;
    
    if(mobileNo.length != 11){
        [self.view makeToast:@"请输入正确的手机号" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    [[UserStore sharedStore] requestTempPwd:^(NSError *err) {
        if ( err == nil ){
            [self changeSendCheckCodeBtnStatus];
        }
    } mobileNo:mobileNo];
    
}


-(void) changeSendCheckCodeBtnStatus{
    
    [self.sendCheckCode setBackgroundColor:[ColorUtils colorWithHexString:@"cccccc"]];
    [self.sendCheckCode setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray3] forState:UIControlStateDisabled];
    [self.sendCheckCode setEnabled:NO];
    self.leftCount = 60;
    [self.sendCheckCode setTitle:[NSString stringWithFormat:@"%d秒后" , self.leftCount] forState:UIControlStateDisabled];
    
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLeftTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
    
}

-(void) changeLeftTime
{
    if(self.leftCount == 0){
        self.leftCount = 60;
        [self.sendCheckCode setEnabled:YES];
        [self.sendCheckCode setBackgroundColor:[ColorUtils colorWithHexString:bg_yellow]];
        [self.sendCheckCode setTitle:@"发送验证码" forState:UIControlStateDisabled];
        [self.countTimer invalidate];
        self.countTimer = nil;
    }else{
        self.leftCount = self.leftCount -1;
        [self.sendCheckCode setTitle:[NSString stringWithFormat:@"%d秒后" , self.leftCount] forState:UIControlStateDisabled];
    }
}



/**
 * 提交看房预约
 */
- (IBAction)submitBookViewHouse:(id)sender {
    
    NSString *mobile = self.mobileNo.text;
    NSString *userName = self.userName.text;
    
    if([NSStringUtils isBlank:userName]){
        [self.view makeToast:@"请填写姓名" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }

    
    if(mobile.length != 11){
        [self.view makeToast:@"请输入正确的手机号" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    NSLog(@" >>>>>> self.houseInfo :%@" , self.houseInfo);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:userName forKey:@"contactsUser"];
    [params setObject:self.houseInfo.houseId forKey:@"houseInfoId"];
    [params setObject:self.houseInfo.rentType forKey:@"rentType"];
    if ([NSStringUtils isNotBlank:self.houseInfo.roomId]) {
        [params setObject:self.houseInfo.roomId forKey:@"roomId"];
    }
    [params setObject:@"1" forKey:@"resourceType"]; // 接口固定参数
    [params setObject:self.houseInfo.rentPrice forKey:@"rentPrice"];
    
    if([self.currentBookType isEqualToString:book_type_any_time]){
        [params setObject:@"" forKey:@"appointmentTime"];
    }else{
        NSString *date =  self.booTime.titleLabel.text;
        if([NSStringUtils isBlank:date] || [date isEqualToString:@"请选择指定的时间"]){
            [self.view makeToast:@"请选择指定的时间" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            return ;
        }
        [params setObject:date forKey:@"appointmentTime"];
    }
    
    
    AppStatus *as = [AppStatus sharedInstance];
    
    if([as logined]){
        // 用户已登录
        NSLog(@" postAppointment4House params : %@" , params);
        [[HouseStore sharedStore] postAppointment4House:^(NSError *err) {
            if(err == nil){
                BookViewHouseSuccessViewController * successController = [[BookViewHouseSuccessViewController alloc] init];
                [self.navigationController pushViewController:successController animated:YES];
            }else{
                ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
                [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            }
        } params:params];
        
    }else {
        // 用户没有登录
        NSString *checkCode = self.checkCode.text;
        if(checkCode.length == 0){
            [self.view makeToast:@"请输入验证码" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
        [[UserStore sharedStore] login:^(User *user, NSError *err) {
            if(user != nil){
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_login object:nil];
                [[HouseStore sharedStore] postAppointment4House:^(NSError *err) {
                    if(err == nil){
                        BookViewHouseSuccessViewController * successController = [[BookViewHouseSuccessViewController alloc] init];
                        [self.navigationController pushViewController:successController animated:YES];
                    }else{
                        ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
                        NSLog(@"exception :%@" , exception);
                        [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
                    }
                } params:params];
            }
        } mobileNo:mobile pwd:checkCode];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end
