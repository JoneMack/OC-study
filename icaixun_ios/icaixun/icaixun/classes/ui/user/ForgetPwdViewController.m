//
//  ForgetPwdViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/7.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "UserStore.h"
#import "ChangePwdViewController.h"

@interface ForgetPwdViewController ()

@property (strong, nonatomic) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UIView *bodyView;

@property (strong, nonatomic) IBOutlet UITextField *mobileNoField;

@property (strong, nonatomic) IBOutlet UILabel *promptLabel;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)nextStep:(id)sender;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *bgImg = [UIImage imageNamed:@"bg_reg_640@2x.jpg"];
    self.view.layer.contents = (id) bgImg.CGImage;
    
    [self setRightSwipeGestureAndAdaptive];
    
    self.headerView = [[HeaderView alloc] initWithTitle:@"找回密码" navigationController:self.navigationController];
    
    [self.view addSubview:self.headerView];
    
    [self.bodyView setBackgroundColor:[UIColor clearColor]];
    
    self.mobileNoField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入手机号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.mobileNoField setBackgroundColor:[UIColor clearColor]];
    self.mobileNoField.layer.borderWidth = border_width;
    self.mobileNoField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.mobileNoField.layer.cornerRadius = 5;
    self.mobileNoField.layer.masksToBounds = YES;
    self.mobileNoField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.promptLabel.numberOfLines=0;
    [self.promptLabel sizeToFit];
    [self.promptLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
    
    [self.nextBtn setBackgroundColor:[UIColor whiteColor]];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    [self.nextBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)nextStep:(id)sender {
    
    NSString *mobileNo = self.mobileNoField.text;
    if (mobileNo == nil || mobileNo.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:network_status_loading];
    [[UserStore sharedStore] getTempPwd:^(NSError *err) {
        [SVProgressHUD dismiss];
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:@"验证码已发出，请查收"];
            ChangePwdViewController *changePwdController = [[ChangePwdViewController alloc] init];
            changePwdController.env = @"outer";
            [self.navigationController pushViewController:changePwdController animated:YES];
        }else{
            ExceptionMsg *msg = [err.userInfo objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:msg.message];
        }
    } mobileNo:mobileNo];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
