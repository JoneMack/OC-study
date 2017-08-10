//
//  SetPwdController.m
//  styler
//
//  Created by System Administrator on 13-5-22.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SetPwdController.h"
#import "UserStore.h"
#import "StylerException.h"
#import "ImageUtils.h"
#import "Toast+UIView.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"
#import "EaseMobProcessor.h"

@interface SetPwdController ()

@end

@implementation SetPwdController
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

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initInput];
}

-(void)initHeader
{
    header = [[HeaderView alloc]initWithTitle:page_name_setting_pwd navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void) initInput{
    self.changePwdView.frame = CGRectMake(self.changePwdView.frame.origin.x,header.frame.size.height +general_margin , self.changePwdView.frame.size.width, self.changePwdView.frame.size.height);
    self.saveBut.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
    CALayer *layer = self.saveBut.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
    CGRect btnFrame = self.saveBut.frame;
    btnFrame.origin.y = self.changePwdView.frame.origin.y + self.changePwdView.frame.size.height + general_margin;
    self.saveBut.frame = btnFrame;
    
    CGRect frame1 = self.line1.frame;
    frame1.size.height =  splite_line_height;
    self.line1.frame = frame1;
    self.line1.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    CGRect frame2 = self.line2.frame;
    frame2.size.height =  splite_line_height;
    self.line2.frame = frame2;
    self.line2.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    CGRect frame3 = self.line3.frame;
    frame3.size.height =  splite_line_height;
    self.line3.frame = frame3;
    self.line3.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    CGRect frame4 = self.line4.frame;
    frame4.size.height =  splite_line_height;
    self.line4.frame = frame4;
    self.line4.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
}

- (IBAction)savePwd:(id)sender {
    if([self.oldPwdIn.text isEqualToString:@""]
       || [self.pwdIn.text isEqualToString:@""]
       || [self.confirmPwdIn.text isEqualToString:@""]){
        return ;
    }
    if (![self.confirmPwdIn.text isEqualToString:self.pwdIn.text]) {
        [self.view makeToast:@"新密码不一致，请重新输入" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return ;
    }
    [MobClick event:log_event_name_submit_new_psw ];
    
    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."];
    AppStatus *as = [AppStatus sharedInstance];
    [[UserStore sharedStore] updatePwd:^(NSError *err) {
        [SVProgressHUD dismiss];
        if(err == nil){
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功！"];
            as.easeMobLogined = NO;
            [EaseMobProcessor login:NO];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
            [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
    } userId:as.user.idStr pwd:self.pwdIn.text oldPwd:self.oldPwdIn.text];
}

-(void)textViewResignFirstResponder
{
    [self.oldPwdIn resignFirstResponder];
    [self.pwdIn resignFirstResponder];
    [self.confirmPwdIn resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self textViewResignFirstResponder];
}

-(NSString *)getPageName{
    return page_name_setting_pwd;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
