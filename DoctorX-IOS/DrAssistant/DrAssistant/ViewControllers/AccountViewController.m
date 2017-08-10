//
//  AccountViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AccountViewController.h"
#import "MyAccoutController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyAssistantController.h"
#import "SettingViewController.h"
#import "DocPerfectInfoViewController.h"
#import "MyNewsCenterViewController.h"
#import "TongJiListViewController.h"
#import "MessageHandler.h"

#import "MyQRCodeViewController.h"

@interface AccountViewController ()<AccountbuttonAction>
@property (nonatomic,strong)MyAccoutController *accountVC;
@end

@implementation AccountViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserCenterDataForDoctor) name:@"用户数据加载刷新" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserCenterDataForDoctor) name:@"UpdateUserInfoAfterRenZheng" object:nil];
}
/**
 *  更新用户信息
 *
 *  @param sender
 */
- (void)updateUserCenterDataForDoctor
{
    [self showString:@"请等待.."];
    [MessageHandler getUserInfoByUserAccount:[GlobalConst shareInstance].loginInfo.login_name success:^(BaseEntity *object) {
        [self dismissToast];
        ChatListUserEntity *chatEntity = (ChatListUserEntity *)object;
        NSDictionary *dict = chatEntity.dataDic;
        NSLog(@">>>>>>>>>>>>用户信息>>>>>>>>>>>>>%@",dict);
        NSString *name = dict[@"REAL_NAME"];
        if (name.length == 0)
        {
            _accountVC.userName.text = @"未填写姓名";
        }
        else
        {
            _accountVC.userName.text = name;
        }
        
        _accountVC.userPhone.text = [@"电话:" stringByAppendingString:dict[@"PHONE"]];
        [_accountVC.userHeadImg sd_setImageWithURL:[NSURL URLWithString:dict[@"thumb"]] placeholderImage:[UIImage placeholderAvater]];
        
        NSString *CERT_STATUS = [NSString stringWithFormat:@"%@" ,dict[@"CERT_STATUS"]];

        if ([CERT_STATUS isEqualToString:@"2"])
        {
            _accountVC.renZhengImage.image = [UIImage imageNamed:@"mycenter_authena.png"];
            _accountVC.renZhengLab.text = @"已认证";

        }
        else if ([CERT_STATUS isEqualToString:@"1"])
        {
            _accountVC.renZhengImage.image = [UIImage imageNamed:@"mycenter_authenb.png"];
            _accountVC.renZhengLab.text = @"审核中";
        }
        else
        {
            _accountVC.renZhengImage.image = [UIImage imageNamed:@"mycenter_authenb.png"];
            _accountVC.renZhengLab.text = @"未审核";
        }

    } fail:^(id object) {
        if ([object isKindOfClass:[EMError class]])
        {
            EMError *error = (EMError *)object;
            [self showString:error.description];
        }
        
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _accountVC = (MyAccoutController *)[[[NSBundle mainBundle] loadNibNamed:@"MyAccoutController" owner:self options:nil]objectAtIndex:0];
    _accountVC.frame = self.view.bounds;
    _accountVC.delegete = self;
    [self hideLeftBtn];
    [self updateUserCenterDataForDoctor];
//    if([[GlobalConst shareInstance].loginInfo.real_name length]){
//        _accountVC.userName.text=[GlobalConst shareInstance].loginInfo.real_name;
//    }
//    if([[GlobalConst shareInstance].loginInfo.login_name length]){
//    _accountVC.userPhone.text=[@"电话:" stringByAppendingString:[GlobalConst shareInstance].loginInfo.login_name];
//    }
//    if([[GlobalConst shareInstance].loginInfo.thumb length]){
//        [_accountVC.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[GlobalConst shareInstance].loginInfo.thumb] placeholderImage:[UIImage placeholderAvater]];
//    }
    
    _accountVC.userHeadImg.layer.cornerRadius = 40;
    _accountVC.userHeadImg.layer.masksToBounds = YES;               //mycenter_authenb
    [self.view addSubview:_accountVC];
//    _accountVC.tojingJiView.userInteractionEnabled = NO;
//    _accountVC.tojingJiView.hidden = YES;

}

- (void)getHeadImgWithView:(UIView *)view
{
//    view.layer.cornerRadius = 50;
//    view.layer.masksToBounds = YES;
//    //然后再给图层添加一个有色的边框，类似qq空间头像那样
//    view.layer.borderWidth = 5;
//    view.layer.borderColor = [[UIColor whiteColor] CGColor];
//    view.layer.contents = (id)[[UIImage imageNamed:@"backgroundImage.png"] CGImage];
}


#pragma mark - accountButtonActionDelegete
- (void)editButtonAction
{
    DocPerfectInfoViewController *editVC = [DocPerfectInfoViewController simpleInstance];
    editVC.title=@"完善资料";
    [self.tabBarController.navigationController pushViewController:editVC animated:YES];
}

- (void)myNewsButtonAction // 改为助理
{
    MyAssistantController *shareVC = [MyAssistantController simpleInstance];
    shareVC.title=@"我的助理";
    [self.tabBarController.navigationController pushViewController:shareVC animated:YES];
    
}

- (void)shareButtonAction // 改为消息中心
{

    MyNewsCenterViewController *newsVC = [MyNewsCenterViewController simpleInstance];
    newsVC.title=@"消息中心";
    [self.tabBarController.navigationController pushViewController:newsVC animated:YES];
}

- (void)settingButtionAction
{
    SettingViewController *settingVC = [SettingViewController simpleInstance];
    settingVC.title=@"设置";
    [self.tabBarController.navigationController pushViewController:settingVC animated:YES];
}
- (void)tongjiButtonAction
{
    TongJiListViewController *settingVC = [TongJiListViewController simpleInstance];
    settingVC.title=@"数据统计";
    [self.tabBarController.navigationController pushViewController:settingVC animated:YES];
}
- (void)QRCodeButtonAction
{
    MyQRCodeViewController *scodeVC = [MyQRCodeViewController simpleInstance];
    scodeVC.title=@"我的二维码";
    [self.tabBarController.navigationController pushViewController:scodeVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
