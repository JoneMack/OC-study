//
//  PushRecord.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/24.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define notification_type_expert_message        @"expert_message"
#define notification_type_order_pay_success     @"order_pay_success"
#define notification_type_recommend_article     @"recommend_article"
#define notification_type_recommend_activity    @"recommend_activity"
#define notification_type_system_message        @"system_message"
#define notification_type_feedback              @"feedback"


#import <Foundation/Foundation.h>

@protocol PushRecord

@end

@interface PushRecord : JSONModel

//@property int pushId;
@property (nonatomic, copy) NSString<Optional> *notificationType;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, copy) NSString<Optional> *sn;
@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *orderId;
@property (nonatomic, assign) int expertId;

-(BOOL) isOrderPush;
-(BOOL) isFeedbackPush;

-(instancetype) initFromDict:(NSDictionary *)dict;

@end
