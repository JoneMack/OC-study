//
//  PrivacySettingViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "PrivacySettingViewController.h"
#import "EditProblemViewController.h"

@interface PrivacySettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *allowAllAttentionMe;
@property (weak, nonatomic) IBOutlet UIButton *needMeConfirm;
@property (weak, nonatomic) IBOutlet UIButton *needResponseRightProblem;

@end

@implementation PrivacySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addStatusToButton];
}

- (void)addStatusToButton
{
    [_allowAllAttentionMe setImage:[UIImage imageNamed:@"rgister_daGou"] forState:UIControlStateSelected];
    [_needMeConfirm setImage:[UIImage imageNamed:@"rgister_daGou"] forState:UIControlStateSelected];
    [_needResponseRightProblem setImage:[UIImage imageNamed:@"rgister_daGou"] forState:UIControlStateSelected];
}
- (IBAction)allowAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}
- (IBAction)attentionAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)responseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)editProblemAction:(id)sender {
    EditProblemViewController *editVC = [EditProblemViewController simpleInstance];
    [self.navigationController pushViewController:editVC animated:YES];
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
