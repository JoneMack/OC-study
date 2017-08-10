//
//  SettingUserInfoViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/10.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "SettingUserInfoViewController.h"
#import "UserStore.h"

@interface SettingUserInfoViewController ()

@property (nonatomic , strong) UIView *separatorLine;

@end

@implementation SettingUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
}

- (void)initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"用户设置" navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
}

- (void) initBodyView
{
    [self initBaseView];
    [self renderUI];
    [self setupEvents];
}

- (void) initBaseView
{
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    [self.contentBlockView setBackgroundColor:[UIColor whiteColor]];
    
    self.separatorLine = [UIView new];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_line_color];
    self.separatorLine.frame = CGRectMake(0, 0,
                                          screen_width,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    self.separatorLine = [UIView new];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_line_color];
    self.separatorLine.frame = CGRectMake(10, 79.5,
                                          screen_width-10,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    self.separatorLine = [UIView new];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_line_color];
    self.separatorLine.frame = CGRectMake(10, 129.5,
                                          screen_width-10,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    self.separatorLine = [UIView new];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_line_color];
    self.separatorLine.frame = CGRectMake(0, 179.5,
                                          screen_width,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.cornerRadius = 30;
    
}

- (void) renderUI
{
    User *user = [AppStatus sharedInstance].user;
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl]
                       placeholderImage:[UIImage imageNamed:@"icon_user_gray"]];
    
    self.userNameField.text = user.name;
    
    [self.saveBtn setBackgroundColor:[ColorUtils colorWithHexString:orange_red_line_color]];
    
    [self renderGender];
}

- (void) renderGender
{
    User *user = [AppStatus sharedInstance].user;
    if (user.userGender == 0) {
        [self.boyRadio setImage:[UIImage imageNamed:@"icon_uncheck"]];
        [self.girlRadio setImage:[UIImage imageNamed:@"icon_checked"]];
        self.boyRadio.tag = 1;
        self.girlRadio.tag = 0;
    }else{
        [self.boyRadio setImage:[UIImage imageNamed:@"icon_checked"]];
        [self.girlRadio setImage:[UIImage imageNamed:@"icon_uncheck"]];
        self.boyRadio.tag = 0;
        self.girlRadio.tag = 1;
    }
}

- (void)setupEvents
{
    self.userAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *updateAvatarEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateAvatar)];
    [self.userAvatar addGestureRecognizer:updateAvatarEvent];
    
    self.boyRadio.userInteractionEnabled = YES;
    UITapGestureRecognizer *updateUserGender2boyEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserGender2boy)];
    [self.boyRadio addGestureRecognizer:updateUserGender2boyEvent];
    
    
    self.girlRadio.userInteractionEnabled = YES;
    UITapGestureRecognizer *updateUserGender2girlEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserGender2girl)];
    [self.girlRadio addGestureRecognizer:updateUserGender2girlEvent];
}

-(void) updateAvatar
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

-(void) updateUserGender2boy
{
    [self.boyRadio setImage:[UIImage imageNamed:@"icon_checked"]];
    [self.girlRadio setImage:[UIImage imageNamed:@"icon_uncheck"]];
    self.boyRadio.tag = 1;
    self.girlRadio.tag = 0;
}

-(void) updateUserGender2girl
{
    [self.boyRadio setImage:[UIImage imageNamed:@"icon_uncheck"]];
    [self.girlRadio setImage:[UIImage imageNamed:@"icon_checked"]];
    self.boyRadio.tag = 0;
    self.girlRadio.tag = 1;
}

#pragma mark - UIActionSheet代理方法
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
    
    //    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."  maskType:SVProgressHUDMaskTypeGradient];
    image = [ImageUtils imageWithImageSimple:image scaledToSize:CGSizeMake(220, 220)];
    
    AppStatus *as = [AppStatus sharedInstance];
    [[UserStore sharedStore] updateAvatar:^(NSError *err) {
        if (err == nil) {
            AppStatus *as = [AppStatus sharedInstance];
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:as.user.avatarUrl]]];// 清除旧的头像缓存
            NSLog(@">>>>>>>>>>>更新成功地URLIMg>>>>>>>>>%@",as.user.avatarUrl);
            [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:as.user.avatarUrl]
                                               placeholderImage:[UIImage imageNamed:@"user_icon"]
                                                        options:SDWebImageRefreshCached
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          [self.userAvatar setImage:image];
                                                          [SVProgressHUD showSuccessWithStatus:@"头像更新成功！" duration:2.0];
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_user_info object:nil];
                                                      }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"头像更新失败！" duration:2.0];
        }
    } userId:as.user.id avatarImage:image];
}

#pragma mark - 触摸事件使键盘失去第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)saveUserInfo:(id)sender {
    NSLog(@"保存用户信息");
    NSString *userName = self.userNameField.text;
    int userGender = self.boyRadio.tag == 1 ? 1 : 0;
    
    if (userName == nil || [userName isEqualToString:@""]) {
        [self.view makeToast:@"名称不能为空" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    [[UserStore sharedStore] updateUserInfo:^(NSError *err) {
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_user_info object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            ExceptionMsg *msg = [err.userInfo objectForKeyedSubscript:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:msg.message];
        }
    } userId:[[AppStatus sharedInstance].user id] name:userName gender:userGender];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
