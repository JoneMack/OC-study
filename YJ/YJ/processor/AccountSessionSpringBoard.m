//
//  AccountSessionSpringBoard.m
//  styler
//
//  Created by System Administrator on 13-6-27.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "AccountSessionSpringBoard.h"

@implementation AccountSessionSpringBoard

+(void) jumpToAccountSessionFrom:(UIViewController *)viewController accountSessionFrom:(int)accountSessionFrom{
    NSNotification *notification = [NSNotification notificationWithName:@"sessionUpdate" object:nil];
    NSNotification *notification2 = [NSNotification notificationWithName:notification_name_user_login object:nil userInfo:[NSDictionary dictionaryWithObject:[[NSNumber alloc] initWithInt:accountSessionFrom] forKey:notification_name_pn_account_session_from]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    
    if(accountSessionFrom == account_session_from_index){
        [viewController.navigationController popToRootViewControllerAnimated:YES];
    }    else{
        [viewController.navigationController popToRootViewControllerAnimated:YES];
    }
//    account_session_from_user_diagnosisOnRightEyes
}

@end
