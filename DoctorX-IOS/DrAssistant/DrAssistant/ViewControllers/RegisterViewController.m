//
//  RegisterViewController.m
//  DrAssistant
//
//  Created by hi on 15/8/29.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "RegisterEntityRequest.h"
#import "RegisterEntityResponse.h"
#import "PostCaptchasResponse.h"
#import "RegisterHandler.h"
#import "ThirdRegisterEntityRequest.h"
#import "ValidateCodeHandler.h"
#import "LoginHandler.h"
#import "UserDefaultsUtils.h"
#import "UserProtrolViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumerTX;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTX;
@property (weak, nonatomic) IBOutlet UITextField *passwordTX;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTX;
@property (weak, nonatomic) IBOutlet UIButton *roleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIView *line2;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (strong, nonatomic) NSTimer *timer;
@property (unsafe_unretained, nonatomic) NSInteger remainTime;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.pushType == push_from_third_platfrom){
        self.title = @"绑定账号";
        self.sendCodeBtn.hidden = YES;
        self.validateCodeTX.hidden = YES;
        self.line2.hidden = YES;
        NSArray* constrains = self.validateCodeTX.constraints;
        for (NSLayoutConstraint* constraint in constrains) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 0.0;
            }
        }
    }else{
        self.title = @"快速注册";
    }
    NSLog(@">>>>>>>>>>>>>>传递的用户名>>>>>>>%@>>>>>>>>%@",self.realName,self.thumb);
    
    UIImage *loginBg = [UIImage imageNamed:@"btnBg"];
    loginBg = [loginBg stretchableImageWithLeftCapWidth:loginBg.size.width/2 topCapHeight:0];
    [self.registerBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    
    [self.circleBtn setImage:[UIImage imageNamed:@"rgister_daGou"] forState:UIControlStateSelected];
    
    UIImage *yanZhengMa_N = [UIImage imageNamed:@"yanZhengMa_normal"];
    yanZhengMa_N = [yanZhengMa_N stretchableImageWithLeftCapWidth:yanZhengMa_N.size.width/2 topCapHeight:0];
    UIImage *yanZhengMa_D = [UIImage imageNamed:@"yanZhengMa_Disable"];
    yanZhengMa_D = [yanZhengMa_D stretchableImageWithLeftCapWidth:yanZhengMa_D.size.width/2 topCapHeight:0];
    
    [self.sendCodeBtn setBackgroundImage:yanZhengMa_N  forState:UIControlStateNormal];
    [self.sendCodeBtn setBackgroundImage:yanZhengMa_D  forState:UIControlStateDisabled];
    
    [self registerLJWKeyboardHandler];
    
    [_roleBtn setTitle:@"我是医生" forState:UIControlStateSelected];
    [_roleBtn setTitle:@"我是患者" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendCodeAction:(UIButton *)sender {
    if(![self checkCaptchasInfo]) return;
    /**
     *@Description:原开发者把验证码当做手机号发送到服务器了,现已改正  validateCodeTX->phoneNumerTX
     *@date:2015-09-23
     *@author:taller
     */
    
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
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
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
    [ValidateCodeHandler getValidateCodeWith:_phoneNumerTX.text success:^(BaseEntity *object) {
        PostCaptchasResponse *response = (PostCaptchasResponse *)object;
        if (response.success) {
            //_remainTime = response.lastTime;
            //NSLog(@"<>>>>>>>>>>>>收到额验证码>>>>>>>>>>>>%@",response.dataDic);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response.code forKey:@"CODE"];
            [userDefaults setObject:response.account forKey:@"CODEACCOUNT"];
            [self showString:@"验证码已经发送到你的手机"];
        }else{
            [self showString:response.msg];
            
        }
    } fail:^(id object) {
        [self showString:@"获取验证码失败"];
    }];
    
    //    }
    //    [self timerStart];
}
- (IBAction)registerActionh:(id)sender {
    if (![self checkRegisterInfo]) return;
    NSLog(@"<>>>>>>>>>>>何种注册>>>>>>>>>>>>");
    if(self.pushType == push_from_third_platfrom){
        ThirdRegisterEntityRequest *thirdEntity = [[ThirdRegisterEntityRequest alloc] init];
        thirdEntity.account = self.phoneNumerTX.text;
        thirdEntity.password = self.passwordTX.text;
        if(self.roleBtn.selected){
            thirdEntity.role = 1;
        }else{
            thirdEntity.role = 2;
        }
        thirdEntity.realName = self.realName;
        thirdEntity.thumb = self.thumb;
        thirdEntity.birthPlace = @"北京市";
        thirdEntity.s_token = self.uid;
        thirdEntity.sex = self.sex;
        thirdEntity.location = self.location;
        thirdEntity.education = self.education;
        [self showWithStatus:@"请稍后..."];
        [RegisterHandler thirdPlatformRegisterInfo:thirdEntity success:^(BaseEntity *object) {
            RegisterEntityResponse *response = (RegisterEntityResponse *)object;
            if (response.success) {
                [self showString:@"注册成功"];
                ThirdLoginEntity *entity = [[ThirdLoginEntity alloc] init];
                entity.account = response.dataDic[@"LOGIN_NAME"];
                entity.password = response.dataDic[@"LOGIN_PASSWORD"];
                
                [UserDefaultsUtils saveValue:entity.account forKey:Key_Account];
                [UserDefaultsUtils saveValue:self.passwordTX.text forKey:Key_Password];
                
                [LoginHandler thirdLoginRequestWithLoginInfo:entity success:^(BaseEntity *object) {
                    
                    if (object.success){
                        
                        [self pushToMainTabBarVC];
                        //[LoginHandler getAllOrgs];
                    }else{
                        
                        [self showString:object.msg];
                    }
                    
                } fail:^(id object) {
                    [self showString:@"登录失败"];
                    
                    if ([object isKindOfClass:[EMError class]])
                    {
                        EMError *error = (EMError *)object;
                        [self showString:error.description];
                    }
                }];
                
            }else{
                
                NSString *msg = @"注册失败";
                if (![Utils isBlankString:response.msg]) {
                    msg = response.msg;
                }
                [self showString:msg];
            }
            
        } fail:^(id object) {
            [self showString:@"网络异常"];
        }];
        
    }else{
        RegisterEntityRequest *entity = [[RegisterEntityRequest alloc] init];
        entity.account = self.phoneNumerTX.text;
        entity.password = self.passwordTX.text;
        if(self.roleBtn.selected){
            entity.role = 1;
        }else{
            entity.role = 2;
        }
        [RegisterHandler registerRequestWithRegisterInfo:entity success:^(BaseEntity *object) {
            RegisterEntityResponse *response = (RegisterEntityResponse *)object;
            if (response.success) {
                [self showString:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                NSString *msg = @"注册失败";
                if (![Utils isBlankString:response.msg]) {
                    msg = response.msg;
                }
                [self showString:msg];
            }
            
        } fail:^(id object) {
            [self showString:@"网络异常"];
        }];
    }
    
}

- (void)pushToMainTabBarVC
{
    MainTBViewController *tbVC = [[MainTBViewController alloc]init];
    
    [self.navigationController pushViewController:tbVC animated:YES];
}


- (IBAction)rolesAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}
- (IBAction)daGouAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}


#pragma mark - private
- (BOOL)checkRegisterInfo
{
    if ([Utils isBlankString: self.phoneNumerTX.text])
    {
        [self showString:@"用户名不能为空"];
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
    if (![regextestmobile evaluateWithObject:self.phoneNumerTX.text]){
        [self showString:@"请填写正确的手机号"];
        return NO;
    }
    if ([Utils isBlankString: self.passwordTX.text]){
        [self showString:@"密码不能为空"];
        return NO;
    }
    if ([Utils isBlankString:self.confirmPwdTX.text]) {
        [self showString:@"确认密码不能为空"];
        return NO;
    }
    if (![self.passwordTX.text isEqualToString:self.confirmPwdTX.text]) {
        [self showString:@"两次密码不一致"];
        return NO;
    }
    if(self.pushType != push_from_third_platfrom){
        if ([Utils isBlankString:self.validateCodeTX.text]) {
            [self showString:@"验证码不能为空"];
            return NO;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* code=[userDefaults objectForKey:@"CODE"];
        NSString* CODEACCOUNT=[userDefaults objectForKey:@"CODEACCOUNT"];
        if (![code compare:[self.validateCodeTX.text md532BitUpper] options:1==NSOrderedSame]) {
            [self showString:@"验证码错误"];
            return NO;
        }
        if (![CODEACCOUNT isEqualToString:self.phoneNumerTX.text]) {
            [self showString:@"请填写正确的手机号"];
            return NO;
        }
    }
    if (!_circleBtn.selected) {
        [self showString:@"请勾选用户服务协议"];
        return NO;
    }
    
    return YES;
}

- (BOOL)checkCaptchasInfo
{
    if ([Utils isBlankString:self.phoneNumerTX.text]) {
        [self showString:@"手机号码不能为空"];
        return NO;
    }
    return YES;
}

//- (void)timerStart
//{
//   _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//}
//- (void)timerAction
//{
//
//    if (_remainTime) {
//        _remainTime--;
//
//        self.sendCodeBtn.enabled = NO;
//        NSString *title = [NSString stringWithFormat:@"%ziS", _remainTime];
//        NSLog(@"%@",title);
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
- (IBAction)userProtrolAction:(id)sender
{
    UserProtrolViewController *protrol = [UserProtrolViewController simpleInstance];
    protrol.title = @"用户协议";
    [self.navigationController pushViewController:protrol animated:YES];
}

@end
