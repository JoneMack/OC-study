//
//  NewServiceOrder.h
//  styler
//
//  Created by System Administrator on 14-4-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "JSONModel.h"
#import "TargetServiceItem.h"

@interface NewServiceOrder : JSONModel

@property int stylistId;
@property (nonatomic, retain) NSString *orderTitle;
@property (nonatomic, retain) NSDate *scheduleTime;
@property (nonatomic, copy) NSString *orderMessage;
@property NSString *poi;
@property NSString *address;
@property (nonatomic, retain) NSArray<TargetServiceItem> *targetServiceItems;

@end
