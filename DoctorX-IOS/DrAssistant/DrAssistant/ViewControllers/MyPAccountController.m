//
//  MyPAccountController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyPAccountController.h"
#import "PerfectInfoViewController.h"
#import "MyNewsCenterViewController.h"
#import "MyCaseViewController.h"
#import "MyShareViewController.h"
#import "UpdateViewController.h"
#import "SettingViewController.h"
#import "LoginEntity.h"
#import "UserContext.h"
#import "MessageHandler.h"

#import "MyQRCodeViewController.h"

@interface MyPAccountController ()

@end

@implementation MyPAccountController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserCenterData) name:@"用户数据保存成功" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideLeftBtn];
    CALayer *layer = self.headImg.layer;
    layer.cornerRadius = 40;
    layer.masksToBounds = YES;
    if([[GlobalConst shareInstance].loginInfo.real_name length]){
        self.PatientName.text=[GlobalConst shareInstance].loginInfo.real_name;

    }
    if([[GlobalConst shareInstance].loginInfo.phone length]){
       self.telePhone.text=[@"电话:" stringByAppendingString:[GlobalConst shareInstance].loginInfo.phone];
    }
    if ([NSURL URLWithString:[GlobalConst shareInstance].loginInfo.thumb]) {
       [self.headImg sd_setImageWithURL:[NSURL URLWithString:[GlobalConst shareInstance].loginInfo.thumb] placeholderImage:[UIImage placeholderAvater]];
    }
    
}
/**
 *  更新用户信息
 *
 *  @param sender
 */
- (void)updateUserCenterData{
    [MessageHandler getUserInfoByUserAccount:[GlobalConst shareInstance].loginInfo.login_name success:^(BaseEntity *object) {
        ChatListUserEntity *chatEntity = (ChatListUserEntity *)object;
        NSDictionary *dict = chatEntity.dataDic;
        NSLog(@">>>>>>>>>>>>用户信息>>>>>>>>>>>>>%@",dict);
        self.PatientName.text = dict[@"REAL_NAME"];
        self.telePhone.text = [@"电话:" stringByAppendingString:dict[@"PHONE"]];
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:dict[@"thumb"]] placeholderImage:[UIImage placeholderAvater]];
    } fail:^(id object) {
        if ([object isKindOfClass:[EMError class]])
        {
            EMError *error = (EMError *)object;
            [self showString:error.description];
        }

    }];

}

#pragma mark - Buttons Methods
- (IBAction)editing:(id)sender
{
    PerfectInfoViewController *vc = [PerfectInfoViewController simpleInstance];
    vc.title=@"完善资料";
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)newCenterAction:(id)sender
{
    MyNewsCenterViewController *vc = [MyNewsCenterViewController simpleInstance];
    vc.title=@"消息中心";
    vc.myNewsType = PatientNews;
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)caseHistory:(id)sender
{
    MyCaseViewController *vc = [MyCaseViewController simpleInstance];
    vc.title=@"我的病历";
    [self.tabBarController.navigationController  pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)myQRAction:(id)sender {
    MyQRCodeViewController *scodeVC = [MyQRCodeViewController simpleInstance];
    scodeVC.title=@"我的二维码";
    [self.tabBarController.navigationController pushViewController:scodeVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)setting:(id)sender {
    SettingViewController *vc = [SettingViewController simpleInstance];
     vc.title=@"设置";
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}
@end
