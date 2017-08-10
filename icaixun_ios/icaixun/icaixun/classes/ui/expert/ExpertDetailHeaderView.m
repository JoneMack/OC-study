//
//  ExpertDetailHeaderView.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/14.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertDetailHeaderView.h"
#import "SettingReceiverMessageController.h"

@implementation ExpertDetailHeaderView

-(instancetype) initWithExpert:(Expert *)expert navigationController:(UINavigationController *)navigationController{
    self = [super init];
    if (self) {
        self.expert = expert;
        self.navigationController = navigationController;
        [self initView];
        [self initFrame];
        [self renderData];
    }
    return self;
}

-(void) initView
{
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_big_header@2x.jpg"]];
    [self setBackgroundView:bgImg];
    
    // header 内容块
    self.headerContentBlockView = [[UIView alloc] init];
    self.headerContentBlockView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.headerContentBlockView];
    
    // 返回
    self.goBackBtn = [[UIButton alloc] init];
    [self.goBackBtn setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateNormal];
    [self addSubview:self.goBackBtn];
    [self.goBackBtn addTarget:self action:@selector(goBackView) forControlEvents:UIControlEventTouchUpInside];
    
    // 专家头像
    self.expertAvatarImgView = [[UIImageView alloc] init];
    self.expertAvatarImgView.layer.masksToBounds = YES;
    self.expertAvatarImgView.layer.cornerRadius = 30;
    self.expertAvatarImgView.layer.borderWidth = 2;
    self.expertAvatarImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.headerContentBlockView addSubview:self.expertAvatarImgView];
    
    // setting
    self.setting = [UIButton new];
    [self.setting setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
    [self addSubview:self.setting];
    [self.setting addTarget:self action:@selector(settingInfo) forControlEvents:UIControlEventTouchUpInside];
    
    // 专家名
    self.expertNameLabel = [[UILabel alloc] init];
    self.expertNameLabel.textColor = [UIColor whiteColor];
    self.expertNameLabel.font = [UIFont systemFontOfSize:13];
    self.expertNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerContentBlockView addSubview:self.expertNameLabel];
    
    // 信息
    self.commonView = [[UIView alloc] init];
    [self.commonView setBackgroundColor:[ColorUtils colorWithHexString:@"000000" alpha:0.1]];
    self.commonView.layer.masksToBounds = YES;
    self.commonView.layer.cornerRadius = 17;
    [self.headerContentBlockView addSubview:self.commonView];
    
    //财讯
    self.msgLabel = [[UILabel alloc] init];
    self.msgLabel.text = @"微博";
    self.msgLabel.textColor = [UIColor whiteColor];
    self.msgLabel.font = [UIFont systemFontOfSize:13];
    [self.commonView addSubview:self.msgLabel];
    
    // 财讯数
    self.infoCountabel = [[UILabel alloc] init];
    self.infoCountabel.textColor = [UIColor whiteColor];
    self.infoCountabel.font = [UIFont systemFontOfSize:13];
    [self.commonView addSubview:self.infoCountabel];
    
    // 中线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:@"ffffff" alpha:0.5];
    [self.commonView addSubview:self.separatorLine];
    
    // 订阅
    self.subscribeLabel= [[UILabel alloc] init];
    self.subscribeLabel.text = @"订阅";
    self.subscribeLabel.textColor = [UIColor whiteColor];
    self.subscribeLabel.font = [UIFont systemFontOfSize:13];
    [self.commonView addSubview:self.subscribeLabel];
    
    // 订阅数
    self.subscribeCoinLabel = [[UILabel alloc] init];
    self.subscribeCoinLabel.textColor = [UIColor whiteColor];
    self.subscribeCoinLabel.font = [UIFont systemFontOfSize:13];
    [self.commonView addSubview:self.subscribeCoinLabel];
    
    // 认证信息
    self.authInfo = [[UILabel alloc] init];
    self.authInfo.textColor = [UIColor whiteColor];
    self.authInfo.font = [UIFont systemFontOfSize:11];
    self.authInfo.backgroundColor = [UIColor clearColor];
    [self.headerContentBlockView addSubview:self.authInfo];
    
}

-(void) initFrame
{
    
    self.headerContentBlockView.frame = CGRectMake(15, 20 + 10, screen_width - 30, 210-20);
    
    self.goBackBtn.frame = CGRectMake(0, 20, 50, 40);
    
    self.expertAvatarImgView.frame = CGRectMake((self.headerContentBlockView.frame.size.width - 60)/2, 0, 60, 60);
    
    self.setting.frame = CGRectMake(screen_width - 50, 20, 50, 40);
    
    self.expertNameLabel.frame = CGRectMake(0, self.expertAvatarImgView.bottomY + 10,
                                            self.headerContentBlockView.frame.size.width, 20);
    
    self.commonView.frame = CGRectMake(0, self.expertNameLabel.bottomY+15,
                                       self.headerContentBlockView.frame.size.width, 35);
    
    
    self.msgLabel.frame = CGRectMake( 40, 0, 30, 35);
    
    self.infoCountabel.frame = CGRectMake(70, 0, 50, 35);
    
    
    self.subscribeLabel.frame = CGRectMake(self.commonView.frame.size.width - 100 , 0, 30, 35);
    
    
    self.subscribeCoinLabel.frame = CGRectMake(self.subscribeLabel.rightX, 0, 50, 35);
    
    
    self.authInfo.frame = CGRectMake(10, self.commonView.bottomY,
                                     self.headerContentBlockView.frame.size.width - 20, 40);
    
    self.separatorLine.frame = CGRectMake(self.commonView.frame.size.width/2, 7.5,
                                          splite_line_height , 20);

    
}

-(void) renderData
{
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.expert.avatarUrl]];
    UIImage *avatar = [[UIImage alloc] initWithData:data];
    [self.expertAvatarImgView setImage:avatar];
    
    self.expertNameLabel.text = self.expert.name;
    
    self.infoCountabel.text = [NSString stringWithFormat:@"%d" , self.expert.msgCount];
    
    self.subscribeCoinLabel.text = [NSString stringWithFormat:@"%d" , self.expert.subscribeCount];
    
    self.authInfo.text = [NSString stringWithFormat:@"爱财讯认证: %@" , self.expert.shortIntroduction];
}

-(void) goBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) settingInfo
{
    SettingReceiverMessageController *settingController = [SettingReceiverMessageController new];
    settingController.expert = self.expert;
    [self.navigationController pushViewController:settingController animated:YES];
}

@end
