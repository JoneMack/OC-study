//
//  PushRecord.m
//  styler
//
//  Created by System Administrator on 13-6-19.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "PushRecord.h"

@implementation PushRecord

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.pushId forKey:@"pushId"];
    [aCoder encodeInt:self.pushType forKey:@"pushType"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
    [aCoder encodeObject:self.sn forKey:@"sn"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInt:self.orderId forKey:@"orderId"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if(self){
        self.pushId = [aDecoder decodeIntForKey:@"pushId"];
        self.pushType = [aDecoder decodeIntForKey:@"pushType"];
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
        self.sn = [aDecoder decodeObjectForKey:@"sn"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.orderId = [aDecoder decodeIntForKey:@"orderId"];
    }
    
    return self;
}

- (void) readFromJSONDictionary:(NSDictionary *)jsonDict{
    self.pushId = [[jsonDict objectForKey:@"id"] intValue];
    self.pushType = [[jsonDict objectForKey:@"notificationType"] intValue];
    self.msg = [jsonDict objectForKey:@"msg"];
    self.sn = [jsonDict objectForKey:@"serialNo"];
    self.url = [jsonDict objectForKey:@"url"];
    self.orderId = [[jsonDict objectForKey:@"orderId"] intValue];
}

+(NSArray *) readPushRecordsFromJsonDictionayArray:(NSArray *)jsonDictArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i = 0; i < [jsonDictArray count]; i++){
        PushRecord *pushRecord = [[PushRecord alloc] init];
        [pushRecord readFromJSONDictionary:[jsonDictArray objectAtIndex:i]];
        [result addObject:pushRecord];
    }
    return result;
}

+(PushRecord *) readFromNotification:(NSDictionary *)notifiUserInfo{
    PushRecord *record = [[PushRecord alloc] init];
    record.pushType = [[notifiUserInfo objectForKey:@"nt"] intValue];
    record.msg = [[[notifiUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    record.sn = [notifiUserInfo objectForKey:@"sn"];
    if((NSNull *)[notifiUserInfo objectForKey:@"oi"] != [NSNull null]){
        record.orderId = [[notifiUserInfo objectForKey:@"oi"] intValue];
    }
    record.url = [notifiUserInfo objectForKey:@"url"];
    return record;
}

-(BOOL) isEqual:(id)object{
    PushRecord *push = (PushRecord *)object;
    return [push.sn isEqual:self.sn];
}

-(BOOL) isOrderPush{
    return self.pushType == push_type_order_confirmed || self.pushType == push_type_order_change_schedule_time || self.pushType == push_type_order_canceled;
}

-(BOOL) isFeedbackPush{
    return self.pushType == push_type_system_feedback;
}

-(PushRecord *) copyWithZone:(NSZone *)zone{
    PushRecord *record = [[PushRecord allocWithZone:zone] init];
    record.pushId = self.pushId;
    record.pushType = self.pushType;
    record.msg = self.msg;
    record.sn = self.sn;
    record.url = self.url;
    record.orderId = self.orderId;
    
    return record;
}

-(NSString *) description{
    return [NSString stringWithFormat:@"pushId:%d, pushType:%d, sn:%@ ,pushMessage:%@", self.pushId, self.pushType, self.sn,self.msg];
}

@end
