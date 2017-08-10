//
//  CloseDate.h
//  styler
//
//  Created by System Administrator on 14-4-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "JSONModel.h"

@protocol CloseDate
@end

@interface CloseDate : JSONModel

@property (nonatomic, assign)long long int start;
@property (nonatomic, assign)long long int end;

-(BOOL) isInCloseDate:(NSDate *)date;

@end
