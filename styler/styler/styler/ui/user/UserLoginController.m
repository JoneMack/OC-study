//
//  UserLoginController.m
//  styler
//
//  Created by System Administrator on 13-5-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "UserLoginController.h"
#import "UserStore.h"
#import "UserRegController.h"
#import "StylerException.h"
#import "AccountSessionSpringBoard.h"
#import "ImageUtils.h"
#import "AppDelegate.h"
#import "LeveyTabBarController.h"
#import "Toast+UIView.h"
#import "HeaderView.h"
#import "UserCenterController.h"
#import "UIViewController+Custom.h"
#import "MoreController.h"
#import "EvaluationStore.h"
#import "EaseMobProcessor.h"
#import "AppClientStore.h"

@interface UserLoginController ()

@end

#define login_from_add_fav_works 3
@implementation UserLoginController
{
    HeaderView *header;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithFrom:(int)accountSessionFrom{
    self = [super init];
    if(self){
        self.accountSessionFrom = accountSessionFrom;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adaptive];
    [self initHeader];
    [self initForm];
}

-(void) initHeader{
    header = [[HeaderView alloc] initWithTitle:page_name_login navigationController:nil];
    if (self.accountSessionFrom == account_session_from_user_home) {
        header.backBut.hidden = YES;
    }else{
        [self setRightSwipeGesture];
        [header.backBut addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:header];
    
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(270, header.backBut.frame.origin.y, navigation_height, navigation_height)];
    [more setImage:[UIImage imageNamed:@"black_more_icon"] forState:UIControlStateNormal];
    [more setImage:[UIImage imageNamed:@"black_more_icon"] forState:UIControlStateHighlighted];
    [more addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:more];
}

-(void)more:(id)sender{
    MoreController *more = [[MoreController alloc] init];
    [self.navigationController pushViewController:more animated:YES];
}

-(void) initForm{
    //设置背景颜色和大小
    CGRect frame = self.loginBgView.frame;
    frame.origin.y = header.frame.size.height;
    self.loginBgView.frame = frame;
    self.loginBgView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    //设置输入文字的颜色
    self.mobileIn.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.pwdIn.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.pwdIn.delegate = self;
    
    //设置按钮
    [self.regBut setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateNormal];
    [self.regBut setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateHighlighted];

    [self.showForgetPwdViewBtn setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateNormal];
    
    self.loginBut.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
    CALayer *layer = self.loginBut.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
}

//初始化 忘记密码
-(void)initForgetPwdView
{
    self.forgetPwdViewBg.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.delegate = self;
    [self.forgetPwdViewBg addGestureRecognizer:tap];
    self.forgetTitle.textColor = [ColorUtils colorWithHexString:black_text_color];

    //设置忘记密码的wrapper
    self.wrapper.backgroundColor = [UIColor whiteColor];
    self.wrapper.clipsToBounds = YES;
    self.wrapper.alpha = 1.0;
    self.wrapper.layer.masksToBounds = YES;
    self.wrapper.layer.cornerRadius = 8.0;
    //取消按钮
    [self.cancelForgetPwdViewBtn setImage:[UIImage loadImageWithImageName:@"close_black"] forState:UIControlStateHighlighted];
    CALayer *layer = self.cancelForgetPwdViewBtn.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
    //确定按钮
    self.confirmRequestPwdBtn.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
    layer = self.confirmRequestPwdBtn.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
    //设置输入文字颜色
    self.regMobileNo.textColor = [ColorUtils colorWithHexString:black_text_color];
    //分割线
    self.spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    CGRect frame = self.spliteLine.frame;
    frame.size.height = splite_line_height;
    self.spliteLine.frame = frame;
}

//跳转到注册界面
- (IBAction)goReg:(id)sender {
    NSString *loginFrom = @"其他";
    if(self.accountSessionFrom == login_from_add_fav_works)
        loginFrom = @"收藏作品";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          loginFrom, @"来源", nil];
    [MobClick event:log_event_name_goto_reg attributes:dict];
    
    [self textViewresignFirstResponder];
    
    UserRegController *urc = [[UserRegController alloc] initWithFrom:self.accountSessionFrom];
    [self.navigationController pushViewController:urc animated:YES];
}

