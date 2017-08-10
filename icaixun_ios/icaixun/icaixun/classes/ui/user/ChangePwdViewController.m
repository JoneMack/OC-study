//
//  ChangePwdViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/7.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "UserStore.h"

@interface ChangePwdViewController ()

@property (strong, nonatomic) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UIView *bodyView;

@property (strong, nonatomic) IBOutlet UIView *blockView;

@property (strong, nonatomic) IBOutlet UITextField *oldPwdField;

@property (strong, nonatomic) IBOutlet UITextField *firstPwdField;

@property (strong, nonatomic) IBOutlet UITextField *secondPwdField;

@property (strong, nonatomic) IBOutlet UIButton *finishBtn;

@property (strong, nonatomic) UIView *separatorLine;


- (IBAction)finished:(id)sender;


@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    
    UIImage *bgImg = [UIImage imageNamed:@"bg_reg_640@2x.jpg"];
    self.view.layer.contents = (id) bgImg.CGImage;
    
    NSLog(@"self navigation:%@" ,self.navigationController);
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"修改密码"
                                   navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    
    self.separatorLine = [UIView new];
    self.separatorLine.frame = CGRectMake(0, 45, self.blockView.frame.size.width,
                                          border_width);
    if ([self.env isEqualToString:@"outer"]) {
        [self.separatorLine setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:light_gray_text_color]];
    }
    
    [self.blockView addSubview:self.separatorLine];
    
    
    self.separatorLine = [UIView new];
    self.separatorLine.frame = CGRectMake(0, 90, self.blockView.frame.size.width,
                                          border_width);
    [self.separatorLine setBackgroundColor:[UIColor whiteColor]];
    if ([self.env isEqualToString:@"outer"]) {
        [self.separatorLine setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:light_gray_text_color]];
    }
    
    [self.blockView addSubview:self.separatorLine];
    
    self.oldPwdField.secureTextEntry = YES;
    self.firstPwdField.secureTextEntry = YES;
    self.secondPwdField.secureTextEntry = YES;
    
    self.finishBtn.layer.cornerRadius = 8;
    self.finishBtn.layer.masksToBounds = YES;
    
    self.blockView.layer.borderWidth = border_width;
    
    if ([self.env isEqualToString:@"outer"]) {  // 外部修改密码，用户还没有登录成功
        [self.bodyView setBackgroundColor:[UIColor clearColor]];
        [self.blockView setBackgroundColor:[UIColor clearColor]];
        [self.oldPwdField setBackgroundColor:[UIColor clearColor]];
        [self.firstPwdField setBackgroundColor:[UIColor clearColor]];
        [self.secondPwdField setBackgroundColor:[UIColor clearColor]];
        
        self.oldPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"临时密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        self.firstPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"新密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        self.secondPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认新密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        self.blockView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        [self.finishBtn setBackgroundColor:[UIColor whiteColor]];
        [self.finishBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateNormal];
        
        
    }else if ([self.env isEqualToString:@"inner"]){
        [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
        [self.bodyView.layer setBorderColor:[[ColorUtils colorWithHexString:orange_red_line_color] CGColor]];
        
        self.oldPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"旧密码" attributes:@{NSForegroundColorAttributeName: [ColorUtils colorWithHexString:gray_text_color]}];
        
        self.firstPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"新密码" attributes:@{NSForegroundColorAttributeName: [ColorUtils colorWithHexString:gray_text_color]}];
        
        self.secondPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认新密码" attributes:@{NSForegroundColorAttributeName: [ColorUtils colorWithHexString:gray_text_color]}];
        
        self.blockView.layer.borderColor = [[ColorUtils colorWithHexString:orange_red_line_color] CGColor];
        
        [self.finishBtn setBackgroundColor:[ColorUtils colorWithHexString:orange_red_line_color]];
        [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    self.blockView.layer.cornerRadius = 8;
    self.blockView.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)finished:(id)sender {
    
    NSString *oldPwd = self.oldPwdField.text;
    NSString *firstPwd = self.firstPwdField.text;
    NSString *secondPwd = self.secondPwdField.text;
    
    if (oldPwd == nil || [oldPwd isEqualToString:@""]) {
        if ([self.env isEqualToString:@"outer"]) {
            [self.view makeToast:@"临时密码不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }else if ([self.env isEqualToString:@"outer"]) {
            [self.view makeToast:@"旧密码不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
    }
    
    if(firstPwd == nil || firstPwd.length <6 || secondPwd == nil || secondPwd.length < 6){
        [self.view makeToast:@"新密码至少为6位" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    if (![firstPwd isEqualToString:secondPwd]) {
        [self.view makeToast:@"两次新密码输入不一致" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    if ([self.env isEqualToString:@"outer"]){
        
        [[UserStore sharedStore] updatePwd:^(NSError *err) { 
            if (err == nil){
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
                [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            }
        } mobileNo:self.mobileNo pwd:firstPwd oldPwd:oldPwd];
        
    }else if ([self.env isEqualToString:@"inner"]){
        
        [[UserStore sharedStore] updatePwd:^(NSError *err) {
            if (err == nil){
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
                [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            }
        } userId:self.userId pwd:firstPwd oldPwd:oldPwd];
        
    }
    
    
    
}
@end
