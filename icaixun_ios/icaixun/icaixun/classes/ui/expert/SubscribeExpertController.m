//
//  SubscribeExpertController.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/23.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define CONTENT_HEIGHT 125
#define CONTENT_MARGIN_LEFT 10

#import "SubscribeExpertController.h"
#import "PayViewController.h"
#import "UserStore.h"
#import "MyExpertsController.h"
#import "SystemStore.h"

@interface SubscribeExpertController ()

@end

@implementation SubscribeExpertController

-(instancetype) initWithExpert:(Expert *)expert expertPrice:(ExpertPriceList *)expertPrice
{
    self = [super init];
    if (self) {
        self.expert = expert;
        self.expertPrice = expertPrice;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renderUserData) name:notification_name_update_user_info object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [[HeaderView alloc] initWithTitle:self.expert.name
                                   navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
    
    
    self.bodyView = [[UIView alloc] init];
    self.bodyView.frame = CGRectMake( 0, self.headerView.bottomY, screen_width, screen_height - self.headerView.frame.size.height);
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    [self.view addSubview:self.bodyView];
    
    self.contentBlock = [[UIView alloc] init];
    self.contentBlock.frame = CGRectMake(CONTENT_MARGIN_LEFT, 15,
                                         screen_width - CONTENT_MARGIN_LEFT*2 ,
                                         CONTENT_HEIGHT);
    [self.bodyView addSubview:self.contentBlock];
    
    self.contentBgView = [[UIImageView alloc] init];
    self.contentBgView.frame = CGRectMake(0, 0, self.contentBlock.frame.size.width, self.contentBlock.frame.size.height);
    UIImage *contentBgImg = [UIImage imageNamed:@"bg_list"];
    
    UIEdgeInsets insets = UIEdgeInsetsMake( 10, 0, 10, 0);
    contentBgImg = [contentBgImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.contentBgView setImage:contentBgImg];
    [self.contentBlock addSubview:self.contentBgView];
    
    // 专家头像
    self.expertAvatarView = [[UIImageView alloc] init];
    self.expertAvatarView.frame = CGRectMake(25, 23, 49, 49);
    self.expertAvatarView.layer.cornerRadius = 24;
    self.expertAvatarView.layer.masksToBounds = YES;
    [self.expertAvatarView sd_setImageWithURL:[NSURL URLWithString:self.expert.avatarUrl]
                       placeholderImage:[UIImage imageNamed:@"icon_user_gray"]];
    

    [self.contentBlock addSubview:self.expertAvatarView];
    
    // 专家名
    self.expertNameLabel = [[UILabel alloc] init];
    self.expertNameLabel.text = self.expert.name;
    self.expertNameLabel.font = [UIFont systemFontOfSize:16 weight:10];
    self.expertNameLabel.frame = CGRectMake(self.expertAvatarView.rightX + 20,
                                            27, 140, 22);
    [self.contentBlock addSubview:self.expertNameLabel];
    
    // 财讯
    self.commenLabel = [[UILabel alloc] init];
    self.commenLabel.text = @"微博";
    self.commenLabel.font = [UIFont systemFontOfSize:12];
    self.commenLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.commenLabel.frame = CGRectMake(self.expertAvatarView.rightX + 20,
                                        50, 30, 20);
    [self.contentBlock addSubview:self.commenLabel];
    
    // 财讯 数量
    self.infoCountabel = [[UILabel alloc] init];
    self.infoCountabel.text = [NSString stringWithFormat:@"%d", self.expert.msgCount];
    self.infoCountabel.font = [UIFont systemFontOfSize:12];
    self.infoCountabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.infoCountabel.frame = CGRectMake(self.commenLabel.rightX,
                                          self.commenLabel.frame.origin.y, 75, 20);
    [self.contentBlock addSubview:self.infoCountabel];
    
    //订阅量
    self.commenLabel = [[UILabel alloc] init];
    self.commenLabel.text = @"订阅量";
    self.commenLabel.font = [UIFont systemFontOfSize:12];
    self.commenLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.commenLabel.frame = CGRectMake(self.infoCountabel.rightX,
                                        50, 45, 20);
    [self.contentBlock addSubview:self.commenLabel];
    
    // 订阅量 count
    self.subscribeCountLabel = [[UILabel alloc] init];
    self.subscribeCountLabel.text = [NSString stringWithFormat:@"%d" , self.expert.subscribeCount];
    self.subscribeCountLabel.font = [UIFont systemFontOfSize:12];
    self.subscribeCountLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.subscribeCountLabel.frame = CGRectMake(self.commenLabel.rightX,
                                        50, 45, 20);
    [self.contentBlock addSubview:self.subscribeCountLabel];
    
    // 虚线
    CGRect dashLineFrame = CGRectMake(28, self.expertAvatarView.bottomY+12,
                                      self.contentBlock.frame.size.width - 28*2,
                                      splite_line_height);
    self.dashLineView = [[LineDashView alloc] initWithFrame:dashLineFrame
                                        lineDashPattern:@[@5, @5]
                                              endOffset:0.495];
    self.dashLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.contentBlock addSubview:self.dashLineView];
    
    // 订单财币
    self.commenLabel = [[UILabel alloc] init];
    self.commenLabel.text = @"订单财币:";
    self.commenLabel.font = [UIFont systemFontOfSize:12];
    self.commenLabel.frame = CGRectMake(35 , self.dashLineView.bottomY+10, 60 , 15);
    [self.contentBlock addSubview:self.commenLabel];
    
    // 订单财币值
    self.subscribeCoinLabel = [[UILabel alloc] init];
    self.subscribeCoinLabel.text = [NSString stringWithFormat:@"%d" , self.expertPrice.point];
    self.subscribeCoinLabel.font = [UIFont systemFontOfSize:12 ];
    self.subscribeCoinLabel.frame = CGRectMake(self.commenLabel.rightX, self.commenLabel.frame.origin.y,
                                               60, 15);
    [self.contentBlock addSubview:self.subscribeCoinLabel];
    
    // 我的积分
    self.commenLabel = [[UILabel alloc] init];
    self.commenLabel.text = @"我的财币:";
    self.commenLabel.font = [UIFont systemFontOfSize:12];
    self.commenLabel.frame = CGRectMake(self.contentBlock.frame.size.width - 140,
                                        self.dashLineView.bottomY+10, 60 , 15);
    [self.contentBlock addSubview:self.commenLabel];
    
    // 我的财币值
    self.myCoinLabel = [[UILabel alloc] init];
    self.myCoinLabel.font = [UIFont systemFontOfSize:12 ];
    self.myCoinLabel.frame = CGRectMake(self.commenLabel.rightX, self.commenLabel.frame.origin.y,
                                               60, 15);
    [self.contentBlock addSubview:self.myCoinLabel];
    
    // 马上订阅
    self.subscribeBtn = [[UIButton alloc] init];
    [self.subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.subscribeBtn.titleLabel setFont:[UIFont systemFontOfSize:14 weight:5]];
    [self.subscribeBtn setBackgroundColor:[ColorUtils colorWithHexString:orange_red_line_color]];
    self.subscribeBtn.frame = CGRectMake(35, self.contentBlock.bottomY+35,
                                         screen_width - 35*2, 46);
    self.subscribeBtn.layer.cornerRadius = 8;
    self.subscribeBtn.layer.masksToBounds = YES;
    self.subscribeBtn.tag = 0;
    [self.bodyView addSubview:self.subscribeBtn];
    
    // 提示说明
    self.coinDesc = [[UILabel alloc] init];
    self.coinDesc.frame = CGRectMake(60, self.subscribeBtn.bottomY + 30, screen_width - 60*2, 0);
    self.coinDesc.font = [UIFont systemFontOfSize:14];
    self.coinDesc.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.coinDesc.numberOfLines = 0;
    [self.coinDesc sizeToFit];
    [self.bodyView addSubview:self.coinDesc];
    self.coinDesc.hidden = YES;
    
    [self renderUserData];
    [self setupEvents];
    [self loadAppInfo];
}

