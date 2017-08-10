//
//  ExpertMainController.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert.h"


@interface ExpertMainController : UIViewController

@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) UIImageView *expertAvatarView;
@property (nonatomic, strong) UILabel *expertNameView;
@property (nonatomic, strong) UIView *baseInfoView;
@property (nonatomic, strong) UILabel *remarkInfo;
@property (nonatomic, strong) UIView *query;

-(id) initWithExpert:(Expert *)expert;

@end
