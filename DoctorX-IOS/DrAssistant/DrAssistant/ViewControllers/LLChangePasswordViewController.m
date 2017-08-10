//
//  LLChangePasswordViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "LLChangePasswordViewController.h"
#import "FindPasswordHanlder.h"
#import "FindPasswordEntity.h"
@interface LLChangePasswordViewController ()

@end

@implementation LLChangePasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addRightBtnAction];

}

#pragma mark - 提交
- (void)saveButtonAction
{
    if(![self checkPasswordInfo])return;
    FindPasswordEntity *request = [FindPasswordEntity new];
    request.account = [GlobalConst shareInstance].loginInfo.login_name;
    request.password = self.xinPwd.text;
    [FindPasswordHanlder FindRequestWithFindPasswordInfo:request success:^(BaseEntity *object) {
        FindPasswordEntity *response = (FindPasswordEntity *)object;
        
        if (response.success) {
            
            if ([Utils isBlankString: response.msg]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:self.xinPwd.text forKey:Key_Password];
              response.msg=@"修改密码成功";
                
                // 此处需另作修改
                [self showWithStatus:@"正在退出..."];
                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                    if (error && error.errorCode != EMErrorServerNotLogin) {
                        //            [self showWithStatus:@"退出失败..."];
                    }
                    else{
                        
                    }
                    [self dismissToast];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                } onQueue:nil];
            }
            
        }else{
            
            if ([Utils isBlankString: response.msg]) {
                response.msg=@"修改密码失败";
            }
        }
        [self showString: response.msg];
        
    } fail:^(id object) {
        [self showString:@"网络异常"];
    }];

}
- (BOOL)checkPasswordInfo{
       if ([Utils isBlankString:self.oldPwd.text]) {
        [self showString:@"原密码不能为空"];
        return NO;
    }
    if ([Utils isBlankString:self.xinPwd.text]) {
        [self showString:@"新密码不能为空"];
        return NO;
    }
    if ([Utils isBlankString:self.conformPwd.text]) {
        [self showString:@"确认密码不能为空"];
        return NO;
    }
    if (![self.xinPwd.text isEqualToString:self.conformPwd.text]) {
        [self showString:@"两次密码输入不一致"];
        return NO;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* pwd=[userDefaults objectForKey:Key_Password];
    if (![pwd isEqualToString:self.oldPwd.text]) {
        [self showString:@"原密码错误"];
        return NO;
    }
    if([self.xinPwd.text length]<6||[self.xinPwd.text length]>18){
        [self showString:@"密码长度6-18位数字"];
        return NO;
    }
    return YES;
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

@end
