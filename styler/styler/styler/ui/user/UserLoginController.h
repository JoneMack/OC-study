//
//  UserLoginController.h
//  styler
//
//  Created by System Administrator on 13-5-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"

@interface UserLoginController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>

//self.view
@property (nonatomic, weak) IBOutlet UITextField *pwdIn;
@property (nonatomic, weak) IBOutlet UITextField *mobileIn;
@property (weak, nonatomic) IBOutlet UIImageView *loginInfoBGImageView;
@property (weak, nonatomic) IBOutlet UIButton *showForgetPwdViewBtn;//忘记密码按钮
@property (nonatomic, weak) IBOutlet UIButton *regBut;
@property (nonatomic, weak) IBOutlet UIButton *loginBut;
//登陆页面背景色
@property (weak, nonatomic) IBOutlet UIView *loginBgView;
- (IBAction)goReg:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)toggleForgetPwdView:(id)sender;

//忘记密码的View
@property (strong, nonatomic) IBOutlet UIView *forgetPwdViewBg;
@property (weak, nonatomic) IBOutlet UIView *wrapper;
@property (weak, nonatomic) IBOutlet UILabel *forgetTitle;
@property (weak, nonatomic) IBOutlet UITextField *regMobileNo;
//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelForgetPwdViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmRequestPwdBtn;

@property (weak, nonatomic) IBOutlet UIView *spliteLine;
- (IBAction)requestPwd:(id)sender;
- (IBAction)cancelForgetPwdView:(id)sender;
@property int accountSessionFrom;
-(id) initWithFrom:(int)accountSessionFrom;

@property (nonatomic, retain) UIButton *doneButton;

@end
