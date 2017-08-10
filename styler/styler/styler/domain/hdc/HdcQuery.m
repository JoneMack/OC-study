//
//  HdcQuery.m
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HdcQuery.h"

@implementation HdcQuery

-(id)initWithOrganizationIds:(NSArray *)organizationIds{
    self = [super init];
    if(self){
        self.organizationIds = organizationIds;
        self.pageNo = 1;
        self.pageSize = organizationIds.count*20;
        self.hdcSaleStatuses = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:1], nil];
    }
    return self;
}
-(id)initWithStylistIds:(NSArray *)stylistIds
{
    self = [super init];
    if(self){
        self.stylistIds = stylistIds;
        self.pageNo = 1;
        self.pageSize = stylistIds.count*20;
        self.hdcSaleStatuses = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:1], nil];
    }
    return self;



}


@end
