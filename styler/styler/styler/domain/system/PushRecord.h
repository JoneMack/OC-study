//
//  PushRecord.h
//  styler
//
//  Created by System Administrator on 13-6-19.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define push_type_system_feedback 3
#define push_type_system_notice 4
#define push_type_system_push 6

#define push_type_order_changed 80
#define push_type_order_confirmed 7
#define push_type_order_change_schedule_time 8
#define push_type_order_canceled 9



#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface PushRecord : NSObject<JSONSerializable,NSCopying,NSCoding>

@property int pushId;
@property int pushType;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *sn;
@property (nonatomic, copy) NSString *url;
@property int orderId;

-(BOOL) isOrderPush;
-(BOOL) isFeedbackPush;

+(PushRecord *) readFromNotification:(NSDictionary *)notifiUserInfo;
+(NSArray *) readPushRecordsFromJsonDictionayArray:(NSArray *)jsonDictArray;
@end