- (IBAction)login:(id)sender {
    if((self.mobileIn.text.length == 0 ) || (self.pwdIn.text.length == 0 )){
        [self.view makeToast:@"请输入手机号和密码" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
    }else{
        [MobClick event:log_event_name_goto_login];
        
        [SVProgressHUD showWithStatus:@"正在登录，请稍等..."];
        [[UserStore sharedStore] login:^(User *user, NSError *err) {
            if(user != nil){
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_login object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_session_update object:nil userInfo:nil
                 ];
                [EvaluationStore checkEvaluationStatus:^(NSError *error) {}];
                [EaseMobProcessor login:NO];
                [AppClientStore updateAppClient];
                [AccountSessionSpringBoard jumpToAccountSessionFrom:self accountSessionFrom:self.accountSessionFrom];
                // 提醒用户修改默认的用户名
                [self remindUserUpdateDefaultName];
                [SVProgressHUD dismiss];
            }else if(err != nil){
                [SVProgressHUD dismiss];
                StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
                [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            }
        } mobileNo:self.mobileIn.text pwd:self.pwdIn.text];
        [self textViewresignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.pwdIn resignFirstResponder];
    [self login:nil];
    return YES; 
}

//确定按钮，发送请求
- (IBAction)requestPwd:(id)sender {
    if(self.regMobileNo.text.length != 11){
        [SVProgressHUD showSuccessWithStatus:@"请输入正确的手机号码.." duration:1.0];
        return ;
    }
    [MobClick event:log_event_name_get_psw];
    
    [SVProgressHUD showWithStatus:@"正在发送，请稍等..."];
    [[UserStore sharedStore] requestTempPwd:^(NSError *err) {
        [SVProgressHUD dismiss];
        if(err == nil){
            [SVProgressHUD showSuccessWithStatus:@"已将临时密码发送到您的手机，请注意查收" duration:1.0];
            self.mobileIn.text=self.regMobileNo.text;
        }else{
            StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
            [self.forgetPwdViewBg makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
    } mobileNo:self.regMobileNo.text];
    [self textViewresignFirstResponder];
}

//忘记密码按钮
-(IBAction)toggleForgetPwdView:(id)sender{
    [MobClick event:log_event_name_forget_psw];
    [self initForgetPwdView];
    self.regMobileNo.text = self.mobileIn.text;
    self.forgetPwdViewBg.hidden = NO;
    self.regMobileNo.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.regMobileNo.keyboardAppearance = UIKeyboardAppearanceDefault;//键盘外观
    self.regMobileNo.returnKeyType = UIReturnKeySend;//键盘return键设置成 标有Send的蓝色按钮
    self.regMobileNo.keyboardType = UIKeyboardTypeNumberPad;//设置键盘只有数字输入法
    [self.view.superview.window addSubview:self.forgetPwdViewBg];
    
    CGRect frame = self.wrapper.frame;
    frame.origin.y = -self.wrapper.frame.size.height;
    self.wrapper.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.wrapper.frame;
        frame.origin.y = self.loginBgView.frame.origin.y + general_margin*2;
        self.wrapper.frame = frame;
    }];
}

//取消按钮 事件
- (IBAction)cancelForgetPwdView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.wrapper.frame;
        frame.origin.y = -self.wrapper.frame.size.height;
        self.wrapper.frame = frame;
    } completion:^(BOOL finished) {
        [self.forgetPwdViewBg setHidden:YES];
        [self.forgetPwdViewBg removeFromSuperview];
    }];
}

-(void) remindUserUpdateDefaultName {
    AppStatus *appStatus = [AppStatus sharedInstance];
    // 判断是否是快速注册用户, 如果是新注册用户，则在 "我" - "设置" - "姓名" 点亮
    if([appStatus isDefaultUserName]){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_remind_user_update_default_name object:nil];
    }

}

#pragma mark ---手势  代理------
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.regMobileNo resignFirstResponder];
    return YES;
}

-(void)popToFrontViewController:(id)sender
{
    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[UserCenterController class]]) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar.tabbarController setSelectedIndex:tabbar_item_index_work];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) viewDidUnload{
    [self setCancelForgetPwdViewBtn:nil];
    [self setForgetPwdViewBg:nil];
    [self setLoginBgView:nil];
    [self setShowForgetPwdViewBtn:nil];
    [self setLoginInfoBGImageView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString *)getPageName{
    return page_name_login;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self textViewresignFirstResponder];
}

-(void)textViewresignFirstResponder
{
    [self.pwdIn resignFirstResponder];
    [self.mobileIn resignFirstResponder];
    [self.regMobileNo resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
