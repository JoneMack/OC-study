//
//  OrderedHour.h
//  styler
//
//  Created by System Administrator on 14-4-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "JSONModel.h"

@protocol OrderedHour
@end

@interface OrderedHour : JSONModel

@property long long int day;
@property int hour;
@property int orderCount;

-(BOOL) compareDayAndHour:(NSDate *)theDay hour:(int)hour;

@end
