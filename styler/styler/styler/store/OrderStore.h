//
//  OrderStore.h
//  styler
//
//  Created by System Administrator on 13-6-11.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "ServiceOrder.h"
#import "NewServiceOrder.h"
#import "Page.h"
#import "Contact.h"
#import "NewContact.h"
@interface OrderStore : NSObject

+ (OrderStore *) sharedStore;

-(void) placeOrder:(void (^)(ServiceOrder *order, NSError *err))completionBlock
         orderTime:(NSDate *)orderTime
          stylistId:(int)stylistId
            workId:(int)workId
     serviceItemIds:(NSArray *)serviceItemIds
      specialEvent:(int)specialEvent
           address:(NSString *)address;

-(void) submitOrder:(void (^)(ServiceOrder *order, NSError *err))completionBlock
    newServiceOrder:(NewServiceOrder *)newServiceOrder;


-(void) addNewPlayer:(void (^)(Contact *contact,NSError *err))completionBlock contactsTo:(NewContact *)newContact;



-(void) getOrderedHours:(void (^)(NSArray *orderedHours, NSError *err))completionBlock
                   stylistId:(int)stylistId;

-(void) getOrderedTime:(void (^)(NSArray *orderedTimes, NSError *err))completionBlock
             stylistId:(int)stylistId;

-(void) getMyOrders:(void (^)(Page *page, NSError *err))completionBlock;

-(void) getMyOrders:(void (^)(Page *page, NSError *err))completionBlock
             pageNo:(int)pageNo
           pageSize:(int)pageSize;

-(void) getMyOrder:(void (^)(ServiceOrder *order, NSError *err))completionBlock orderId:(int)orderId;

-(void) getOrderPrice:(void (^)(NSDictionary * dic, NSError *err))completionBlock stylistId:(int)stylistId andStylistWordId:(NSString *)stylistWorkId andServiceItem:(NSArray*)serviceItems;

@end
