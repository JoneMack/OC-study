//
//  PushProcessor.m
//  styler
//
//  Created by System Administrator on 13-6-20.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "PushProcessor.h"
#import "PushStore.h"
#import "OrderDetailInfoController.h"
#import "SystemNoticeController.h"
#import "FeedbackController.h"
#import "OrderStore.h"
#import "StylistProfileController.h"
#import "WorkListController.h"
#import "StylistStore.h"
#import "ContentSort.h"
#import "ContentSortStore.h"
#import "URLDispatcher.h"
#import "OrganizationDetailInfoController.h"
#import <EventKit/EventKit.h>
#import "ChatViewController.h"

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
    [self addUnreadPush:push];
    [[AppStatus sharedInstance] updateBadge];
    
    if ([push isOrderPush]) {
        [self processCalendarEvent:push];
    }
    
    //通过点击系统push接收到的
    if (comingFrom == push_from_jump_from_sys_notification) {
        
        //系统反馈的push跳往反馈界面
        if (push.pushType == push_type_system_feedback) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_receive_feedback_info object:nil];
            [self jumpToFeedback];
        }
        //系统通知的push跳往系统通知界面
        else if(push.pushType == push_type_system_notice){
            [self jumpToSystemNotice];
        }
        //订单变更的push跳往我的订单界面
        else if([push isOrderPush]){
            [self jumpToOrderDetail];
        }
        //系统PUSH
        else if (push.pushType == push_type_system_push)
        {
            [self jumpForSystemPushUrl];
        }
        
    } else if (comingFrom == push_from_receive_from_active_app) {
        //系统反馈的push弹出对话框
        if (push.pushType == push_type_system_feedback) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_receive_feedback_info object:nil];
        }
        //系统通知的push弹出对话框
        else if(push.pushType == push_type_system_notice){
        }
        //订单变更的push弹出对话框
        else if([push isOrderPush]){
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_order_changed object:nil];
            [self displayAlertView];
        }
        //系统PUSH弹出对话框
        else if (push.pushType == push_type_system_push)
        {
            [self displayAlertView];
            [self checkUnreadSystemPush];
        }
        NSNotification *updateNotifi = [NSNotification notificationWithName:notification_name_update_push object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:updateNotifi];
    }
}

//处理多条push
-(void) processPushes:(NSArray *)pushArr comingFrom:(int)comingFrom naviagtionController:(UINavigationController *)navigationController{
    self.navigationController = navigationController;
    [self addUnreadPushArray:pushArr];
    [[AppStatus sharedInstance] updateBadge];

    BOOL hasOrderPush = NO;
    for(int i = 0; i < [pushArr count]; i++){
        PushRecord *push = (PushRecord *)[pushArr objectAtIndex:i];
        if([push isOrderPush]){
            hasOrderPush = YES;
            self.currentPushRecord = push;
            break;
        }else if (push.pushType == push_type_system_push)
        {
            self.currentPushRecord = push;
            break;
        }
    }
    
    if (comingFrom == push_from_pull_from_server) {
        //NSLog(@"直接启动app从服务器端获取push，如果存在订单变更的PUSH弹出提示框进行提示");
        if(hasOrderPush){
            [self displayAlertView];
        }
        else if ([self hasUnreadSystemPush])
        {
            [self displayAlertView];
            [self checkUnreadSystemPush];//目前这时临时性的做法
        }
        else if([self hasUnreadNoticePush]){
            [self checkUnreadNoticePush];
        }
    }else
    {
        self.hasReceivePush = NO ;
    }
    
    //针对PUSH记录进行页面通知
    if(hasOrderPush || [self hasUnreadFeedbackPush]){
        NSNotification *orderUpdateNotifi = [NSNotification notificationWithName:notification_name_update_push object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:orderUpdateNotifi];
    }
    
    
}

-(void) displayAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                    message: self.currentPushRecord.msg
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"查看",nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.currentPushRecord.pushType == push_type_system_push) {
        [self checkUnreadSystemPush];
    }
    
    if (buttonIndex == 1) {
        if ([self.currentPushRecord isOrderPush]) {
            [self jumpToOrderDetail];
        } else if(self.currentPushRecord.pushType == push_type_system_notice){
            [self jumpToSystemNotice];
        } else if(self.currentPushRecord.pushType == push_type_system_feedback){
            [self jumpToFeedback];
        }else if (self.currentPushRecord.pushType == push_type_system_push)
        {
            [self jumpForSystemPushUrl];
        }
    }
}

