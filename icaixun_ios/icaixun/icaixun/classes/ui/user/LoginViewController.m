//
//  LoginViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define AVATAR_MARGIN_TOP 6
#define LOGIN_AVATAR_WIDTH 86
#define LOGIN_AVATAR_HEIGHT 86

#import "LoginViewController.h"
#import "UIView+Custom.h"
#import "RegisterController.h"
#import "UserStore.h"
#import "IcxTabbar.h"
#import "AppDelegate.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()


@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *pwd;

@property (nonatomic , strong) UIView *bodyView;

@property (nonatomic , strong) UIImageView *userAvatarView;
@property (nonatomic , strong) UIView *inputBlockView;

@property (nonatomic , strong) UIImageView *userNameIconView;
@property (nonatomic , strong) UIImageView *pwdIconView;

@property (nonatomic , strong) UITextField *userNameField;
@property (nonatomic , strong) UITextField *pwdFeild;
@property (nonatomic , strong) UIButton *loginBtn;

@property (nonatomic , strong) UILabel *forgetPwdLabel;
@property (nonatomic , strong) UILabel *registerLabel;

@property (nonatomic , strong) UIView *separatorLine;
@property (nonatomic , strong) LineDashView *dashLine;


@end


@implementation LoginViewController

-(instancetype) initWithAccountSessionFrom:(int)accountSessionFrom
{
    self = [super init];
    if (self) {
        self.accountSessionFrom = accountSessionFrom;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppStatus *appStatus = [AppStatus sharedInstance];
    if ([appStatus logined]) {
        self.icxTabbar = [[IcxTabbar alloc] init];
        [self.navigationController pushViewController:self.icxTabbar.tabbarController animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}


-(void) initView
{
    
    // 设置大背景
    UIImage *bgImg = [UIImage imageNamed:@"bg_reg_640@2x.jpg"];
    self.view.layer.contents = (id) bgImg.CGImage;
    
    // body view
    self.bodyView = [[UIView alloc] init];
    self.bodyView.frame = CGRectMake(0, 36,
                                     screen_width, screen_height);
    self.bodyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bodyView];
    
    
    // avatar
    self.userAvatarView = [[UIImageView alloc] init];
    CGRect avatarFrame = CGRectMake((screen_width - LOGIN_AVATAR_WIDTH)/2, AVATAR_MARGIN_TOP, LOGIN_AVATAR_WIDTH, LOGIN_AVATAR_HEIGHT);
    [self.userAvatarView setImage:[UIImage imageNamed:@"logo_108"]];
    self.userAvatarView.frame = avatarFrame;
    self.userAvatarView.layer.masksToBounds = YES;
    self.userAvatarView.layer.cornerRadius = 42;
    self.userAvatarView.layer.borderWidth = 2;
    self.userAvatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.bodyView addSubview:self.userAvatarView];
    
    // input block view
    self.inputBlockView = [[UIView alloc] init];
    CGRect inputBlockFrame = CGRectMake( 33, self.userAvatarView.bottomY + 30 ,screen_width - 66 , 94);
    self.inputBlockView.frame = inputBlockFrame;
    
    self.inputBlockView.backgroundColor = [UIColor clearColor];
    // 设置边框
    self.inputBlockView.layer.borderWidth = border_width;
    self.inputBlockView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.inputBlockView.layer.cornerRadius = 10;
    self.inputBlockView.layer.masksToBounds = YES;
    [self.bodyView addSubview:self.inputBlockView];
    
    // 用户名 icon
    self.userNameIconView = [[UIImageView alloc] init];
    [self.userNameIconView setImage:[UIImage imageNamed:@"icon_username"]];
    CGRect usernameIconFrame = CGRectMake( 10, 15, 16, 16);
    self.userNameIconView.frame = usernameIconFrame;
    [self.inputBlockView addSubview:self.userNameIconView];
    
    // 输入用户名
    self.userNameField = [[UITextField alloc] init];
    CGRect userNameFieldFrame = CGRectMake( self.userNameIconView.rightX + 10,0, inputBlockFrame.size.width - 46 , 47 );
    self.userNameField.frame = userNameFieldFrame;
    self.userNameField.placeholder = @"手机号";
    self.userNameField.font = [UIFont systemFontOfSize:13];
    // 设置数字键
    [self.userNameField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.inputBlockView addSubview:self.userNameField];
    
    // 横线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [UIColor whiteColor];
    self.separatorLine.frame = CGRectMake(0, userNameFieldFrame.size.height - splite_line_height,
                                          self.inputBlockView.frame.size.width,
                                          splite_line_height);
    [self.inputBlockView addSubview:self.separatorLine];
    
    // 密码 icon
    self.pwdIconView = [[UIImageView alloc] init];
    [self.pwdIconView setImage:[UIImage imageNamed:@"icon_password"]];
    CGRect pwdIconFrame = CGRectMake( 10, self.separatorLine.bottomY +15 , 16, 16);
    self.pwdIconView.frame = pwdIconFrame;
    [self.inputBlockView addSubview:self.pwdIconView];
    
    // 输入密码
    self.pwdFeild = [[UITextField alloc] init];
    CGRect pwdFieldFrame = CGRectMake(self.pwdIconView.rightX + 10, self.userNameField.bottomY,
                                      inputBlockFrame.size.width - 46 , 47 );
    self.pwdFeild.frame = pwdFieldFrame;
    self.pwdFeild.placeholder = @"密码";
    [self.pwdFeild setSecureTextEntry:YES];
    self.pwdFeild.font = [UIFont systemFontOfSize:13];
    [self.inputBlockView addSubview:self.pwdFeild];
    
    // 登录
    self.loginBtn = [[UIButton alloc] init];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.frame = CGRectMake(inputBlockFrame.origin.x, self.inputBlockView.bottomY+25,
                                     inputBlockFrame.size.width, 48);
    self.loginBtn.layer.cornerRadius = 8;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.backgroundColor = [UIColor whiteColor];
    [self.loginBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.bodyView addSubview:self.loginBtn];
    
    
    // 忘记密码
    self.forgetPwdLabel = [[UILabel alloc] init];
    [self.forgetPwdLabel setText:@"忘记密码 ?"];
    [self.forgetPwdLabel setTextColor:[UIColor whiteColor]];
    [self.forgetPwdLabel setFont:[UIFont systemFontOfSize:12]];
    CGRect forgetPwdLabelFrame = CGRectMake(40, self.loginBtn.bottomY+18, 59, 15);
    self.forgetPwdLabel.frame = forgetPwdLabelFrame;
    self.forgetPwdLabel.userInteractionEnabled = YES;
    [self.bodyView addSubview:self.forgetPwdLabel];
    
    // 横线
    CGRect dashLineFrame = CGRectMake(self.forgetPwdLabel.frame.origin.x,
                                      self.forgetPwdLabel.bottomY+5,
                                      self.forgetPwdLabel.frame.size.width,
                                      splite_line_height);
    self.dashLine = [[LineDashView alloc] initWithFrame:dashLineFrame
                                        lineDashPattern:@[@5, @5]
                                              endOffset:0.495];
    self.dashLine.backgroundColor = [UIColor whiteColor];
    [self.bodyView addSubview:self.dashLine];
    
    //注册
    self.registerLabel = [[UILabel alloc] init];
    [self.registerLabel setText:@"注册用户"];
    [self.registerLabel setTextColor:[UIColor whiteColor]];
    [self.registerLabel setFont:[UIFont systemFontOfSize:12]];
    CGRect registerLabelFrame = CGRectMake(self.loginBtn.rightX - 65, self.loginBtn.bottomY+18, 50, 15);
    self.registerLabel.frame = registerLabelFrame;
    self.registerLabel.userInteractionEnabled = YES;
    [self.bodyView addSubview:self.registerLabel];
    
    // 横线
    dashLineFrame = CGRectMake(self.registerLabel.frame.origin.x,
                               self.registerLabel.bottomY+5,
                               self.registerLabel.frame.size.width,
                               splite_line_height);
    self.dashLine = [[LineDashView alloc] initWithFrame:dashLineFrame
                                        lineDashPattern:@[@5, @5]
                                              endOffset:0.495];
    self.dashLine.backgroundColor = [UIColor whiteColor];
    [self.bodyView addSubview:self.dashLine];
    
    self.userNameField.delegate = self;
    self.pwdFeild.delegate = self;
    
    [self setupEvents];
    
}

-(void) setupEvents
{
    // 注册添加点击事件
    UITapGestureRecognizer *regTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regUser)];
    [self.registerLabel addGestureRecognizer:regTapGestureRecognizer];
    
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 注册添加点击事件
    UITapGestureRecognizer *forgetPwdTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPwd)];
    [self.forgetPwdLabel addGestureRecognizer:forgetPwdTapGestureRecognizer];
}

