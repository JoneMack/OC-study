//
//  LoginViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineDashView.h"
#import "IcxTabbar.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic , assign) int accountSessionFrom;
@property (nonatomic , strong) IcxTabbar *icxTabbar;


-(instancetype) initWithAccountSessionFrom:(int)accountSessionFrom;

@end
