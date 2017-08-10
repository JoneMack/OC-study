//
//  OrderedTimeRange.h
//  styler
//
//  Created by System Administrator on 13-6-14.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface OrderedTimeRange : NSObject<JSONSerializable, NSCopying>

@property (nonatomic, copy) NSDate *day;

@property int startHour;
@property int orderCount;

+(NSArray *) readOrderedTimeRangesFromJsonDictionayArray:(NSArray *)jsonDictArray;
+(NSArray *) getOrderedTimeRangeFromArray:(NSArray *) orderedTimeRanges date:(NSDate *)date;
@end
