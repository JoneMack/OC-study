//
//  PushProcessor.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "PushProcessor.h"
#import "ExpertDetailViewController.h"
#import "LeveyTabBarController.h"
#import "IndexController.h"
#import "ExpertStore.h"

@implementation PushProcessor

//处理单条push
-(void) processPush:(PushRecord *)push comingFrom:(int)comingFrom naviagtionController:(UINavigationController *)navigationController{
    self.navigationController = navigationController;
    if ([self.currentPushRecord.sn isEqualToString:push.sn]) {
        return ;
    }
        
    //如果是订单通知以及客服反馈通知，而用户未登录则返回
    if (([push isOrderPush] || [push isFeedbackPush]) && ![AppStatus sharedInstance].logined) {
        return ;
    }

    self.currentPushRecord = push;
//    [self addUnreadPush:push];
//    [[AppStatus sharedInstance] updateBadge];
//    
//    if ([push isOrderPush]) {
//        [self processCalendarEvent:push];
//    }
//    
//    //通过点击系统push接收到的
//    if (comingFrom == push_from_jump_from_sys_notification) {
//        
//        //系统反馈的push跳往反馈界面
//        if (push.pushType == push_type_system_feedback) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_receive_feedback_info object:nil];
//            [self jumpToFeedback];
//        }
//        //系统通知的push跳往系统通知界面
//        else if(push.pushType == push_type_system_notice){
//            [self jumpToSystemNotice];
//        }
//        //订单变更的push跳往我的订单界面
//        else if([push isOrderPush]){
//            [self jumpToOrderDetail];
//        }
//        //系统PUSH
//        else if (push.pushType == push_type_system_push)
//        {
//            //            NSLog(@">>>>>>>>>>>>>>>>>>来这儿来了 nt= 1");
//            [self jumpForSystemPushUrl];
//        }
//        
//    } else
    if (comingFrom == push_from_receive_from_active_app) {
        // 专家消息弹出对话框
        if ([push.notificationType isEqualToString:notification_type_expert_message]) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_receive_expert_message object:nil];
            [self displayAlertView];
        }
        //系统通知的push弹出对话框
//        else if(push.pushType == push_type_system_notice){
//        }
//        //订单变更的push弹出对话框
//        else if([push isOrderPush]){
//            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_order_changed object:nil];
//            [self displayAlertView];
//        }
//        //系统PUSH弹出对话框
//        else if (push.pushType == push_type_system_push)
//        {
//            [self displayAlertView];
//            [self checkUnreadSystemPush];
//        }
//        NSNotification *updateNotifi = [NSNotification notificationWithName:notification_name_update_push object:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:updateNotifi];
    }
}



-(void) displayAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                    message: self.currentPushRecord.msg
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"查看",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([self.currentPushRecord.notificationType isEqualToString:notification_type_expert_message]) {
            NSArray *viewControllers = self.navigationController.viewControllers;
            for (UIViewController *viewController in viewControllers) {
                if ([viewController isKindOfClass:NSClassFromString(@"ExpertDetailViewController")]){
                    ExpertDetailViewController *expertDetailController = (ExpertDetailViewController *)viewController;
                    if (expertDetailController.expert.id == self.currentPushRecord.expertId) {
                        [expertDetailController transformEvent:event_index_init_load];
                        return;
                    }
                }
                [ExpertStore getMyAttentionExperts:^(NSArray *experts, NSError *err) {
                    for (Expert *expert in experts) {
                        if (self.currentPushRecord.expertId == expert.id) {
                         
                            ExpertDetailViewController *expertDetailViewController = [[ExpertDetailViewController alloc] initWithExpert:expert];
                            [self.navigationController pushViewController:expertDetailViewController animated:YES];
                            break;
                        }
                    }
                }];
                return;
            }
        }
    }
}



+(PushProcessor *) sharedInstance
{
    static PushProcessor *instance = nil;
    if (instance == nil) {
        instance = [PushProcessor new];
    }
    return instance;
}




@end
