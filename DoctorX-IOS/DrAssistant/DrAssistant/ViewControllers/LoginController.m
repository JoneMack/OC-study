//
//  LoginController.m
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "LoginController.h"
#import "LoginHandler.h"
#import "MainTBViewController.h"
#import "UserDefaultsUtils.h"
#import "AccountViewController.h"
#import "MyClubViewController.h"
#import "ChatListViewController.h"
#import "MyDoctorViewController.h"
#import "MyTongHangController.h"
#import "MyPatientController.h"
#import "MyAssistantController.h"
#import "MyTongHangController.h"
#import "MyPAccountController.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsData.h"
#import "UMSocialSnsService.h"
#import "UMSocialAccountManager.h"
#import "MessageHandler.h"
#import "RegisterViewController.h"
#import "RegisterHandler.h"
#import "PostCaptchasResponse.h"
#import "RegisterEntityResponse.h"
#import "ThirdLoginEntity.h"
@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextFD;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFD;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiBoLoginBtn;

@end

@implementation LoginController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.loginBtn.userInteractionEnabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideLeftBtn];
    
    [self.view setBackgroundColor:[UIColor defaultBgColor]];
    [self.registerBtn setTitleColor:[UIColor defaultFontColor_DarkGray] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.findPwdBtn setTitleColor:[UIColor defaultFontColor_DarkGray] forState:UIControlStateNormal];
    [self.weixinLoginBtn setTitleColor:[UIColor defaultFontColor_DarkGray] forState:UIControlStateNormal];
    [self.weiBoLoginBtn setTitleColor:[UIColor defaultFontColor_DarkGray] forState:UIControlStateNormal];
    [self.QQLoginBtn setTitleColor:[UIColor defaultFontColor_DarkGray] forState:UIControlStateNormal];
    
    UIImage *loginBg = [UIImage imageNamed:@"sign_navbg.png"];
    loginBg = [loginBg stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.loginBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    
    self.phoneNumTextFD.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextFD.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTextFD.leftView = [self leftViewofImage:@"sign_user.png"];
    self.pwdTextFD.leftView = [self leftViewofImage:@"sign_password.png"];
    
//    UIImage *tx_bg = [UIImage imageNamed:@"input.png"];
//    tx_bg = [tx_bg stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//    self.phoneNumTextFD.background = tx_bg;
//    self.pwdTextFD.background = tx_bg;
    
    
    self.phoneNumTextFD.text = [UserDefaultsUtils valueWithKey:Key_Account];
    self.pwdTextFD.text = [UserDefaultsUtils valueWithKey:Key_Password];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - respone method
- (IBAction)registrAction:(id)sender {
//    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>点击了注册按钮");
}

- (IBAction)findPwd:(UIButton *)sender {
}
- (IBAction)loginAction:(UIButton *)sender {
    
    LoginEntity *entity = [[LoginEntity alloc] init];
    entity.account = self.phoneNumTextFD.text;
    entity.password = self.pwdTextFD.text;
    [UserDefaultsUtils saveValue:entity.account forKey:Key_Account];
    [UserDefaultsUtils saveValue:entity.password forKey:Key_Password];
    
    if (![self checkLoginInfo: entity]) return;
   
    [self showWithStatus:@"请稍后..."];
    [self easeMobLogin:entity];
    self.loginBtn.userInteractionEnabled = NO;
            //[LoginHandler getAllOrgs];
}
-(void)easeMobLogin:(LoginEntity*)entity{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername: entity.account
                                                        password: EM_PSWD
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             [self login:entity];
             
         }else{
             //挤掉已登陆账号
             if (error.errorCode==1009) {
                 [self login:entity];
             }else{
                 [self showString:@"登录失败"];
             }
             self.loginBtn.userInteractionEnabled = YES;
         }
     } onQueue:nil];

}
-(void)login:(LoginEntity*)entity{
    [LoginHandler loginRequestWithLoginInfo:entity success:^(BaseEntity *object) {
        if (object.success){
            [self pushToMainTabBarVC];
        }else{
            [self showString:object.msg];
            self.loginBtn.userInteractionEnabled = YES;
        }
        } fail:^(id object) {
            [self showString:@"登录失败"];
            
            if ([object isKindOfClass:[EMError class]])
            {
                EMError *error = (EMError *)object;
                [self showString:error.description];
            }
            self.loginBtn.userInteractionEnabled = YES;
        }];
}

