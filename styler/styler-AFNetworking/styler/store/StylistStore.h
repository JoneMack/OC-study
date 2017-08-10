//
//  ExpertStore.h
//  iUser
//
//  Created by System Administrator on 13-4-11.
//  Copyright (c) 2013年 珠元玉睿ray. All rights reserved.
//

#import "Stylist.h"
#import "Page.h"
#import "StylistPriceList.h"
#import "StylistServicePackage.h"
#import "Store.h"
#import "JSONKit.h"
@interface StylistStore : NSObject

+ (StylistStore *) sharedStore;

//按组合标签以及排序方式筛选专家作品
-(void) findStylistWork:(void (^)(NSArray *workList, NSError *err))completionBlock
                tagIds:(NSArray *)tagIds
             orderType:(int)orderType
                   lng:(double)lng
                   lat:(double)lat
                pageNo:(int)pageNo
               refresh:(BOOL)refresh;

-(void) getStylist:(void(^)(Stylist *stylist, NSError *err))completionBlock
             stylistId:(int)stylistId
              refresh:(BOOL) refresh;

-(void) checkLatestPublishWorkCount:(void(^)(int count, NSError *err))completionBlock;

-(void)getStylist:(void(^)(Page *page, NSError *err))completionBlock
              uriStr:(NSString *)uri
             refresh:(BOOL) refresh;

-(void)updateViewStylist:(void(^)(NSError *err))completionBlock
              stylistId:(int)stylistId
             refresh:(BOOL) refresh;

+(NSString *)getUriForStylistsContentSort:(int)contentSortId;
+(NSString *)getUriForStylistsFromFav:(NSString *)userId;
+(NSString *)getUriForSameOrganizationStylist:(NSString *)organizationName;
+(NSString *)getUriForBusinessCirclesStylist:(NSString *)businessCirclesName cityName:(NSString *)cityName;
+(NSString *)getUriByOrganizationId:(int)organizationId;
+(NSString *)getUriByStylistIds:(NSString *)stylistIds;

-(void) getStylistPriceList:(void(^)(StylistPriceList *priceList, NSError *err))completionBlock stylistId:(int)stylistId;

-(void) getStylistServicePackage:(void(^)(NSArray *servicePackages, NSError *err))completionBlock stylistId:(int)stylistId;

-(void) caculateTargetServiceItems:(void(^)(TargetServiceItems *targetServiceItems, NSError *err))completionBlock stylistId:(int)stylistId
                targetServiceItems:(TargetServiceItems *)targetServiceItems;

@end
