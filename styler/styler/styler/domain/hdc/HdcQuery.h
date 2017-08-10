//
//  HdcQuery.h
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  HdcQuery
@end

@interface HdcQuery : JSONModel

@property int id;
@property (nonatomic, strong) NSArray *organizationIds;
@property (nonatomic, strong) NSArray *stylistIds;
@property (nonatomic, strong) NSArray *hdcSaleStatuses;
@property int hdcOrderType;
@property int pageSize;
@property int pageNo;

-(id)initWithOrganizationIds:(NSArray *)organizationIds;
-(id)initWithStylistIds:(NSArray *)stylistIds;

@end
