//
//  LiveListStore.m
//  videotest
//
//  Created by xubojoy on 16/9/12.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "LiveListStore.h"

@implementation LiveListStore
+ (void)getAllLiveList:(void(^)(NSArray *listArray ,NSError *error))completionBlock pageNo:(int)pageNo{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%d",pageNo];
    NSLog(@">>>>即将请求>>>>>%@",url);
    NSString *encoded = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSURL *urlStr = [NSURL URLWithString:encoded];
    [request doGet:urlStr completionBlock:^(id json, NSError *err) {
        NSLog(@">>>>>>>>>请求返回json：%@",json);
        if (err == nil) {
            NSDictionary *dict = (NSDictionary *)json;
            NSDictionary *dataDict = [dict valueForKey:@"data"];
            NSArray *dataListArray = [dataDict valueForKey:@"list"];
//           NSLog(@">>>>>>>>>请求返回dict：%@",[dict valueForKey:@"msg"]);
            completionBlock(dataListArray, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } refresh:NO useCacheIfNetworkFail:NO];
}

+ (LiveListStore *)sharedInstance{
    static LiveListStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


@end
