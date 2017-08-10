//
//  PushRecord.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/24.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "PushRecord.h"

@implementation PushRecord


-(instancetype) initFromDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.notificationType = [dict objectForKey:@"notificationType"];
        NSDictionary *apsDict = [dict objectForKey:@"aps"];
        NSDictionary *alertDict = [apsDict objectForKey:@"alert"];
        self.msg = [alertDict objectForKey:@"body"];
        self.sn = [dict objectForKey:@"sn"];
        self.expertId = [[dict objectForKey:@"expertId"] intValue];
        self.url = [dict objectForKey:@"url"];
    }
    return self;
}

-(BOOL) isOrderPush
{
    if ([self.notificationType isEqualToString:@"order_pay_success"]) {
        return YES;
    }
    return NO;
}

-(BOOL) isFeedbackPush
{
    if ([self.notificationType isEqualToString:@"feedback"]) {
        return YES;
    }
    return NO;
}

@end
