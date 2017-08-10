//
//  Reminder.h
//  styler
//
//  Created by 冯聪智 on 14-8-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StylerTabbar.h"
#import "LeveyTabBarController.h"

@interface Reminder : NSObject <UIApplicationDelegate ,UIAlertViewDelegate>

@property (strong, nonatomic)StylerTabbar *tabbar;
@property (nonatomic, strong) LeveyTabBarController *tabbarController;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIAlertView *alertEvaluationShishangmaoView;

-(void) checkNeedReminded;
-(void) checkUnpaymentAmountHdcOrders;
-(void) checkEvaluationStatus;
-(void) checkNewCreateStylistWorks;

-(void) alertEvaluationShishangmao;


+(Reminder *)sharedInstance;
@end
