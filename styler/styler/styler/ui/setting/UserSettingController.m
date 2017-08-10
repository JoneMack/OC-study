//
//  UserSettingController.m
//  styler
//
//  Created by System Administrator on 13-5-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define red_dot_user_name_x    50

#import "UserSettingController.h"
#import <QuartzCore/QuartzCore.h>
#import "SetNameController.h"
#import "SetPwdController.h"
#import "ImageUtils.h"
#import "UserStore.h"
#import "SetSexController.h"
#import "PushProcessor.h"
#import "UserLoginController.h"
#import "AppDelegate.h"
#import "LeveyTabBarController.h"
#import "BindingSocailAccountController.h"
#import "SocialAccountStore.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"
#import "AlipayProcessor.h"
#import "EaseMobProcessor.h"
#import "AppClientStore.h"
#import "RewardActivityProcessor.h"
#import "PayProcessor.h"

@interface UserSettingController ()
{
    UIImageView *defaultUserNameDotImage;
}
@end

@implementation UserSettingController
{
    int count;//用来记录是否按下退出登录，并确定按钮
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userImage = [[UIImageView alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initHeadPortrait];
    [self initTableView];
    [self initCancelBtn];
    [self initNotification];
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateUIWithUserName) name:notification_name_update_user_name object:nil];
    [nc addObserver:self selector:@selector(updateUIWithUserSex) name:notification_name_update_user_gender object:nil];
    [nc addObserver:self selector:@selector(loadSocialView) name:notification_name_update_user_avatar object:nil];
    [nc addObserver:self selector:@selector(updateShareSinaLogo) name:binding_sina_weibo_key object:nil];
}

-(void)initHeader
{
    HeaderView *header = [[HeaderView alloc]initWithTitle:page_name_information navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];

}

//初始化修改头像
-(void)initHeadPortrait
{
    if ([[[UIDevice currentDevice]systemVersion]intValue] < 7) {
        self.headerPhoto.frame = CGRectMake(0, navigation_height +general_margin, self.headerPhoto.frame.size.width, self.headerPhoto.frame.size.height);
    }

    self.upSpliteLine.frame = CGRectMake(self.upSpliteLine.frame.origin.x, self.upSpliteLine.frame.origin.y, self.upSpliteLine.frame.size.width, splite_line_height);
    self.upSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.downSpliteLine.frame = CGRectMake(self.downSpliteLine.frame.origin.x, self.downSpliteLine.frame.origin.y - splite_line_height, self.downSpliteLine.frame.size.width, splite_line_height);
    self.downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    //设置头像
    AppStatus *as = [AppStatus sharedInstance];
    [self.userAvatar setImageWithURL:[NSURL URLWithString:as.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"user_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    CALayer *layer  = self.userAvatar.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:self.userAvatar.frame.size.width/2];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[ColorUtils colorWithHexString:black_text_color].CGColor];
    
    self.changeHeader.textColor = [ColorUtils colorWithHexString:gray_text_color];
    
    UITapGestureRecognizer *tapGestuer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar:)];
    [self.headerPhoto addGestureRecognizer:tapGestuer];
}

-(void)initTableView
{
    CGRect frame = self.tableView.frame;
    frame.size.height = general_cell_height * 4 +general_margin*3;
    frame.origin.y = self.headerPhoto.frame.origin.y + self.headerPhoto.frame.size.height;
    self.tableView.frame = frame;
    self.tableView.contentSize = self.tableView.frame.size;
    self.tableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    
    defaultUserNameDotImage = [[UIImageView alloc] init];
    defaultUserNameDotImage.frame = CGRectMake(red_dot_user_name_x, (general_cell_height-red_dot_width)/2, red_dot_width, red_dot_width);
    defaultUserNameDotImage.image = [UIImage imageNamed:@"red_dot"];
}

