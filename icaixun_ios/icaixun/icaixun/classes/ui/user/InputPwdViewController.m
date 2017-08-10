//
//  InputPwdViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define INPUT_PWD_INPUT_ROW_HEIGHT 47

#import "InputPwdViewController.h"
#import "UIView+Custom.h"
#import "UserStore.h"
#import "AccountSessionSpringBoard.h"

@interface InputPwdViewController ()


@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bodyView;
@property (nonatomic , strong) UIView *inputBlockView;
@property (nonatomic , strong) UITextField *inputFirstPwdField;
@property (nonatomic , strong) UITextField *inputSecondPwdField;
@property (nonatomic , strong) UIButton *finishBtn;

@property (nonatomic , strong) UIView *separatorLine;

@end

@implementation InputPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}


-(void) initView
{
    // 设置大背景
    UIImage *bgImg = [UIImage imageNamed:@"bg_reg_640@2x.jpg"];
    self.view.layer.contents = (id) bgImg.CGImage;
    
    // header View
    self.headerView = [[HeaderView alloc] initWithTitle:@"设置密码" navigationController:self.navigationController];
    self.headerView.needPop2Root = YES;
    [self.view addSubview:self.headerView];
    
    // body view
    self.bodyView = [[UIView alloc] init];
    self.bodyView.frame = CGRectMake(0, self.headerView.bottomY,
                                     screen_width, screen_height-self.headerView.frame.size.height);
    self.bodyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bodyView];
    
    // 设置 外层view
    self.inputBlockView = [[UIView alloc] init];
    CGRect inputBlockFrame = CGRectMake( 33, 20,screen_width -66 , 94);
    self.inputBlockView.frame = inputBlockFrame;
    
    self.inputBlockView.backgroundColor = [UIColor clearColor];
    // 设置边框
    self.inputBlockView.layer.borderWidth = border_width;
    self.inputBlockView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.inputBlockView.layer.cornerRadius = 10;
    self.inputBlockView.layer.masksToBounds = YES;
    
    [self.bodyView addSubview:self.inputBlockView];
    
    // 设置输入手机号
    self.inputFirstPwdField = [[UITextField alloc] init];
    [self.inputBlockView addSubview:self.inputFirstPwdField];
    CGRect inputMobilePhoneFrame = CGRectMake(10, 0, inputBlockFrame.size.width-20, 46);
    self.inputFirstPwdField.frame = inputMobilePhoneFrame;
    self.inputFirstPwdField.backgroundColor = [UIColor clearColor];
    self.inputFirstPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.inputFirstPwdField.font = [UIFont systemFontOfSize:14];
    self.inputFirstPwdField.textColor = [UIColor whiteColor];
    self.inputFirstPwdField.secureTextEntry = YES;
    
    // 第一根下划线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [UIColor whiteColor];
    self.separatorLine.frame = CGRectMake(0, inputMobilePhoneFrame.size.height - splite_line_height,
                                          self.inputBlockView.frame.size.width,
                                          splite_line_height);
    [self.inputBlockView addSubview:self.separatorLine];
    
    
    // 第二次密码
    self.inputSecondPwdField = [[UITextField alloc] init];
    CGRect inputSecondMobileNoField = CGRectMake(10, self.inputFirstPwdField.bottomY,
                                                 inputMobilePhoneFrame.size.width,
                                                 INPUT_PWD_INPUT_ROW_HEIGHT-5);
    self.inputSecondPwdField.frame = inputSecondMobileNoField;
    self.inputSecondPwdField.backgroundColor = [UIColor clearColor];
    self.inputSecondPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.inputSecondPwdField.font = [UIFont systemFontOfSize:14];
    self.inputSecondPwdField.textColor = [UIColor whiteColor];
    self.inputSecondPwdField.secureTextEntry = YES;
    [self.inputBlockView addSubview:self.inputSecondPwdField];
    // 完成
    self.finishBtn = [[UIButton alloc] init];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.finishBtn.frame = CGRectMake(inputBlockFrame.origin.x, self.inputBlockView.bottomY+25,
                                      inputBlockFrame.size.width, 48);
    self.finishBtn.layer.cornerRadius = 8;
    self.finishBtn.layer.masksToBounds = YES;
    self.finishBtn.backgroundColor = [UIColor whiteColor];
    [self.finishBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color] forState:UIControlStateNormal];
    self.finishBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.bodyView addSubview:self.finishBtn];
    

    [self setupEvents];
}

-(void) setupEvents
{
    [self.finishBtn addTarget:self action:@selector(finishedReg) forControlEvents:UIControlEventTouchUpInside];
}

-(void) finishedReg
{
    NSString *firstPwd = self.inputFirstPwdField.text;
    NSString *secondPwd = self.inputSecondPwdField.text;
    
    if ((firstPwd == nil || [firstPwd isEqualToString:@""]) &&
        (secondPwd == nil || [secondPwd isEqualToString:@""])) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    if (![firstPwd isEqualToString:secondPwd]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致,请重新输入"];
        return;
    }
    
    if (firstPwd.length <6) {
        [SVProgressHUD showErrorWithStatus:@"密码最少为6位"];
        return;
    }
    
    // 进行修改密码操作
    [[UserStore sharedStore] updatePwd:^(NSError *err) {
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else{
            ExceptionMsg *exception = [[err userInfo] objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:exception.message];
        }
        
        
    } userId:self.user.id pwd:firstPwd oldPwd:self.oldPwd];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