-(void) setupEvents
{
    [self.subscribeBtn addTarget:self action:@selector(subscribeExpert) forControlEvents:UIControlEventTouchUpInside];
}

-(void) renderUserData{
    
    self.myCoinLabel.text = [NSString stringWithFormat:@"%d" , [[[AppStatus sharedInstance] user] getUserCurrentPoint]];
    
    if (self.expertPrice.point > [[[AppStatus sharedInstance] user] getUserCurrentPoint]) {
        
        [self.subscribeBtn setTitle:@"财币不足 去充值" forState:UIControlStateNormal];
        self.subscribeBtn.tag = 1;
        self.coinDesc.hidden = NO;
    }else{
        self.subscribeBtn.tag = 0;
        [self.subscribeBtn setTitle:@"马上订阅" forState:UIControlStateNormal];
        self.coinDesc.hidden = YES;
        
    }
    
}


-(void) subscribeExpert
{
    if (self.subscribeBtn.tag == 0) {  // 财币充足
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认订阅该专家咨询?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"订阅" , nil];
        [alertView show];
        
    }else if (self.subscribeBtn.tag == 1){
        PayViewController *payController = [PayViewController new];
        [self.navigationController pushViewController:payController animated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UserStore sharedStore] subscribeExpert:^(NSError *err) {
            if(err == nil){
                [SVProgressHUD showSuccessWithStatus:@"订阅成功"];
                [[UserStore sharedStore] myUserInfo:^(User *user, NSError *err) {
                    
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_attention_expert object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } expertId:self.expert.id subscribePriceType:self.expertPrice.priceType];
    }
}

- (void)loadAppInfo
{
    [[SystemStore sharedInstance] getAppInfo:^(AppInfo *appInfo, NSError *err) {
        self.coinDesc.text = [NSString stringWithFormat:@"财币充值说明:\n%@" , appInfo.addPointInfo];
        self.coinDesc.frame = CGRectMake(60, self.subscribeBtn.bottomY + 30, screen_width - 60*2, 0);
        self.coinDesc.numberOfLines = 0;
        [self.coinDesc sizeToFit];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