-(void)jumpForSystemPushUrl
{
    if (self.currentPushRecord.url.length > 0) {
        //ex 为跳转到profile页 cs 为跳转到分类子页面
        NSArray * pathArray = [self.currentPushRecord.url componentsSeparatedByString:@"/"];
        if ([[pathArray objectAtIndex:0] isEqualToString:@"ex"]) {
            [SVProgressHUD showWithStatus:@"正在加载,请稍后.."];
            StylistStore * es = [StylistStore sharedStore];
            [es getStylist:^(Stylist * stylist,NSError * err){
                [SVProgressHUD dismiss];
                if (err == nil) {
                    StylistProfileController *spc = [[StylistProfileController alloc] init];
                    spc.stylist = stylist;
                    [self.navigationController pushViewController:spc animated:YES];
                }
            }stylistId:[[pathArray objectAtIndex:1] intValue] refresh:YES];
        }else if([[pathArray objectAtIndex:0] isEqualToString:@"cs"]){
            [SVProgressHUD showWithStatus:@"正在加载,请稍后.."];
            ContentSortStore * cs = [ContentSortStore sharedStore];
            [cs getContentSortInfo:^(ContentSort * contentSort,NSError * err){
                [SVProgressHUD dismiss];
                [URLDispatcher dispatchWithContentSort:contentSort.id contentSortName:contentSort.name extendParam:contentSort.extendParam contentModeType:contentSort.contentModeType nav:self.navigationController];
            }contentSortId:[pathArray objectAtIndex:1] refresh:YES];
        }else if([[pathArray objectAtIndex:0] isEqualToString:@"or"]){
            NSString *organizationId = [pathArray objectAtIndex:1];
            OrganizationDetailInfoController *odic = [[OrganizationDetailInfoController alloc] initWithOrganizationId:[organizationId intValue]];
            
            [self.navigationController pushViewController:odic animated:YES];
             NSLog(@"self.currentPushRecord.url%@",self.currentPushRecord.url);
        }
    }
    [self checkUnreadSystemPush];
}

-(void) jumpToOrderDetail{
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[OrderDetailInfoController class]]) {
            OrderDetailInfoController *odic = ((OrderDetailInfoController *)vc);
            
            if (odic.order.id == self.currentPushRecord.orderId ) {
                [odic orderStatusChanged];
                [self.navigationController popToViewController:vc animated:YES];
                [self checkUnreadOrderPush];
                return;
            }
        }
    }
        OrderDetailInfoController *odc = [[OrderDetailInfoController alloc] initWithOrderId:self.currentPushRecord.orderId];

        [self.navigationController pushViewController:odc animated:YES];
}

-(void) jumpToSystemNotice{
    SystemNoticeController *snc = [[SystemNoticeController alloc] init];
    [self.navigationController pushViewController:snc animated:YES];
}

-(void) jumpToFeedback{
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ChatViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }
    }
    ChatViewController *fc = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:fc animated:YES];
}

-(BOOL) hasUnreadPush{
    if(self.unreadPush != nil && [self.unreadPush count] > 0)
        return YES;
    return NO;
}

-(BOOL) hasUnreadOrderPush{
    for (NSObject *obj in self.unreadPush) {
        PushRecord *push = (PushRecord *)obj;
        if([push isOrderPush]){
            return YES;
        }
    }
    
    return NO;
}

-(BOOL) hasUnreadSystemPush{
    for (NSObject *obj in self.unreadPush) {
        PushRecord *push = (PushRecord *)obj;
        if(push.pushType == push_type_system_push){
            return YES;
        }
    }
    
    return NO;
}

-(BOOL) hasUnreadFeedbackPush{
    for (NSObject *obj in self.unreadPush) {
        PushRecord *push = (PushRecord *)obj;
        if(push.pushType == push_type_system_feedback){
            return YES;
        }
    }
    
    return NO;
}

