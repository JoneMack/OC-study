//
//  UserFirstLoginController.m
//  styler
//
//  Created by System Administrator on 13-5-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define reset_second 60
#define view_offset_for_input 45

#import "UserFirstLoginController.h"
#import "UserStore.h"
#import "StylerException.h"
#import "AccountSessionSpringBoard.h"
#import "Toast+UIView.h"
#import "PushProcessor.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"
#import "EaseMobProcessor.h"

@interface UserFirstLoginController ()

@end

@implementation UserFirstLoginController
{
    HeaderView *header;
    UISwipeGestureRecognizer *swip;
}
@synthesize lable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isAllowSwapPop = YES;
        lable.textColor = [ColorUtils colorWithHexString:gray_text_color];
        lable.font = [UIFont boldSystemFontOfSize:15.0];
        [self.view addSubview:lable];
    }
    return self;
}

-(void)popView:(UISwipeGestureRecognizer* )sender
{
    if (self.resetSecond != 0) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(id) initWithFrom:(int)from{
    self = [super init];
    if(self){
        self.accountSessionFrom = from;
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

-(void)initHeader
{    
    header = [[HeaderView alloc] initWithTitle:page_name_first_login navigationController:self.navigationController];
    [self.view addSubview:header];
    [header.backBut addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    //设置整个view的背景
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    swip = [[UISwipeGestureRecognizer  alloc] initWithTarget:self action:@selector(popView:)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swip];
}

-(void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化正文
-(void) initForm{
    self.noteTxt.font = [UIFont boldSystemFontOfSize:15.0];
    self.noteTxt.textColor = [ColorUtils colorWithHexString:gray_text_color];
    
    self.pwdIn.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.pwdIn.secureTextEntry = YES;
    self.pwdIn.delegate = self;
    
    self.stayup = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    self.submitBut.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
    CALayer *layer = self.submitBut.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
    [self initResendBut];
}

-(void) initResendBut{
    
    self.isAllowSwapPop = NO;
    self.resetSecond = reset_second;
    self.resendBut.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self disableResendBut];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateResendBut) userInfo:nil repeats:YES];
}
//设置 重新发送
-(void) enableResendBut{
    [self.timer invalidate];
    self.timer = nil;
    [self.resendBut setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.resendBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resendBut.enabled = YES;
    [self.resendBut setBackgroundImage:[UIImage loadImageWithImageName:@"rg_button_default"] forState:UIControlStateNormal];
    [self.resendBut setBackgroundImage:[UIImage loadImageWithImageName:@"rg_button_selected"] forState:UIControlStateHighlighted];
}

-(void) disableResendBut{
    self.resendBut.enabled = NO;
    [self.resendBut setTitle:@"" forState:UIControlStateNormal];
    [self.resendBut setTitleColor:[ColorUtils colorWithHexString:light_gray_text_color] forState:UIControlStateNormal];
    [self.resendBut setBackgroundImage:[UIImage loadImageWithImageName:@"request_again"] forState:UIControlStateNormal];
    lable.text = [NSString stringWithFormat:@"%d秒重发", self.resetSecond];
}

-(void) updateResendBut{
    self.resetSecond = self.resetSecond - 1;
    if(self.resetSecond == 0){
        self.isAllowSwapPop = YES;
        //[self.leftBtn setEnabled:YES];
        self.resendBut.titleLabel.text = @"重新发送";
        lable.hidden = YES;
        [self enableResendBut];
        header.backBut.hidden = NO;
    }else{
        lable.hidden = NO;
        [self disableResendBut];
        header.backBut.hidden = YES;
    }
}
//注册是否成功
- (IBAction)submitFirstLogin:(id)sender {
    if([self.pwdIn.text isEqualToString:@""]){
        [self.view makeToast:@"请输入初始密码！" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return ;
    }else{
        [self.pwdIn resignFirstResponder];
        [MobClick event:log_event_name_check_active_code];
        [SVProgressHUD showWithStatus:@"处理中，请稍等..." maskType:SVProgressHUDMaskTypeBlack];
        UserStore *userStore = [UserStore sharedStore];
        [userStore firstLogin:^(User *user, NSError *err) {
            [SVProgressHUD dismiss];
            if(user != nil){
                NSLog(@"_____________%@",user);
                [AppStatus sharedInstance].user = user;
                [AppStatus saveAppStatus];
                [SVProgressHUD dismiss];
                [self localPushForFeedback];
                
                [EaseMobProcessor login:NO];
                
                [AccountSessionSpringBoard jumpToAccountSessionFrom:self accountSessionFrom:self.accountSessionFrom];
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_login object:nil];
                
                
                [SVProgressHUD dismiss];
            }else if(err != nil){
                StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
                [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            }
        } userId:[[AppStatus sharedInstance].user.idStr intValue] initPwd:self.pwdIn.text];
    }
}

- (IBAction)republishInitPwd:(id)sender{
    [self.pwdIn resignFirstResponder];
    [SVProgressHUD showWithStatus:@"正在发送，请稍等..." maskType:SVProgressHUDMaskTypeBlack];
    UserStore *userStore = [UserStore sharedStore];
    [userStore republishInitPwd:^(NSError *err) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功，请注意查收!" duration:1.0];
        [self initResendBut];
    } userId:[[AppStatus sharedInstance].user.idStr intValue]];
}

- (void)localPushForFeedback
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      @"查看",@"action-loc-key",@"时尚猫:您好，我是客服猫猫，有什么需要帮助的请随时联系我。\n",@"body", nil],
                                                                      @"alert",@"3",@"badge",@"bingbong.aiff",@"sound", nil],
                                                                      @"aps",@"3",@"nt",@"-1",@"sn", nil];
    
    PushRecord *pushRecord = [PushRecord readFromNotification:dic];
    PushProcessor *pushProcessor = [PushProcessor sharedInstance];
    [pushProcessor addUnreadPush:pushRecord];
    [pushProcessor processPush:pushRecord comingFrom:push_from_receive_from_active_app naviagtionController:self.navigationController];
}

-(void) viewTapped:(id)sender{
    [self.pwdIn resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.stayup = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.stayup = NO;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    NSDictionary* info = [aNotification userInfo];
    //get keyboard size
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //adjust ui elements postition here
    if (kbSize.height == view_offset_for_input)
    {
        CGRect rect = self.view.frame;
        rect.origin.y = 0-view_offset_for_input;
        self.view.frame = rect;
    }
    else if(kbSize.height == view_offset_for_input)
    {
        CGRect rect = self.view.frame;
        rect.origin.y = 0-view_offset_for_input;
        self.view.frame = rect;
    }
    
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pwdIn resignFirstResponder];
}

-(void) webRequestError:(NSNotification *)notification{
    [self.view makeToast:@"网络异常，请稍后再试" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
}

-(void) viewDidUnload{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate{
    return NO;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        return YES;
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(NSString *)getPageName{
    return page_name_first_login;
}


//处理屏蔽Button事件
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{    
    if([touch.view isKindOfClass:[HeaderView class]])
    {
        return NO;
    }
    return YES;
}


@end
