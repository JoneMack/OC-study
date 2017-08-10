//
//  ExpertMessageQuery.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/18.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertMessageQuery.h"

@implementation ExpertMessageQuery


-(ExpertMessageQuery *) initWithExpertIds:(NSArray *)expertIds
{
    self = [super init];
    if (self) {
        self.pageNo = 1;
        self.pageSize = 20;
        self.expertIds = expertIds;
        self.includeDeleted = NO;
        self.cacheFlag = YES;
    }
    return self;
}

@end
