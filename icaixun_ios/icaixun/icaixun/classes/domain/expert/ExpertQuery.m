//
//  ExpertQuery.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/6.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertQuery.h"

@implementation ExpertQuery

-(id) initWithPageSize:(int)pageSize
{
    self = [super init];
    if (self) {
        self.cacheFlag = true;
        self.pageNo = 1;
        self.expertIds = [NSArray new];
        self.pageSize = pageSize;
    }
    return self;
}


-(id) initWithExpertIds:(NSArray *)expertIds
{
    self = [super init];
    if (self) {
        self.cacheFlag = true;
        self.pageNo = 1;
        self.pageSize = 100;
        self.expertIds = expertIds;
    }
    return self;
}

@end
