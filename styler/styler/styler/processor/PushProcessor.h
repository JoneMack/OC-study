//
//  PushProcessor.h
//  styler
//
//  Created by System Administrator on 13-6-20.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

//点击状态栏或是PUSH提示框跳转到app时，app所接收到的push
#define push_from_jump_from_sys_notification 0

//程序处于运行状态时所收到的push
#define push_from_receive_from_active_app 1

//主动请求服务器所获得的push
#define push_from_pull_from_server 2

//从系统push激活app后主动请求服务器所获得的push
#define push_from_pull_from_server_with_jump_sys_notification 3

#import <Foundation/Foundation.h>
#import "PushRecord.h"

@interface PushProcessor : NSObject<UIAlertViewDelegate, NSCoding>

@property (nonatomic, weak) UINavigationController *navigationController;
//表示当前正在处理的PUSH，用于弹出提示框以及后续交互操作
@property (nonatomic, retain) PushRecord *currentPushRecord;

@property (nonatomic, retain) NSMutableArray *unreadPush;
@property (nonatomic, retain) NSMutableArray *readPush;

@property Boolean hasReceivePush;

-(void) processPush:(PushRecord *)push comingFrom:(int)comingFrom naviagtionController:(UINavigationController *)navigationController;
-(void) processPushes:(NSArray *)pushArr comingFrom:(int)comingFrom naviagtionController:(UINavigationController *)navigationController;

//提供一个回调的block用于整合从服务器端获取未读PUSH的逻辑，首先check之前check失败的push，然后再来获取未读push
-(void) checkFailureCheckPush:(void (^)())completionBlock;
-(void) checkUnreadOrderPush;
-(void) checkUnreadNoticePush;
-(void) checkUnreadFeedbackPush;
-(void) checkUnreadSystemPush;

-(BOOL) hasUnreadPush;
-(BOOL) hasUnreadOrderPush;
-(BOOL) hasUnreadFeedbackPush;
-(int) noticePushNum;
-(int) feedbackPushNum;
-(int) systemPushNum;
-(void) cleanReadAndUnreadPushByLogout;

-(void) addUnreadPush:(PushRecord *)pushRecord;
+ (PushProcessor *) sharedInstance;
+(NSString *) savedPath;
+(void) savePushProcessor;
@end
