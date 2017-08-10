//
//  AppClientStore.m
//  styler
//
//  Created by 冯聪智 on 14-8-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "AppClientStore.h"

@implementation AppClientStore

+(void) updateAppClient{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = @"/appClients";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [request put:url completionBlock:^(NSString *json, NSError *err) {
            NSLog(@">> put app client :%@" , json);
        }];
    });
}

@end