-(BOOL) hasUnreadNoticePush{
    for (NSObject *obj in self.unreadPush) {
        PushRecord *push = (PushRecord *)obj;
        if(push.pushType == push_type_system_notice){
            return YES;
        }
    }
    
    return NO;
}

-(int) noticePushNum{
    int i = 0;
    for (NSObject *obj in self.unreadPush) {
        PushRecord *push = (PushRecord *)obj;
        if(push.pushType == push_type_system_notice){
            i++;
        }
    }
    return i;
}

-(int) feedbackPushNum{
    int i = 0;
    for (NSObject *obj in self.unreadPush) {
        PushRecord *push = (PushRecord *)obj;
        if(push.pushType == push_type_system_feedback){
            i++;
        }
    }
    return i;
}

-(int) systemPushNum
{
    int i = 0;
    for (NSObject *obj in self.unreadPush) {
        PushRecord *push = (PushRecord *)obj;
        if(push.pushType == push_type_system_push){
            i++;
        }
    }
    return i;
}

-(NSArray *) unReadSystemPush
{
    NSArray * pushArray = [PushProcessor sharedInstance].unreadPush;
    NSMutableArray * unreadSystemPush = [[NSMutableArray alloc]init];
    for (int i = 0; i < pushArray.count; i++) {
        PushRecord * push = [pushArray objectAtIndex:i];
        if (push.pushType == push_type_system_push) {
            [unreadSystemPush addObject:push];
        }else
        {
            continue ;
        }
    }
    return unreadSystemPush;
}

//check所有的订单PUSH
-(void) checkUnreadOrderPush{
    [self checkUnreadPush:push_type_order_changed];
}

-(void) checkUnreadNoticePush{
    [self checkUnreadPush:push_type_system_notice];
}

-(void) checkUnreadFeedbackPush{
    for (PushRecord * push in self.unreadPush) {
        if ([push.sn intValue] == -1) {
            [self.unreadPush removeObject:push];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_push object:nil];
            
            [[AppStatus sharedInstance] updateBadge];
            [PushProcessor savePushProcessor];
        }
    }
    
    [self checkUnreadPush:push_type_system_feedback];
}

-(void)checkUnreadSystemPush
{
    
    [self checkUnreadPush:push_type_system_push];
}

-(void) checkUnreadPush:(int)pushType{
    if(![[AppStatus sharedInstance] isConnetInternet])
        return ;
    //将未读的系统通知PUSH从未读PUSH中删除，同时加入到readPush中，表示本地已完成了阅读，然后反馈到服务器端
    NSEnumerator *enu = [self.unreadPush objectEnumerator];
    PushRecord *push = nil;

    NSMutableArray *checkedPush = [[NSMutableArray alloc] init];
    NSMutableArray *checkedSN = [[NSMutableArray alloc] init];
    while (push = (PushRecord *)[enu nextObject]) {
        BOOL match = NO;
        if (pushType == push_type_system_notice || pushType == push_type_system_feedback || pushType == push_type_system_push) {
            if(push.pushType == pushType){
                match = YES;
            }
        }else if(pushType == push_type_order_changed){
            if([push isOrderPush])
                match = YES;
        }
        if(match){
            [self addReadPush:push];
            [checkedPush addObject:push];
            [checkedSN addObject:[push.sn copy]];
        }
    }

    [self.unreadPush removeObjectsInArray:checkedPush];
    [[AppStatus sharedInstance] updateBadge];
    [PushProcessor savePushProcessor];
    
    //本地数据已完成check所以发送通知
    NSNotification *updateNotifi = [NSNotification notificationWithName:notification_name_update_push object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:updateNotifi];
    if ([checkedSN count]>0) {
        [[PushStore sharedStore] checkPush:^(NSError *err) {
            if (err == nil) {
                //清除掉本地已完成了阅读的PUSH
                NSMutableArray *feedbackCompletePush = [[NSMutableArray alloc] init];
                for (int i = 0; i < [self.readPush count]; i++) {
                    PushRecord *push = (PushRecord *)[self.readPush objectAtIndex:i];
                    for(NSString *sn in checkedSN){
                        if([sn isEqualToString:push.sn]){
                            [feedbackCompletePush addObject:push];
                            break;
                        }
                    }
                }
                
                [self.readPush removeObjectsInArray:feedbackCompletePush];
                [PushProcessor savePushProcessor];
            }
            
        } pushSNArray:checkedSN];
    }
}

