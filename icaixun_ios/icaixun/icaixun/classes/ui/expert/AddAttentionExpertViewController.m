//
//  AddAttentionExpertViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/18.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "AddAttentionExpertViewController.h"
#import "UserStore.h"

@interface AddAttentionExpertViewController ()

@property (strong, nonatomic) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UIView *bodyView;

@property (strong, nonatomic) IBOutlet UITextField *inputInviteCodeField;

@property (strong, nonatomic) IBOutlet UIButton *finishBtn;


- (IBAction)addExpert:(id)sender;

@end

@implementation AddAttentionExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
}

- (void)initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"关注专家" navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
}

- (void)initBodyView
{
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    
    [self.inputInviteCodeField setPlaceholder:@"请输入专家邀请码"];
    
    [self.finishBtn setBackgroundColor:[ColorUtils colorWithHexString:orange_red_line_color]];
    self.finishBtn.layer.masksToBounds = YES;
    self.finishBtn.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)addExpert:(id)sender {
    
    NSString *inviteCode = self.inputInviteCodeField.text;
    if (inviteCode == nil || [inviteCode isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"邀请码不能为空"];
        return;
    }
    
    [[UserStore sharedStore] addAttentionExpertByExpertInvitationCode:^(NSError *err) {
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_attention_expert object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            ExceptionMsg *msg = [err.userInfo objectForKey:@"ExceptionMsg"];
            [SVProgressHUD showErrorWithStatus:msg.message];
        }
    } invitationCode:inviteCode];
    
}

#pragma mark - 触摸事件使键盘失去第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.inputInviteCodeField == textField) {
        [self.view endEditing:YES];
    }
    return YES;
}


@end
