//
//  AccountSessionSpringBoard.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "AccountSessionSpringBoard.h"
#import "UserCenterViewController.h"

@implementation AccountSessionSpringBoard

+(void) jumpToAccountSessionFrom:(UIViewController *)viewController accountSessionFrom:(int)accountSessionFrom
{
    if (accountSessionFrom == account_session_from_user_center && [[AppStatus sharedInstance] logined]) {
        NSLog(@"进行跳转到 用户中心》》》");
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[UserCenterViewController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }else{
        NSLog(@"跳转时验证没有通过");
    }
}

@end
