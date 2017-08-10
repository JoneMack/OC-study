//
//  PayViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/9.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic , strong) UIView *bodyView;

@property (nonatomic , strong) UILabel *commonTextLabel;
@property (nonatomic , strong) UILabel *myCoinLabel;

@property (nonatomic , strong) UIView *commonView;  // 边框 ， 线

@property (nonatomic , strong) UIButton *addCoinBtn;
@property (nonatomic , strong) UIButton *reduceCoinBtn;
@property (nonatomic , strong) UITextField *addCoinField;

@property (nonatomic , strong) UIImageView *weixinIconView;
@property (nonatomic , strong) UIImageView *selectedView;



@property (nonatomic , strong) UIButton *payBtn;


@end
