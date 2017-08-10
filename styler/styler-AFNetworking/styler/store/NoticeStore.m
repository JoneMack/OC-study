//
//  NoticeStore.m
//  styler
//
//  Created by System Administrator on 13-6-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "NoticeStore.h"
#import "Notice.h"

@implementation NoticeStore

-(void) getNotices:(void (^)(NSArray *notices, NSError *err))completionBlock refresh:(BOOL)refresh{
    NSString *urlStr = [NSString stringWithFormat:@"/notices/latest?timePoint=%.0f", [[[AppStatus sharedInstance] getFirstGetNoticeTime] timeIntervalSince1970]*1000];
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        NSLog(@"get notices:%@", json);
        NSArray *dictArray = [[json objectFromJSONString] objectForKey:@"notices"];
        NSArray *notices = [Notice readNoticesFromJsonDictionayArray:dictArray];
        completionBlock(notices, nil);
    } refresh:refresh useCacheIfNetworkFail:YES];
}

+ (NoticeStore *) sharedStore{
    static NoticeStore *noticeStore = nil;
    if(!noticeStore){
        noticeStore = [[super allocWithZone:nil] init];
    }
    
    return noticeStore;
}

+(id) allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}


@end
