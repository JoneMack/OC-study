//
//  UserLoginViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "UserLoginViewController.h"
#import "UserStore.h"
#import "AccountSessionSpringBoard.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.sendCheckCode setBackgroundColor:[ColorUtils colorWithHexString:bg_yellow]];
    [self.login setBackgroundColor:[ColorUtils colorWithHexString:bg_purple alpha:0.5]];
    
    [self setRightSwipeGestureAndAdaptive];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)userLogin:(id)sender {
    
    NSString *mobileNo = self.mobileNo.text;
    if(mobileNo.length != 11){
        [self.view makeToast:@"请输入正确的手机号" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    NSString *checkCode = self.pwd.text;
    if(checkCode.length == 0){
        [self.view makeToast:@"请输入验证码" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    [[UserStore sharedStore] login:^(User *user, NSError *err) {
        if(user != nil){
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_login object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
//            [AccountSessionSpringBoard jumpToAccountSessionFrom:self accountSessionFrom:self.accountSessionFrom];
        }
    } mobileNo:mobileNo pwd:checkCode];
    
}

- (IBAction)sendCheckCode:(id)sender {
    
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

- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
