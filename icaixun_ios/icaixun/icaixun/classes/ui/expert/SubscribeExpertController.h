//
//  SubscribeExpertController.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/23.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert.h"
#import "LineDashView.h"
#import "ExpertPriceList.h"

@interface SubscribeExpertController : UIViewController <UIAlertViewDelegate>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bodyView;

@property (nonatomic , strong) UIView *contentBlock;
@property (nonatomic , strong) UIImageView *contentBgView;
@property (nonatomic , strong) UIImageView *expertAvatarView;
@property (nonatomic , strong) UILabel *commenLabel;
@property (nonatomic , strong) LineDashView *dashLineView;

@property (nonatomic , strong) UILabel *expertNameLabel;
@property (nonatomic , strong) UILabel *infoCountabel;
@property (nonatomic , strong) UILabel *subscribeCountLabel;
@property (nonatomic , strong) UILabel *subscribeCoinLabel;
@property (nonatomic , strong) UILabel *myCoinLabel;

@property (nonatomic , strong) UIButton *subscribeBtn;
@property (nonatomic , strong) UILabel *coinDesc;
@property (nonatomic , strong) Expert *expert;
@property (nonatomic , strong) ExpertPriceList *expertPrice;


-(instancetype) initWithExpert:(Expert *)expert expertPrice:(ExpertPriceList *)expertPrice;

@end
