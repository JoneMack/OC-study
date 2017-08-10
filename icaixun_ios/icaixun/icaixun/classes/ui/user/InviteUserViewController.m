//
//  InviteUserViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/17.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "InviteUserViewController.h"
#import "ShareSDKProcessor.h"

@interface InviteUserViewController ()

@property (strong, nonatomic) IBOutlet UIView *bodyView;

@property (strong, nonatomic) IBOutlet UIView *contentBlockView;

@property (strong, nonatomic) IBOutlet UIImageView *contentBlockBg;

@property (strong, nonatomic) IBOutlet UIImageView *shareIcon;

@property (strong, nonatomic) IBOutlet UILabel *shareDesc;

@property (strong, nonatomic) IBOutlet UILabel *inviteCode;

@property (strong, nonatomic) IBOutlet UIButton *shareBtn;

- (IBAction)share:(id)sender;


@end

@implementation InviteUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"邀请有奖" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
}

-(void) initBodyView
{
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    
    [self.contentBlockView setBackgroundColor:[UIColor clearColor]];
    
    [self.contentBlockBg setImage:[UIImage imageNamed:@"bg_colorful_small"]];
    
    [self.shareIcon setImage:[UIImage imageNamed:@"icon_gift_white"]];
    
    self.shareDesc.numberOfLines = 0;
    [self.shareDesc sizeToFit];
    
    [self.inviteCode setText:[AppStatus sharedInstance].user.invitationCode];
    
    [self.shareBtn setBackgroundColor:[ColorUtils colorWithHexString:orange_red_line_color]];
    self.shareBtn.layer.masksToBounds = YES;
    self.shareBtn.layer.cornerRadius = 7;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)share:(id)sender {
    NSString *title = [NSString stringWithFormat:@"这个app很不错哦，我的邀请码是:%@" , [[AppStatus sharedInstance] user].invitationCode];
    [[ShareSDKProcessor sharedInstance] share:self.view title:title];
}
@end