#pragma mark 监听 输入框 输入内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.userNameField == textField) {
        if (textField.text.length > 10) {
            NSString *username = self.userNameField.text;
            username = [username substringToIndex:10];
            self.userNameField.text = username;
        }
    }else if (self.pwdFeild == textField) {
        if (textField.text.length >= 20){
            
        }
    }
    return YES;
}

#pragma mark - 触摸事件使键盘失去第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.pwdFeild == textField) {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark 跳转到注册界面
-(void) regUser
{
    RegisterController *registerController = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

#pragma mark 忘记密码
-(void) forgetPwd
{
    ForgetPwdViewController *forgetController = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetController animated:YES];
}

#pragma mark 登录
-(void) login
{
    NSString *loginMobileNo = self.userNameField.text;
    NSString *pwd = self.pwdFeild.text;
    
    if (loginMobileNo == nil || loginMobileNo.length == 0) {
        [self.view makeToast:@"用户名不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    if (pwd == nil || pwd.length == 0) {
        [self.view makeToast:@"密码不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    [[UserStore sharedStore] login:^(User *user, NSError *err) {
        if (err == nil) {
            IcxTabbar *icxTabbar = [[IcxTabbar alloc] init];
            [self.navigationController pushViewController:icxTabbar.tabbarController animated:NO];
        }else{
            ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:exception.message];
        }
    } mobileNo:loginMobileNo pwd:pwd];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.pwdFeild.text = @"";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
