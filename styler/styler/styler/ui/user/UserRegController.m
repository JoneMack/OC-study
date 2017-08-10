//
//  UserRegController.m
//  styler
//
//  Created by System Administrator on 13-5-14.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "UserRegController.h"
#import "UserStore.h"
#import "StylerException.h"
#import "UserFirstLoginController.h"
#import "UserLoginController.h"
#import "DeviceUtils.h"
#import "ImageUtils.h"
#import "Toast+UIView.h"
#import "PushProcessor.h"
#import "SocialShareStore.h"
#import "UIViewController+Custom.h"
#import "ShareContent.h"
#import "ShareSDKProcessor.h"

@interface UserRegController ()

@end

@implementation UserRegController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [self setRightSwipeGestureAndAdaptive];


    [self initHeader];
    [self initForm];
    [self initSocialView];
}
//初始化头部
-(void)initHeader
{
    self.header = [[HeaderView alloc] initWithTitle:page_name_reg navigationController:self.navigationController];
    [self.view addSubview:self.header];
    //设置整个view的背景
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

//初始化中间内容
-(void) initForm{
    CGRect frame = self.userInfoWrapper.frame;
    frame.origin.y = self.header.frame.size.height + general_margin;
    self.userInfoWrapper.frame = frame;
    //输入文字颜色
    self.nameIn.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.mobileIn.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.nameIn.delegate = self;
    self.mobileIn.delegate = self;
    
    //注册按钮
//    [self.submitBut setBackgroundImage:[UIImage loadImageWithImageName:@"rg_button_default"] forState:UIControlStateNormal];
//    [self.submitBut setBackgroundImage:[UIImage loadImageWithImageName:@"rg_button_selected"] forState:UIControlStateSelected];
    frame = self.submitBut.frame;
    frame.origin.y = bottomY(self.userInfoWrapper) + general_margin + general_padding;
    self.submitBut.frame = frame;
    self.submitBut.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
    self.stayup = NO;
    
    //注册下面的注释
    self.promptLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    [self.promptBtn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
}
//初始化底部
-(void)initSocialView
{
    int y = self.view.frame.size.height - self.socialLogBgView.frame.size.height;

    //设置底部背景
    self.socialLogView.frame = CGRectMake(0,y, self.socialLogView.frame.size.width, self.socialLogView.frame.size.height);
    self.socialLogBgView.image = [UIImage imageNamed:@"weibo_logobg"];
    self.sinaLog.frame = self.socialLogBgView.frame;
    self.regLable.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.weoboLable.textColor = [ColorUtils colorWithHexString:black_text_color];
}

-(void) viewTapped:(id)sender{
    [self.nameIn resignFirstResponder];
    [self.mobileIn resignFirstResponder];
}

- (IBAction)regSubmit:(id)sender {
    if (self.nameIn.text == nil
        || self.mobileIn.text == nil
        || [self.nameIn.text isEqualToString:@""]
        || [self.mobileIn.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入用户名和手机号" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return ;
    }
    [self viewTapped:nil];
    [MobClick event:log_event_name_submit_reg];
    [SVProgressHUD showWithStatus:@"处理中，请稍等..." maskType:SVProgressHUDMaskTypeBlack];
    UserStore *userStore = [UserStore sharedStore];
    [userStore createNewUserWithCompletion:^(User *user, NSError *err) {
        [SVProgressHUD dismiss];
        if(user == nil && err != nil){
            StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
             [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }else if(user != nil){
            [SVProgressHUD dismiss];
            UserFirstLoginController *uflc = [[UserFirstLoginController alloc] initWithFrom:self.accountSessionFrom];
            [self.navigationController pushViewController:uflc animated:YES];
        }
    } name:self.nameIn.text gender:gender_female mobileNo:self.mobileIn.text avatarImage:self.avatarImage];
}

//sina微博注册
- (IBAction)UseSinaAccountLog:(id)sender {

    [ShareSDK ssoEnabled:YES];
    [ShareSDK authWithType:ShareTypeSinaWeibo                                               //需要授权的平台类型
                   options:nil                                                              //授权选项，包括视图定制，自动授权
                    result:^(SSAuthState state, id<ICMErrorInfo> error) {                   //授权返回后的回调方法
        if (state == SSAuthStateSuccess)
        {
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo                                //平台类型
                              authOptions:nil                                               //授权选项
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) { //返回回调
                if (result)
                {
                    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
                        
                    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                              credential.token, @"accessToken",
                                              userInfo.nickname, @"userName",
                                              userInfo.profileImage, @"avatar", nil];
//                    NSLog(@"成功");    
//                    NSLog(@">>>>user id:%@,user image:%@,user name:%@",userInfo.uid,userInfo.profileImage,userInfo.nickname);
                    
                    self.avatarImage = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]]]];
        
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:binding_sina_weibo_key];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:share_to_sina_weibo_key];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //用户关注
                    [ShareSDKProcessor followSinaWeiBo];
                    
                    //构造分享内容@"logo_1024.png"
                    AppStatus *as = [AppStatus sharedInstance];
                    NSString *url = [NSString stringWithFormat:@"%@/app/index", as.webPageUrl];
                    NSString *contentWithUrl = [NSString stringWithFormat:@"%@ %@ ",share_app_txt,url];
                    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo_1024" ofType:@"png"];
                    id<ISSContent> publishContent = [ShareSDK content:contentWithUrl
                                                       defaultContent:@""
                                                                image:[ShareSDK imageWithPath:imagePath]
                                                                title:nil
                                                                  url:nil
                                                          description:nil
                                                            mediaType:SSPublishContentMediaTypeNews];
                    [ShareSDK shareContent:publishContent type:ShareTypeSinaWeibo authOptions:nil shareOptions:nil statusBarTips:NO targets:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateSuccess) {
                            NSLog(@">>>>>>>分享成功");
                        }else if (state == SSResponseStateFail){
//                            NSLog(@">>>>>>>分享失败");
                        }
                    }];
                    //绑定账号提示
                    [self.view makeToast:@"账号绑定成功！请输入您的真实姓名与手机号，以享受良好美发预约服务并完成注册。" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
                    [self.socialLogView setHidden:YES];
                }
                else
                {
                    NSLog(@"失败");
                }
            }];
        }
        else if (state == SSAuthStateFail)
        {
            NSLog(@"失败");
        }
    }];   
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self viewTapped:nil];
}

-(void) viewDidUnload{
    [self setPromptBtn:nil];
    [self setPromptLabel:nil];
    [self setRegInfoBGView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return page_name_reg;
}

@end
