//
//  OrderedTime.h
//  styler
//
//  Created by System Administrator on 14-8-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol OrderedTime
@end

@interface OrderedTime : JSONModel

@property long long int scheduleTime;
@property (nonatomic, copy) NSString *serviceIntention;

+(BOOL) canOrder:(NSDate *)day
            hour:(float)hour
serviceIntention:(NSString *)serviceIntention
    orderedTimes:(NSArray *)orderedTimes;

@end
