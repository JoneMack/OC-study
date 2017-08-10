//
//  PushProcessor.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
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

@interface PushProcessor : NSObject <UIAlertViewDelegate>

@property (nonatomic , strong) UINavigationController *navigationController;
@property (nonatomic , strong) PushRecord *currentPushRecord;

+(PushProcessor *) sharedInstance;

-(void) processPush:(PushRecord *)push comingFrom:(int)comingFrom naviagtionController:(UINavigationController *)navigationController;


@end