//initTableView
#pragma dateSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.alpha = 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return general_margin;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return general_cell_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.backgroundColor = [UIColor clearColor];
    [cell setAlpha:0];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    UIView *upSpliteline = [[UIView alloc]init];
    upSpliteline.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    if (indexPath.row == 0) {
        upSpliteline.frame = CGRectMake(0, 0, screen_width, splite_line_height);
    }else
    {
        upSpliteline.frame = CGRectMake(10, 0, screen_width -10, splite_line_height);
    }
    [cell addSubview:upSpliteline];

    if ((indexPath.section == 0 && indexPath.row == 2)||(indexPath.section == 1&& indexPath.row == 0)){
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, general_cell_height -splite_line_height, screen_width, splite_line_height)];
        line.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell addSubview:line];
    }
    
    //设置整个cell
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(14, 1, 100, 42)];
    lable.textColor = [ColorUtils colorWithHexString:gray_text_color];
    lable.backgroundColor = [UIColor whiteColor];
    
    lable.font = [UIFont systemFontOfSize:default_font_size];
    [cell addSubview:lable];
    
    gobackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(290, (general_cell_height - 25)/2, 25, 25)];
    [cell addSubview:gobackImageView];
    if (indexPath.section == 0) {
        //左边 lable 设置
        switch (indexPath.row) {
            case 0:
                lable.text = @"姓名";
                break;
            case 1:
                lable.text = @"性别";
                break;
            case 2:
                lable.text = @"密码设置";
                break;
            default:
                break;
        }
        //中间lable设置
        if (indexPath.row == 0 && userName == nil) {
            userName = [[UILabel alloc]initWithFrame:CGRectMake(190, 1, 100, general_cell_height-2)];
            userName.textColor = [ColorUtils colorWithHexString:gray_text_color];
            userName.backgroundColor = [UIColor whiteColor];
            userName.textAlignment = NSTextAlignmentRight;
            userName.font = [UIFont systemFontOfSize:default_font_size];
            //设置名字
            userName.text = [AppStatus sharedInstance].user.name;
            [cell addSubview:userName];
            
            // 点亮提醒
            [cell addSubview:defaultUserNameDotImage];
            if ([[AppStatus sharedInstance] isDefaultUserName]) {
                defaultUserNameDotImage.hidden = NO;
            }else{
                defaultUserNameDotImage.hidden = YES;
            }
            
        }else if(indexPath.row == 1 && userSex == nil)
        {
            userSex = [[UILabel alloc]initWithFrame:CGRectMake(190, 1, 100, general_cell_height-2)];
            userSex.textColor = [ColorUtils colorWithHexString:gray_text_color];
            userSex.backgroundColor = [UIColor whiteColor];
            userSex.font = [UIFont systemFontOfSize:default_font_size];
            userSex.textAlignment = NSTextAlignmentRight;
            //设置性别
            if ([AppStatus sharedInstance].user.gender == 0) {
                userSex.text = @"女";
            }else
            {
                userSex.text = @"男";
            }
            [cell addSubview:userSex];
        }
       //右边图片设置
        gobackImageView.image = [UIImage imageNamed:@"right_arrow"];
    }else
    {
        //左边 lable 设置
        lable.text = @"账号关联";
        //右边图片设置  暂无这个图片
        if ([[NSUserDefaults standardUserDefaults] boolForKey:binding_sina_weibo_key]) {
            gobackImageView.image = [UIImage imageNamed:@"sina_logo_selected"];
        }else
        {
            gobackImageView.image = [UIImage imageNamed:@"sina_logo_default"];
        }
    }
    return cell;
}

- ( void )tableView:( UITableView  *)tableView willDisplayCell :( UITableViewCell  *)cell  forRowAtIndexPath :( NSIndexPath  *)indexPath
{
    cell.backgroundColor  = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion]intValue]< 7) {
        if ((indexPath.section ==0 &&indexPath.row == 2)||(indexPath.section ==1 &&indexPath.row == 0)) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, general_cell_height - splite_line_height, screen_width, splite_line_height)];
            line.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            [cell addSubview:line];
        }
    }
}

#pragma delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SetNameController *setName = [[SetNameController alloc]init];
            [self.navigationController pushViewController:setName animated:YES];
            
            [MobClick event:log_event_name_change_name];
        }else if(indexPath.row == 1)
        {
            SetSexController *setSex = [[SetSexController alloc]init];
            [self.navigationController pushViewController:setSex animated:YES];
            [MobClick event:log_event_name_change_gender];
        }else
        {
            SetPwdController *setPwd = [[SetPwdController alloc]init];
            [self.navigationController pushViewController:setPwd animated:YES];
            [MobClick event:log_event_name_change_psw];
        }
        
    }else
    {
        [self.navigationController pushViewController:[[BindingSocailAccountController alloc]init] animated:YES];
        [MobClick event:log_event_name_share_to_sina_weibo];
    }
}