-(void) checkFailureCheckPush:(void (^)())completionBlock{
    if (self.readPush != nil && [self.readPush count]>0) {
        NSMutableArray *checkedSN = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.readPush count]; i++) {
            PushRecord *push = [self.readPush objectAtIndex:i];
            [checkedSN addObject:[push.sn copy]];
        }
        
        [[PushStore sharedStore] checkPush:^(NSError *err) {
            if (err == nil) {
                //清除掉本地已完成了阅读的PUSH
                [self.readPush removeAllObjects];
                [PushProcessor savePushProcessor];
                
                completionBlock();
            }
        } pushSNArray:checkedSN];
    }else{
        completionBlock();
    }
}

-(void) addUnreadPush:(PushRecord *)pushRecord{
    if(self.unreadPush == nil){
       self.unreadPush = [[NSMutableArray alloc] init];
    }
   
    BOOL added = NO;
    for(NSObject *obj in self.unreadPush){
        PushRecord *push = (PushRecord *)obj;
        if([push.sn isEqual:pushRecord.sn]){
            added = YES;
            break;
        }
    }

    if(!added){
        [self.unreadPush addObject:pushRecord];
        [PushProcessor savePushProcessor];
    }
}

-(void) addUnreadPushArray:(NSArray *)pushRecordArray{
    if(self.unreadPush == nil)
        self.unreadPush = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [pushRecordArray count]; i++) {
        BOOL added = NO;
        for (NSObject *obj in self.unreadPush) {
            PushRecord *push = (PushRecord *)obj;
            if([((PushRecord *)[pushRecordArray objectAtIndex:i]).sn isEqual:push.sn]){
                added = YES;
                break;
            }
        }
        if(!added){
            [self.unreadPush addObject:[pushRecordArray objectAtIndex:i]];
        }
    }
    [PushProcessor savePushProcessor];
}

-(void) addReadPush:(PushRecord *)pushRecord{
    if(self.readPush == nil){
        self.readPush = [[NSMutableArray alloc] init];
    }
    
    BOOL added = NO;
    for(NSObject *obj in self.readPush){
        PushRecord *push = (PushRecord *)obj;
        if([push.sn isEqual:pushRecord.sn]){
            added = YES;
            break;
        }
    }
    
    if(!added){
        [self.readPush addObject:pushRecord];
    }
}


+(NSString *) savedPath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"pushProcessor.archive"];
    return documentDirectory;

}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.unreadPush forKey:@"unreadPush"];
    [aCoder encodeObject:self.readPush forKey:@"readPush"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.unreadPush = [aDecoder decodeObjectForKey:@"unreadPush"];
        self.readPush = [aDecoder decodeObjectForKey:@"readPush"];
    }
    
    return self;
}

+(void)savePushProcessor{
    [NSKeyedArchiver archiveRootObject:[PushProcessor sharedInstance] toFile:[PushProcessor savedPath]];
}

//因用户退出登录而清除掉订单及反馈相关的PUSH
-(void) cleanReadAndUnreadPushByLogout{
    NSMutableArray *needRemovePush = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.unreadPush.count; i++) {
        PushRecord *push = self.unreadPush[i];
        if([push isOrderPush] || push.pushType == push_type_system_feedback){
            [needRemovePush addObject:push];
        }
    }
    [self.unreadPush removeObjectsInArray:needRemovePush];
    
    for(int i = 0; i < self.readPush.count; i++){
        PushRecord *push = self.unreadPush[i];
        if([push isOrderPush] || push.pushType == push_type_system_feedback){
            [needRemovePush addObject:push];
        }
    }
    [self.readPush removeObjectsInArray:needRemovePush];
    
    [[AppStatus sharedInstance] updateBadge];
    [PushProcessor savePushProcessor];
    
    //发送通知
    NSNotification *updateNotifi = [NSNotification notificationWithName:notification_name_update_push object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:updateNotifi];
}

