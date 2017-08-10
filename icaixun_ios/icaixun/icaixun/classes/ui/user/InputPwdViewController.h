//
//  InputPwdViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface InputPwdViewController : UIViewController

@property (nonatomic , strong) User *user;

@property (nonatomic , copy) NSString *oldPwd;

@end
