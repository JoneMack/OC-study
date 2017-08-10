//
//  Reminder.m
//  styler
//
//  Created by 冯聪智 on 14-8-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "Reminder.h"
#import "HdcStore.h"
#import "EvaluationStore.h"
#import "StylistWorkStore.h"
#import "UserHdcController.h"
#import "AppDelegate.h"
#import "UserHdcController.h"
#import "MyOrderController.h"
#import "UserHdc.h"
#import "Constant.h"

@implementation Reminder


/**
    提醒器的主方法，用来检查各种需要被提醒的事件
 */
-(void) checkNeedReminded{
    [self checkUnpaymentAmountHdcOrders];
    [self checkEvaluationStatus];
    
    // 作品列表 检查 最新的作品
//    [self checkNewCreateStylistWorks];
}

//app第二次启动时才会提示评价时尚猫 , 只在启动时检查
-(void) alertEvaluationShishangmao{
    Reminder *reminder = [Reminder sharedInstance];
    AppStatus *as = [AppStatus sharedInstance];
    if (!as.hasEvaluateShishangmao && as.launchAPPCount >= 1) {
        reminder.alertEvaluationShishangmaoView = [[UIAlertView alloc] initWithTitle:@"去给时尚猫个好评鼓励下吧！" message:nil delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"马上评价", nil];
        [reminder.alertEvaluationShishangmaoView show];
    }
    
    ++as.launchAPPCount;
    [AppStatus saveAppStatus];
}

-(void) checkUnpaymentAmountHdcOrders{
    
    AppStatus *as = [AppStatus sharedInstance];
    if (!as.logined) {
        as.hasUnpaymentHdc = NO;
        [AppStatus saveAppStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_has_unpayment_hdc object:nil];
        return ;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [HdcStore checkUnpaymentAmountHdcs:^(NSError *error) {
        }];
    });
}


-(void) checkNewCreateStylistWorks{
    AppStatus *as = [AppStatus sharedInstance];
    if (as.latestWorkCreateTime == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        StylistWorkStore *stylistWorkStore = [StylistWorkStore sharedStore];
        NSString *url = [NSString stringWithFormat:@"/works?orderType=7&createTime=%lld",[DateUtils longlongintFromDate: as.latestWorkCreateTime]];
        [stylistWorkStore getStylistWorksBySearcher:^(Page *page, NSError *err) {

            if (page != nil) {
                if (page.items.count>0) {
                    as.hasNewStylistWorks = YES;
                }else{
                    as.hasNewStylistWorks = NO;
                }
                
                [AppStatus saveAppStatus];
                [[AppStatus sharedInstance] updateBadge];
                // 有新的作品
                [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_has_new_stylist_works object:nil];
            }
        } url:url refresh:NO];
    });
}

-(void) checkEvaluationStatus{
    AppStatus *as = [AppStatus sharedInstance];
    if (!as.logined) {
        as.hasUnevaluationOrder = NO;
        [AppStatus saveAppStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_has_unevaluate_order object:nil];
        return ;
    }
    
    StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
    if ([tabBar.getCurrentPageName isEqualToString: my_unevalaution_title]
            ||[tabBar.getCurrentPageName isEqualToString: my_order_title]
            ||[tabBar.getCurrentPageName isEqualToString: page_name_buy_hdc]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [EvaluationStore checkEvaluationStatus:^(NSError *error){
            if (error == nil && as.hasUnevaluationOrder) {
                [Reminder showUnEvaluationAlertView];
            }
        }];
    });
}

+(void) showUnEvaluationAlertView{
    Reminder *reminder = [Reminder sharedInstance];
    if (reminder.alertView == nil) {
        reminder.alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                    message:@"您有未评价预约，快分享出您的体验吧。"
                                                   delegate:reminder
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"评价" , nil];
    }
    [reminder.alertView show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 我的美发卡的跳转
//    if (buttonIndex == 1) {  // 点查看进行跳转
//
//        StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
//        //将当前的视图堆栈pop到根视图
//        if ([tabBar getSelectedIndex] != tabbar_item_index_me) {
//            UINavigationController *navController = [tabBar getSelectedViewController];
//            [navController popToRootViewControllerAnimated:YES];
//        }
//        
//        //切换视图堆栈到“个人中心”
//        [tabBar setSelectedIndex:tabbar_item_index_me];
//        UINavigationController *navController = [tabBar getSelectedViewController];
//        
//        NSArray *cardStatus = [[NSArray alloc] initWithObjects:@(user_card_status_unpayment), nil];
//        UserHdcController *userHdcController = [[UserHdcController alloc] initWithCardStatus:cardStatus];
//        [navController pushViewController:userHdcController animated:YES];
//        [tabBar.tabbarController hidesTabBar:YES animated:YES];
//        
//    }
    // 待评价的跳转
    if (buttonIndex == 1) {
        
        Reminder *reminder = [Reminder sharedInstance];
        AppStatus *as = [AppStatus sharedInstance];
        if (alertView == reminder.alertEvaluationShishangmaoView) {
            if (buttonIndex == 1) {
                as.hasEvaluateShishangmao = YES;
                [AppStatus saveAppStatus];
                NSURL *appUrl = [[NSURL alloc] initWithString:shishangmaoAppURL];
                [[UIApplication sharedApplication] openURL:appUrl];
            }

        } else if(alertView == reminder.alertView){
            StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
            //将当前的视图堆栈pop到根视图
            if ([tabBar getSelectedIndex] != tabbar_item_index_me) {
                UINavigationController *navController = [tabBar getSelectedViewController];
                [navController popToRootViewControllerAnimated:YES];
            }
            
            //切换视图堆栈到“个人中心”
            [tabBar setSelectedIndex:tabbar_item_index_me];
            UINavigationController *navController = [tabBar getSelectedViewController];
            
            
            MyOrderController *unevaluation = [[MyOrderController alloc] init];
            unevaluation.filteType = filte_type_unevaluation;
            [navController pushViewController:unevaluation animated:YES];
            [tabBar.tabbarController hidesTabBar:YES animated:YES];
            [MobClick event:log_event_name_goto_unevaluation];

        }
        
    }
}

+(Reminder *)sharedInstance{
    static Reminder *sharedInstance = nil;
    if(sharedInstance == nil){
        if(sharedInstance == nil)
            sharedInstance = [[Reminder alloc] init];
    }
    
    return sharedInstance;
}

@end
