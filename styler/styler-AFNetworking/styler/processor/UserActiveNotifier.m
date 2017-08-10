//
//  UserActiveNotifier.m
//  styler
//
//  Created by System Administrator on 14-6-22.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserActiveNotifier.h"
#import "HttpRequestFacade.h"

#import <AdSupport/ASIdentifierManager.h>

@implementation UserActiveNotifier

+(void) sendActiveNotify:(NSString *)location{
    if ([AppStatus sharedInstance].hasActive) {
        return ;
    }
    
    NSString *activeNotifyUrl = [MobClick getConfigParams:@"activeNotifyUrl"];
    if (activeNotifyUrl && ![activeNotifyUrl isEqualToString:@""]) {
        NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSString *urlStr = [NSString stringWithFormat:@"%@?idfa=%@&location=%@", activeNotifyUrl, adId, location];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
        [requestFacade put:urlStr
           completionBlock:^(NSString *json, NSError *err) {
               if (err == nil) {
                   AppStatus *as = [AppStatus sharedInstance];
                   [as setHasActive:YES];
               }
           }];
    }
    
}

@end
