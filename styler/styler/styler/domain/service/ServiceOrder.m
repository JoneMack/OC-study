//
//  ServiceOrder.m
//  styler
//
//  Created by System Administrator on 13-6-11.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "ServiceOrder.h"
#import "CommonItemTxt.h"
#import "Constant.h"

@implementation ServiceOrder

-(NSString *)statusTxt{
    
    if(self.orderStatus == order_status_waiting_confirm) {
        return @"等待确认";
    }else if(self.orderStatus == order_status_confirmed){
        return @"预约成功";
    }else if(self.orderStatus == order_status_completed && self.evaluationStatus == evaluation_status_unpost){
        return @"待评价";
    }else if(self.orderStatus == order_status_completed && self.evaluationStatus == evaluation_status_post){
        return @"已评价";
    }else if(self.orderStatus == order_status_canceled){
        return @"已取消";
    }
    return @"";
}

-(NSDate *) getCreateTime
{
    return [NSDate dateWithTimeIntervalSince1970:self.createTime/1000];
}

-(NSDate *) getScheduleTime
{
    return [NSDate dateWithTimeIntervalSince1970:self.scheduleTime/1000];
}

-(NSDate *) getScheduleCompleteTime
{
    return [NSDate dateWithTimeIntervalSince1970:self.scheduleCompleteTime/1000];
}

-(NSArray *) getOrderDetailCommonItemTxts{
    NSMutableArray *detailInfoArray = [[NSMutableArray alloc] init];
    return detailInfoArray;
}

-(NSArray *) getSpecialOffers{
    NSMutableArray *result = [[NSMutableArray alloc] init];    
    return result;
}

-(BOOL) isUnEvaluationOrder{
    return self.orderStatus == order_status_completed && self.evaluationStatus == evaluation_status_unpost;
}

-(BOOL) isEvaluatedOrder{
    return self.evaluationStatus == evaluation_status_post;
}

-(BOOL) isCompletedOrder{
    return (self.orderStatus == order_status_canceled || self.orderStatus == order_status_completed);
}

-(BOOL) isUncompleteOrder{
    return (self.orderStatus == order_status_waiting_confirm || self.orderStatus == order_status_confirmed);
}

@end
