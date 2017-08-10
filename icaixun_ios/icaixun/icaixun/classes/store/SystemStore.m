//
//  SystemStore.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/21.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "SystemStore.h"

@implementation SystemStore

+(SystemStore *) sharedInstance
{
    static SystemStore *instance = nil;
    if (instance == nil){
        instance = [SystemStore new];
    }
    return instance;
}


-(void) getAppInfo:(void (^)(AppInfo *appInfo , NSError *err))complectionBlock
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    [requestFacade get:@"/appInfo" completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *dict = [json objectFromJSONString];
            AppInfo *appInfo = [[AppInfo alloc] initWithDictionary:dict error:nil];
            complectionBlock(appInfo , nil);
        }else{
            complectionBlock(nil , err);
        }
        
        
    } refresh:YES useCacheIfNetworkFail:YES];
}


@end