-(void)initCancelBtn
{
    CGRect frame = self.cancelBtn.frame;
    frame.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height;
    self.cancelBtn.frame = frame;
    self.cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:big_font_size];
    [self.cancelBtn setTitleColor:[ColorUtils colorWithHexString:white_text_color] forState:UIControlStateNormal];
    self.cancelBtn.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
    CALayer *layer = self.cancelBtn.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
}
//对通知做的操作
-(void) updateUIWithUserName{
    AppStatus *as = [AppStatus sharedInstance];
    userName.text = as.user.name;
    if ([as isDefaultUserName]) {
        defaultUserNameDotImage.hidden = NO;
    }else{
        defaultUserNameDotImage.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_remind_user_update_default_name object:nil];
}

-(void)loadSocialView
{
    AppStatus *as = [AppStatus sharedInstance];
    [self.userAvatar setImageWithURL:[NSURL URLWithString:as.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"user_default_image_before_load"] options:SDWebImageDownloaderHighPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
}

-(void)updateUIWithUserSex
{
    AppStatus *as = [AppStatus sharedInstance];
    if (as.user.gender) {
        userSex.text = @"男";
    }else
    {
        userSex.text = @"女";
    }
    
}

-(void)updateShareSinaLogo
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:binding_sina_weibo_key]) {
        gobackImageView.image = [UIImage imageNamed:@"sina_logo_selected"];
    }else
    {
        gobackImageView.image = [UIImage imageNamed:@"sina_logo_default"];
    }
}


- (IBAction)cancelBtn:(id)sender {
    count = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [MobClick event:log_event_name_cancel_logoin];
}

- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        return ;
    }
    count = 1;
    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."];
    [[UserStore sharedStore] removeSession:^(NSError *err) {
        [[PushProcessor sharedInstance] cleanReadAndUnreadPushByLogout];
        [[PayProcessor sharedInstance] cleanLocalData];
        [[RewardActivityProcessor sharedInstance] cleanLocalData];
        [EaseMobProcessor logout];
        
        AppStatus *as = [AppStatus sharedInstance];
        [as initBaseData];
        [AppStatus saveAppStatus];
        
        NSNotification *notification = [NSNotification notificationWithName:notification_name_session_update object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [[SocialAccountStore shareInstance] removeSocialAccountCache];
        [SVProgressHUD dismiss];
        //返回tabbar第一个view
        [self.navigationController popToRootViewControllerAnimated:NO];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar setSelectedIndex:0];
        [AppClientStore updateAppClient];
    }];
}

//修改头像
- (void)changeAvatar:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
    
    [MobClick event:log_event_name_change_avatar];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    
    if(buttonIndex == 0){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }else if(buttonIndex == 1){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."  maskType:SVProgressHUDMaskTypeGradient];
    image = [ImageUtils imageWithImageSimple:image scaledToSize:CGSizeMake(220, 220)];
    
    AppStatus *as = [AppStatus sharedInstance];
    [[UserStore sharedStore] updateAvatar:^(NSError *err) {
        if (err == nil) {
            AppStatus *as = [AppStatus sharedInstance];
            NSURLCache *cache = [NSURLCache sharedURLCache];
            [cache removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:as.user.avatarUrl]]];  // 清除旧的头像缓存
            [self.userAvatar setImageWithURL:[NSURL URLWithString:as.user.avatarUrl]
                            placeholderImage:[UIImage imageNamed:@"user_default_image_before_load"]
                                     options:SDWebImageRefreshCached
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [self.userAvatar setImage:image];
                [SVProgressHUD showSuccessWithStatus:@"头像更新成功！" duration:2.0];
                NSNotification *notification = [NSNotification notificationWithName:notification_name_update_user_avatar object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } ];
       
        }else{
            [SVProgressHUD showErrorWithStatus:@"头像更新失败！" duration:2.0];
        }
    } userId:as.user.idStr avatarImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *)getPageName{
    return page_name_information;
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCancelBtn:nil];
    [super viewDidUnload];
}
@end
