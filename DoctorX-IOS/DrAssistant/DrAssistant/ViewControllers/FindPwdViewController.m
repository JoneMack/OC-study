//
//  FindPwdViewController.m
//  DrAssistant
//
//  Created by hi on 15/8/29.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "FindPwdViewController.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "FindPasswordHanlder.h"
#import "RegisterHandler.h"
#import "FindPasswordEntity.h"
#import "PostCaptchasResponse.h"
#import "ValidateCodeHandler.h"

@interface FindPwdViewController ()

{
    NSTimer *_timer;
    NSInteger _remainTime;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTX;
@property (weak, nonatomic) IBOutlet UITextField *validateCode;
@property (weak, nonatomic) IBOutlet UITextField *pwdTX;

@property (weak, nonatomic) IBOutlet UITextField *conformPwdTX;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;



@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerLJWKeyboardHandler];
    
    UIImage *loginBg = [UIImage imageNamed:@"btnBg"];
    loginBg = [loginBg stretchableImageWithLeftCapWidth:loginBg.size.width/2 topCapHeight:0];
    [self.completeBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    
    UIImage *yanZhengMa_N = [UIImage imageNamed:@"yanZhengMa_normal"];
    yanZhengMa_N = [yanZhengMa_N stretchableImageWithLeftCapWidth:yanZhengMa_N.size.width/2 topCapHeight:0];
    UIImage *yanZhengMa_D = [UIImage imageNamed:@"yanZhengMa_Disable"];
    yanZhengMa_D = [yanZhengMa_D stretchableImageWithLeftCapWidth:yanZhengMa_D.size.width/2 topCapHeight:0];
    
    [self.sendCodeBtn setBackgroundImage:yanZhengMa_N  forState:UIControlStateNormal];
    [self.sendCodeBtn setBackgroundImage:yanZhengMa_D  forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendCapchasAction:(id)sender {
    if(![self checkCaptchasInfo])return;
    
    __block int timeout=119; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer1,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer1, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer1);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.sendCodeBtn.enabled =YES;
            });
            
        }else{
            int seconds = timeout % 120;
            
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"____%@",strTime);
                
                self.sendCodeBtn.enabled = NO;
                NSString *title = strTime;
                [self.sendCodeBtn setTitle:title forState:UIControlStateDisabled];
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer1);
    
    [ValidateCodeHandler getValidateCodeWith:_phoneTX.text success:^(BaseEntity *object) {
        PostCaptchasResponse *response = (PostCaptchasResponse *)object;
        if (response.success) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response.code forKey:@"PWDCODE"];
            [userDefaults setObject:response.account forKey:@"PWDCODEACCOUNT"];
            [self showString:@"验证码已经发送到你的手机"];
        }else{
            [self showString:object.msg];
        }
        
    } fail:^(id object) {
        [self showString:@"网络异常"];
    }];
    
}
- (IBAction)submitButtionAction:(id)sender {
    if(![self checkFindPasswordInfo])return;
    FindPasswordEntity *request = [FindPasswordEntity new];
    request.account = self.phoneTX.text;
    request.password = self.pwdTX.text;
    [FindPasswordHanlder FindRequestWithFindPasswordInfo:request success:^(BaseEntity *object) {
        FindPasswordEntity *response = (FindPasswordEntity *)object;
        
        if (response.success) {
            
            if ([Utils isBlankString: response.msg]) {
                response.msg = @"重置密码成功";
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            
            if ([Utils isBlankString: response.msg]) {
                response.msg = @"重置密码失败";
            }
        }
        
        [self showString: response.msg];
        
    } fail:^(id object) {
        [self showString:@"网络异常"];
    }];
}

- (BOOL)checkCaptchasInfo
{
    if ([Utils isBlankString:self.phoneTX.text]) {
        [self showString:@"手机号码不能为空"];
        return NO;
    }
    return YES;
}

- (BOOL)checkFindPasswordInfo
{
    if ([Utils isBlankString:self.phoneTX.text]) {
        [self showString:@"手机号码不能为空"];
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1([3-8][0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:self.phoneTX.text]){
        [self showString:@"请填写正确的手机号"];
        return NO;
    }
    if ([Utils isBlankString:self.validateCode.text]) {
        [self showString:@"手机验证码不能为空"];
        return NO;
    }
    if ([Utils isBlankString:self.pwdTX.text]) {
        [self showString:@"密码不能为空"];
        return NO;
    }
    if ([Utils isBlankString:self.conformPwdTX.text]) {
        [self showString:@"确认密码不能为空"];
        return NO;
    }
    if (![self.pwdTX.text isEqualToString:self.conformPwdTX.text]) {
        [self showString:@"两次密码输入不一致"];
        return NO;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* code=[userDefaults objectForKey:@"PWDCODE"];
    if (![code compare:[self.validateCode.text md532BitUpper] options:1==NSOrderedSame]) {
        [self showString:@"验证码错误"];
        return NO;
    }
     NSString* CODEACCOUNT=[userDefaults objectForKey:@"PWDCODEACCOUNT"];
    if (![CODEACCOUNT isEqualToString:self.phoneTX.text]) {
        [self showString:@"请填写正确的手机号"];
        return NO;
    }
    return YES;
}

//- (void)timerStart
//{
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//}
//- (void)timerAction
//{
//    if (_remainTime) {
//        _remainTime--;
//
//        self.sendCodeBtn.enabled = NO;
//        NSString *title = [NSString stringWithFormat:@"%ziS", _remainTime];
//        [self.sendCodeBtn setTitle:title forState:UIControlStateDisabled];
//    }else{
//        self.sendCodeBtn.enabled = YES;
//    }
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
