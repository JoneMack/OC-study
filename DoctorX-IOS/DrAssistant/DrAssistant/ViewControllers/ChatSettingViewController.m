//
//  ChatSettingViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ChatSettingViewController.h"
#import "EMCDDeviceManager+Remind.h"
#import "AppStatus.h"
@interface ChatSettingViewController ()
{
    EMPushNotificationDisplayStyle _pushDisplayStyle;
    EMPushNotificationNoDisturbStatus _noDisturbingStatus;
    NSInteger _noDisturbingStart;
    NSInteger _noDisturbingEnd;
    NSString *_nickName;
}

@end

@implementation ChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initRightAddressBtn];
    [self refreshPushOptions];
    
       [self.receiveMsgSwitch setOn:YES animated:YES];
        [self.openVoiceSwitch setOn:YES animated:YES];
        [self.shakeSwitch setOn:YES animated:YES];
        [self.yangShengQiSwitch setOn:YES animated:YES];

//    if ([AppStatus sharedInstance].receiveMsgSwitch == 1) {
//        [self refreshPushOptions];
//        [self.receiveMsgSwitch addTarget:self action:@selector(pushDisplayChanged:) forControlEvents:UIControlEventValueChanged];
//
//        [self.receiveMsgSwitch setOn:YES animated:YES];
//        if ([AppStatus sharedInstance].voiceSwitch == 1) {
//            [self.openVoiceSwitch setOn:YES animated:YES];
//        }else{
//            [self.openVoiceSwitch setOn:NO animated:YES];
//        }
//        if ([AppStatus sharedInstance].shakeSwitch == 1) {
//          [self.shakeSwitch setOn:YES animated:YES];
//        }else{
//            [self.shakeSwitch setOn:NO animated:YES];
//        }
//    }else{
//        [self.receiveMsgSwitch setOn:NO animated:YES];
//        [self.openVoiceSwitch setOn:NO animated:YES];
//        [self.shakeSwitch setOn:NO animated:YES];
//    }
//    
//    if ([AppStatus sharedInstance].yangShengQiSwitch == 1) {
//        [self.yangShengQiSwitch setOn:YES animated:YES];
//    }else{
//        [self.yangShengQiSwitch setOn:NO animated:YES];
//    }
}

//右侧定位按钮
-(void)initRightAddressBtn{
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [clearButton setTitle:@"保存" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(savePushOptions) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)newTongZhi:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSLog(@">>>>>>>>>>>>>>>>>>>>接受新消息通知>>>>>>>>>>>>>%d",isButtonOn);
    if (isButtonOn) {
        EMCDDeviceManager *manager=[[EMCDDeviceManager alloc]init];
        [manager playNewMessageSound];
    }else{
        
    }
    if (isButtonOn == NO) {
        [self.openVoiceSwitch setOn:NO animated:YES];
        [self.shakeSwitch setOn:NO animated:YES];
        [AppStatus sharedInstance].voiceSwitch = isButtonOn;
        [AppStatus sharedInstance].shakeSwitch = isButtonOn;
    }
    [AppStatus sharedInstance].receiveMsgSwitch = isButtonOn;
    [AppStatus saveAppStatus];
}

- (IBAction)soundSet:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSLog(@">>>>>>>>>>>>>>>>>>>>声音>>>>>>>>>>>>>%d",isButtonOn);
    if (isButtonOn) {
        EMCDDeviceManager *manager=[[EMCDDeviceManager alloc]init];
        [manager playNewMessageSound];
    }else{
        
    }
    [AppStatus sharedInstance].voiceSwitch = isButtonOn;
    [AppStatus saveAppStatus];
}

- (IBAction)shockSet:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSLog(@">>>>>>>>>>>>>>>>>>>>震动>>>>>>>>>>>>>%d",isButtonOn);
    if (isButtonOn) {
        EMCDDeviceManager *manager=[[EMCDDeviceManager alloc]init];
        [manager playVibration];
    }else{
        
    }
    [AppStatus sharedInstance].shakeSwitch = isButtonOn;
    [AppStatus saveAppStatus];
}

- (IBAction)voiceSet:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSLog(@">>>>>>>>>>>>>>>>>>>>扬声器>>>>>>>>>>>>>%d",isButtonOn);
    if (isButtonOn) {
        //
    }else{
        
    }
    [AppStatus sharedInstance].yangShengQiSwitch = isButtonOn;
    [AppStatus saveAppStatus];
}

#pragma mark - action

- (void)savePushOptions
{
    BOOL isUpdate = NO;
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    if (_pushDisplayStyle != options.displayStyle) {
        options.displayStyle = _pushDisplayStyle;
        isUpdate = YES;
    }
    
    if (isUpdate) {
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushDisplayChanged:(UISwitch *)pushDisplaySwitch
{
    if (pushDisplaySwitch.isOn) {
#warning 此处设置详情显示时的昵称，比如_nickName = @"环信";
        _pushDisplayStyle = ePushNotificationDisplayStyle_messageSummary;
    }
    else{
        _pushDisplayStyle = ePushNotificationDisplayStyle_simpleBanner;
    }
}

- (void)refreshPushOptions
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    _pushDisplayStyle = options.displayStyle;
   
    BOOL isDisplayOn = _pushDisplayStyle == ePushNotificationDisplayStyle_simpleBanner ? NO : YES;
    [self.receiveMsgSwitch setOn:isDisplayOn animated:YES];
}



@end
