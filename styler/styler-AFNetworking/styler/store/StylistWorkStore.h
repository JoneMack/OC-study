//
//  ExpertWorkStore.h
//  styler
//
//  Created by System Administrator on 13-9-12.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "StylistWork.h"
#import "Page.h"
@interface StylistWorkStore : NSObject

+ (StylistWorkStore *) sharedStore;

-(void) getStylistWorksBySearcher:(void (^)(Page *page, NSError *err))completionBlock
                      url:(NSString*)url
                  refresh:(BOOL)refresh;

-(void) getStylistWorksByApi:(void (^)(Page *page, NSError *err))completionBlock
                       url:(NSString*)url
                   refresh:(BOOL)refresh;



-(void)shareStylistWork:(void (^)(NSError *))completionBlock url:(NSString *)url;

+(void) getStylistWork:(void (^)(StylistWork *work, NSError *err))completionBlock
                workId:(int)workId
               refresh:(BOOL)refresh;

+(NSString *)getUrlForContentSortWorks:(int)contentSortId;

+(NSString *)getUrlForFavWorks:(NSString *)targetId;
+(NSString *)getUrlForStylistWorks:(int)stylistId;

@end
