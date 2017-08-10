//
//  RegisterBodyView.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/31.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define REG_INPUT_ROW_HEIGHT 46


#import "RegisterBodyView.h"
#import "UserStore.h"
#import "InputPwdViewController.h"

@implementation RegisterBodyView
{
    NSTimer *countDownTimer;
    int secondsCountDown;
}


-(instancetype) initWithNavigationController:(UINavigationController *) navigationController
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RegisterBodyView" owner:self options:nil] objectAtIndex:0];
        self.navigationController = navigationController;
        // 设置 外层view
        CGRect inputBlockFrame = CGRectMake( 33, 20,screen_width -66 , 138);
        self.inputBlockView.frame = inputBlockFrame;
        self.inputBlockView.backgroundColor = [UIColor clearColor];
        self.inputBlockView.layer.borderWidth = border_width;
        self.inputBlockView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.inputBlockView.layer.cornerRadius = 10;
        self.inputBlockView.layer.masksToBounds = YES;
        
        // 设置输入手机号
        CGRect inputMobilePhoneFrame = CGRectMake(10, 0, inputBlockFrame.size.width-20, 46);
        self.inputMobilePhoneField.frame = inputMobilePhoneFrame;
        self.inputMobilePhoneField.backgroundColor = [UIColor clearColor];
        self.inputMobilePhoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [self.inputMobilePhoneField setKeyboardType:UIKeyboardTypeNumberPad];
        
        // 第一根下划线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [UIColor whiteColor];
        self.separatorLine.frame = CGRectMake(0, inputMobilePhoneFrame.size.height - splite_line_height,
                                              self.inputBlockView.frame.size.width,
                                              splite_line_height);
        [self.inputBlockView addSubview:self.separatorLine];
        
        // 输入验证码
        CGRect inputCheckCodeFrame = CGRectMake(10, self.separatorLine.bottomY,
                                                inputMobilePhoneFrame.size.width - 73,
                                                REG_INPUT_ROW_HEIGHT);
        self.inputCheckCodeField.frame = inputCheckCodeFrame;
        self.inputCheckCodeField.backgroundColor = [UIColor clearColor];
        self.inputCheckCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.inputCheckCodeField.font = [UIFont systemFontOfSize:14];
        self.inputCheckCodeField.textColor = [UIColor whiteColor];
        [self.inputCheckCodeField setKeyboardType:UIKeyboardTypeNumberPad];
        
        // 申请验证码
        CGRect applyForCheckCodeBtnFrame = CGRectMake(self.inputCheckCodeField.rightX+10,
                                                      self.separatorLine.frame.origin.y+border_width,
                                                      73,
                                                      REG_INPUT_ROW_HEIGHT);
        self.applyForCheckCodeBtn.frame = applyForCheckCodeBtnFrame;
        [self.applyForCheckCodeBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color]
                                        forState:UIControlStateNormal];
        self.applyForCheckCodeBtn.backgroundColor = [UIColor whiteColor];
        self.applyForCheckCodeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        // 第二根下划线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [UIColor whiteColor];
        self.separatorLine.frame = CGRectMake(0, self.applyForCheckCodeBtn.bottomY - splite_line_height,
                                              inputMobilePhoneFrame.size.width,
                                              splite_line_height);
        [self.inputBlockView addSubview:self.separatorLine];
        
        // 输入邀请码
        CGRect invitationCodeViewFrame = CGRectMake(10, self.inputCheckCodeField.bottomY,
                                                    inputMobilePhoneFrame.size.width,
                                                    REG_INPUT_ROW_HEIGHT-5);
        self.invitationCodeField.frame = invitationCodeViewFrame;
        self.invitationCodeField.backgroundColor = [UIColor clearColor];
        self.invitationCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邀请码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.invitationCodeField.font = [UIFont systemFontOfSize:14];
        self.invitationCodeField.textColor = [UIColor whiteColor];
        
        
        // 下一步
        self.nextBtn.frame = CGRectMake(inputBlockFrame.origin.x, self.inputBlockView.bottomY+25,
                                        inputBlockFrame.size.width, 48);
        self.nextBtn.layer.cornerRadius = 8;
        self.nextBtn.layer.masksToBounds = YES;
        self.nextBtn.backgroundColor = [UIColor whiteColor];
        [self.nextBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateNormal];
        self.nextBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
    }
    return self;
}

#pragma mark 监听 输入框 输入内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.inputMobilePhoneField == textField) {
        if (textField.text.length >= 12) {
            return NO;
        }
    }else if (self.inputCheckCodeField == textField) {
        if (textField.text.length >= 6) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 触摸事件使键盘失去第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.invitationCodeField == textField) {
        [self endEditing:YES];
    }
    return YES;
}


- (IBAction)getCheckCode:(id)sender
{
    NSString *mobileNo = self.inputMobilePhoneField.text;
    
    if (mobileNo == nil || mobileNo.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    [SVProgressHUD showWithStatus:network_status_register];
    [[UserStore sharedStore] regUser:^(User *user, NSError *err) {  // 注册用户
        
        [SVProgressHUD dismiss];
        if (err == nil) { // 注册成功
            self.user = user;
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送到您的手机上"];
            secondsCountDown = 60;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }else{
            ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:exception.message];
        }
        
    } mobileNo:mobileNo];
    
}

- (IBAction)nextStep:(id)sender {
    
    NSString *mobileNo = self.inputMobilePhoneField.text;
    NSString *pwd = self.inputCheckCodeField.text;
    NSString *invitationCode = self.invitationCodeField.text;
    
    if (mobileNo == nil || [mobileNo isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    
    if (pwd == nil || [pwd isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        return;
    }
    
    NSString *oldPwd = [NSString stringWithFormat:@"%d" ,self.user.initPwd];
    
    [[UserStore sharedStore] loginWithInvitationCode:^(User *user, NSError *err) {
    
        if (err == nil){
            InputPwdViewController *inputPwdController = [[InputPwdViewController alloc] init];
            inputPwdController.user = user;
            inputPwdController.oldPwd = oldPwd;
            [self.navigationController pushViewController:inputPwdController animated:YES];
        }
    } mobileNo:mobileNo pwd:pwd invitationCode:invitationCode];
    
}

#pragma makr 计时 ， 一分钟后可重新发送验证码
-(void) countDown
{
    if (secondsCountDown == 0) {
        [countDownTimer invalidate];
        [self.applyForCheckCodeBtn setEnabled:YES];
        self.applyForCheckCodeBtn.titleLabel.text = @"获取验证码";
        [self.applyForCheckCodeBtn setTitle:@"获取验证码"
                                   forState:UIControlStateDisabled ];
    }else{
        secondsCountDown--;
        [self.applyForCheckCodeBtn setEnabled:NO];
        self.applyForCheckCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%d秒后重新获取" , secondsCountDown];
        [self.applyForCheckCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取" , secondsCountDown]
                                   forState:UIControlStateDisabled ];
        [self.applyForCheckCodeBtn setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateDisabled];
    }
}


@end