-(void)processCalendarEvent:(PushRecord *)push{
    //NSLog(@">>>>>>>  订单id: %d", push.orderId);
    [[OrderStore sharedStore] getMyOrder:^(ServiceOrder *order, NSError *err) {
        AppStatus *as = [AppStatus sharedInstance];
        EKEventStore *eventDB = [[EKEventStore alloc] init];
        if(push.pushType == push_type_order_confirmed){
            if (as.iosVersion < 6.0f) {
                [self addCalendarEvent:eventDB order:order];
            }else{
                [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError *error) {
                    [self addCalendarEvent:eventDB order:order];
                }];
            }
        }else if(push.pushType == push_type_order_change_schedule_time){
            if (as.iosVersion < 6.0f) {
                [self updateCalendarEventTime:eventDB order:order];
            }else{
                [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError *error) {
                    [self updateCalendarEventTime:eventDB order:order];
                }];
            }
        }else if(push.pushType == push_type_order_canceled){
            if (as.iosVersion < 6.0f) {
                [self removeCalendarEvent:eventDB order:order];
            }else{
                [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError *error) {
                    [self removeCalendarEvent:eventDB order:order];
                }];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_order_changed object:nil];
        
    } orderId:push.orderId];
}

-(void) addCalendarEvent:(EKEventStore *)eventDB order:(ServiceOrder *)order{
    NSLog(@">>>>>>>>>准备添加日历事件");
    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
    myEvent.title     = [NSString stringWithFormat:@"预约%@%@[styler]", order.stylist.nickName, order.orderTitle];
    myEvent.location = order.stylist.organization.address;
    myEvent.startDate = [order getScheduleTime];
    
    myEvent.endDate = [order getScheduleCompleteTime];
    myEvent.allDay = NO;
    
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-60*60];
    [myEvent addAlarm:alarm];
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    [eventDB saveEvent:myEvent span:EKSpanThisEvent commit:YES error:nil];
    NSLog(@">>>>>>>添加日历事件成功");
}

-(void) updateCalendarEventTime:(EKEventStore *)eventDB order:(ServiceOrder *)order{
    NSDate *startDate = [[order getScheduleTime] copy];
    startDate = [startDate dateByAddingTimeInterval:-60*60*24*7];
    
    NSDate *endDate = [order getScheduleCompleteTime];
    NSLog(@">>>>>>>>>>>order end date: %@", endDate);
    if (!endDate) {
        return;
    }
    NSPredicate *predicate = [eventDB predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    
    NSArray *events = [eventDB eventsMatchingPredicate:predicate];
    if(events == nil || events.count == 0)
        return ;
    NSString *title = [NSString stringWithFormat:@"预约%@%@[styler]", order.stylist.nickName, order.orderTitle];
    for(int i = 0; i<events.count; i++){
        EKEvent *event = (EKEvent *)events[i];
        if([event.title isEqualToString:title]){
            event.startDate = [order getScheduleTime];
            event.endDate = [order getScheduleCompleteTime];
            event.allDay = NO;
            [eventDB saveEvent:event span:EKSpanThisEvent commit:YES error:nil];
            return ;
        }
    }
}

-(void) removeCalendarEvent:(EKEventStore *)eventDB order:(ServiceOrder *)order{
    NSLog(@">>>>>>>>>准备删除日历事件");
    NSDate *startDate = [order getScheduleTime];
    startDate = [startDate dateByAddingTimeInterval:-60*60*24*7];
    
    NSDate *endDate = [order getScheduleCompleteTime];
    endDate = [endDate dateByAddingTimeInterval:60*60*24*7];
    
    NSPredicate *predicate = [eventDB predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    
    NSArray *events = [eventDB eventsMatchingPredicate:predicate];
    if(events == nil || events.count == 0)
        return ;
    NSString *title = [NSString stringWithFormat:@"预约%@%@[时尚猫]", order.stylist.nickName, order.orderTitle];
    for(int i = 0; i<events.count; i++){
        EKEvent *event = (EKEvent *)events[i];
        if([event.title isEqualToString:title]){
            [eventDB removeEvent:event span:EKSpanThisEvent commit:YES error:nil];
            return ;
        }
    }
}

+ (PushProcessor *) sharedInstance{
    static PushProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        NSString *path = [PushProcessor savedPath];
        sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(sharedInstance == nil)
            sharedInstance = [[PushProcessor alloc] init];
    }
    
    return sharedInstance;
}

@end
