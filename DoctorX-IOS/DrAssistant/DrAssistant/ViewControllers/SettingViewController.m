//
//  SettingViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "SettingViewController.h"
#import "LLChangePasswordViewController.h"
#import "PrivacySettingViewController.h"
#import "QuickResponseViewController.h"
#import "ChatSettingViewController.h"
#import "MyShareViewController.h"
#import "AboutViewController.h"
#import "BlackListViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePwdAction:(id)sender
{
    LLChangePasswordViewController *vc = [LLChangePasswordViewController simpleInstance];
    vc.title=@"修改密码";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)chatSetting:(id)sender
{
    ChatSettingViewController *vc = [ChatSettingViewController simpleInstance];
    vc.title=@"聊天设置";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)logOutAction:(UIButton *)sender {
// 此处需另作修改
    [self showWithStatus:@"正在退出..."];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error && error.errorCode != EMErrorServerNotLogin) {
//            [self showWithStatus:@"退出失败..."];
        }
        else{
            
        }
        [self dismissToast];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    } onQueue:nil];
    
}

- (IBAction)share:(id)sender
{
//    MyShareViewController *vc = [MyShareViewController simpleInstance];
//    vc.title=@"分享我们";
//    [self.navigationController pushViewController:vc animated:YES];
//    NSString *shareText = umeng_share_txt;             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"120"];          //分享内嵌图片
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:umeng_app_key
                                      shareText:nil
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToQQ,nil]
                                       delegate:self];

}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    if (platformName == UMShareToSina) {
        socialData.shareText = [NSString stringWithFormat:@"%@,%@",umeng_share_txt,umeng_share_url];
    }
    else{
        socialData.shareText = umeng_share_txt;
    }
    NSLog(@">>>>>>>>>>>>分享的平台：%@-----内容：%@",platformName,socialData.shareText);
}

- (IBAction)about:(id)sender
{
    AboutViewController *vc = [AboutViewController simpleInstance];
    vc.title=@"关于我们";
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