#pragma mark - private
- (BOOL)checkLoginInfo:(LoginEntity *)entity
{
    if ([Utils isBlankString: entity.account])
    {
        [self showString:@"用户名不能为空"];
        return NO;
    }
    
    if ([Utils isBlankString: entity.password])
    {
        [self showString:@"密码不能为空"];
        return NO;
    }
    
    return YES;
}


- (UIView *)leftViewofImage:(NSString *)imageName
{
    UIView *view = [[UIView alloc] init];
    
    UIImage *leftPhone = [UIImage imageNamed:imageName];
    UIImageView *phone = [[UIImageView alloc] initWithImage:leftPhone];
   
    view.frame = CGRectMake(0, 0, leftPhone.size.width*2, leftPhone.size.height);
    phone.frame = CGRectMake(0, 0, leftPhone.size.width, leftPhone.size.height);
    phone.center = CGPointMake(view.frame.size.width/2, phone.center.y);
    [view addSubview: phone];
    
    return view;
}


- (void)pushToMainTabBarVC
{
    MainTBViewController *tbVC = [[MainTBViewController alloc]init];
    
    [self.navigationController pushViewController:tbVC animated:YES];
}


#pragma mark - third login method

- (IBAction)weixinLoginBtnClick:(id)sender {
    NSLog(@">>>>>>>>>>>>微信登陆");
    [self loginByPlatform:UMShareToWechatSession];
}

- (IBAction)qqLoginBtnClick:(id)sender {
    NSLog(@">>>>>>>>>>>>qq登陆");
    [self loginByPlatform:UMShareToQQ];
}

- (IBAction)sinaWeiBoLoginBtnClick:(id)sender {
    NSLog(@">>>>>>>>>>>>新浪微博登陆");
    [self loginByPlatform:UMShareToSina];
}

-(void)loginByPlatform:(NSString *)platformName{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //获取用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];

            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *response) {
                NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>%@",response);
                // 打印用户昵称
                NSLog(@"user name is %@", [[[response.data objectForKey:@"accounts"]objectForKey:platformName] objectForKey:@"username"]);
                NSString *username = [[[response.data objectForKey:@"accounts"]objectForKey:platformName] objectForKey:@"username"];
                NSString *avatarImgIconUrl = [[[response.data objectForKey:@"accounts"]objectForKey:platformName] objectForKey:@"icon"];
                NSString *uid = [[[response.data objectForKey:@"accounts"]objectForKey:platformName] objectForKey:@"usid"];
                int sex = [[[[response.data objectForKey:@"accounts"]objectForKey:platformName] objectForKey:@"gender"] intValue];
                NSString *edu = [[[response.data objectForKey:@"accounts"]objectForKey:platformName] objectForKey:@"education"];
                NSString *location;
                if ([platformName isEqualToString:UMShareToWechatSession]) {
                    location = [[[response.data objectForKey:@"accounts"]objectForKey:platformName] objectForKey:@"location"];
                }else{
                    location = @"";
                }
             
                
                [RegisterHandler getUserInfoByUid:uid success:^(BaseEntity *object) {
                    RegisterEntityResponse *response = (RegisterEntityResponse *)object;
                    NSLog(@">>>>>>>>>>是否存在用户>>>>>>>%@",response.dataDic);
                    if (response.dataDic != nil) {
                        ThirdLoginEntity *entity = [[ThirdLoginEntity alloc] init];
                        entity.account = response.dataDic[@"LOGIN_NAME"];
                        entity.password = response.dataDic[@"LOGIN_PASSWORD"];
                        
                        [UserDefaultsUtils saveValue:entity.account forKey:Key_Account];
//                        [UserDefaultsUtils saveValue:entity.password forKey:Key_Password];
                        
                        [LoginHandler thirdLoginRequestWithLoginInfo:entity success:^(BaseEntity *object) {
                            
                            if (object.success){
                                
                                [self pushToMainTabBarVC];
                                [LoginHandler getAllOrgs];
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
                        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        RegisterViewController* destinationViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"register"];
                        destinationViewController.pushType = push_from_third_platfrom;
                        destinationViewController.realName = username;
                        destinationViewController.thumb = avatarImgIconUrl;
                        destinationViewController.uid = uid;
                        destinationViewController.sex = sex;
                        destinationViewController.location = location;
                        destinationViewController.education = edu;
                        [self.navigationController pushViewController:destinationViewController animated:YES];
                    }
                } fail:^(id object) {
                    [self showString:@"授权失败"];
                }];
            }];
        }});
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
