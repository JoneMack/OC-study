//
//  ExpertDetailHeaderView.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/14.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert.h"

@interface ExpertDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic , strong) UIView *headerContentBlockView;

@property (nonatomic , strong) UIButton *goBackBtn; // 返回
@property (nonatomic , strong) UIButton *shareBtn; // 分享
@property (nonatomic , strong) UIButton *setting;  // 设置个性化

@property (nonatomic , strong) UIImageView *expertAvatarImgView;   // 专家头像
@property (nonatomic , strong) UILabel *expertNameLabel;  // 专家名

@property (nonatomic , strong) UIView *commonView;      // 通用 view
@property (nonatomic , strong) UILabel *msgLabel;    // 通用 label
@property (nonatomic , strong) UILabel *subscribeLabel;

@property (nonatomic , strong) UILabel *infoCountabel;       // 财讯数
@property (nonatomic , strong) UILabel *subscribeCoinLabel;  // 订阅数
@property (nonatomic , strong) UILabel *authInfo;

@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , strong) UINavigationController *navigationController;

@property (nonatomic , weak) Expert *expert;

-(instancetype) initWithExpert:(Expert *)expert navigationController:(UINavigationController *)navigationController;

@end
