//
//  ChangePwdViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/7.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : UIViewController

@property (nonatomic , strong) NSString *env;  // outer:外部，在用户还没有登录成功之时，
                                               // inner:内部，用户登录成功，在里面个性密码时

@property (nonatomic , copy) NSString *userId; // 外部赋进来的
@property (nonatomic , copy) NSString *mobileNo;  // 外部赋进来的

@end
