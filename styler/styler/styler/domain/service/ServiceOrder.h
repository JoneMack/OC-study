//
//  ServiceOrder.h
//  styler
//
//  Created by System Administrator on 13-6-11.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define order_status_waiting_confirm  1
#define order_status_confirmed  2
#define order_status_canceled  3
#define order_status_completed  5

#define evaluation_status_unpost 0
#define evaluation_status_post 1

#define order_detail_info_type_items 1
#define order_detail_info_type_special_offers 2
#define order_detail_info_type_notes 3

#import <Foundation/Foundation.h>
#import "Stylist.h"
#import "StylistWork.h"
#import "JSONModel.h"
#import "OrderServiceItem.h"

@protocol ServiceOrder 
@end

@interface ServiceOrder : JSONModel

@property int id;
@property (nonatomic, copy) NSString *orderTitle;
@property (nonatomic, copy) NSString *orderNumber;
@property NSString<Optional> *orderMessage;
@property int orderStatus;      //订单状态  有4个
@property int evaluationStatus; //评价状态  有2个
@property int specialOfferPrice;
@property int price;
@property int organizationId;
@property long long int createTime;
@property long long int scheduleTime;
@property long long int scheduleCompleteTime;
@property (nonatomic, retain) Stylist<Optional> *stylist;
@property int stylistId;
@property (nonatomic, retain) NSArray<OrderServiceItem> *orderServiceItems;
@property (nonatomic, copy) NSString *stylistName;
@property (nonatomic, copy) NSString *organizationName;
@property (nonatomic, copy) NSString *organizationPhone;
@property (nonatomic, copy) NSString *organizationAddress;


-(BOOL) isCompletedOrder;
-(BOOL) isEvaluatedOrder;
-(BOOL) isUncompleteOrder;
-(BOOL) isUnEvaluationOrder;

-(NSDate *) getCreateTime;
-(NSDate *) getScheduleTime;
-(NSDate *) getScheduleCompleteTime;

-(NSArray *) getOrderDetailCommonItemTxts;
-(NSString *) statusTxt;
@end
