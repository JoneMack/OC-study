//
//  OrganizationStore.h
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//
#import "Page.h"
#import "Organization.h"
@class OrganizationFilter;

@interface OrganizationStore : NSObject

+(void)getBrands:(void (^)(NSArray *brands, NSError *err))completionCallback
                pageNo:(int)pageNo pageSize:(int)pageSize;

+(void)getOrganizationByUrl:(void (^)(Page *, NSError *))completionCallback url:(NSString *)url;

+(void)getOrganizationById:(void (^)(Organization *orginzation, NSError *err))completionCallback
            organizationId:(int)organizationId
               hasStylists:(BOOL)hasStylists;

+(void)getOrganizationsWithOrganizationFilter:(void (^)(Page *, NSError *))completionCallback
                        organizationFilter:(OrganizationFilter *)organizationFilter;

+(OrganizationStore *) sharedStore;

+(NSString *)getRequestUrlWithBrandName:(NSString *)brandName;
+(NSString *)getRequestUrlWithContentSortId:(int)contentSortId;
+(NSString *)getRequestUrlWithOrganizationIds:(NSString *)orgIds;


@end
