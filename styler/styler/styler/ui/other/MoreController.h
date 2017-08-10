//
//  MoreController.h
//  styler
//
//  Created by aypc on 13-10-1.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MoreController : UIViewController <UIAlertViewDelegate,ISSShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet UIView *line5;
@property (weak, nonatomic) IBOutlet UIView *line6;
@property (weak, nonatomic) IBOutlet UIView *line7;
@property (weak, nonatomic) IBOutlet UIView *aboutUs;

//
@property (weak, nonatomic) IBOutlet UIView *about_us_view;
@property (weak, nonatomic) IBOutlet UIView *good_Evaluation;
@property (weak, nonatomic) IBOutlet UIButton *recommend_to_friend;

@property (weak, nonatomic) IBOutlet UIButton *cooperation_app_recommend;


@property (weak, nonatomic) IBOutlet UIView *system_img;
@property (weak, nonatomic) IBOutlet UIView *clear_view;

@property (weak, nonatomic) IBOutlet UILabel *recommend;
@property (weak, nonatomic) IBOutlet UILabel *about;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *cooperationAppLab;

@property (weak, nonatomic) IBOutlet UILabel *systemMessage;
@property (weak, nonatomic) IBOutlet UILabel *clear;
@property (weak, nonatomic) IBOutlet UILabel *cache;
@property (weak, nonatomic) IBOutlet UIView *clearAndEvalustion;

@end
