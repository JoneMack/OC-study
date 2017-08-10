//
//  ArticleStore.m
//  CrazyDoctor
//
//  Created by xubojoy on 16/5/19.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "ArticleStore.h"

@implementation ArticleStore

+ (void)getRecommendArticles:(void(^)(Page *page ,NSError *error))completionBlock pageSize:(int)pageSize{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/articles/search?pageSize=%d",[AppStatus sharedInstance].apiUrl,pageSize];
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlStr = [NSURL URLWithString:encoded];
    [request doIOSGet:urlStr completionBlock:^(id json, NSError *err) {
                NSLog(@">>>>>>>>>>>>>>>>获取文章json：%@",json);
        if (err == nil) {
            NSDictionary *jsonDict = json;
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *jsonDictArray = [jsonDict objectForKey:@"items"];
            page.items = jsonDictArray;
            completionBlock(page, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } refresh:NO useCacheIfNetworkFail:NO];
}

+ (void)getSwitchFlag:(void(^)(NSDictionary *flagDict ,NSError *error))completionBlock{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/sysVerFlag",[AppStatus sharedInstance].apiUrl];
    
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlStr = [NSURL URLWithString:encoded];
    [request doIOSGet:urlStr completionBlock:^(id json, NSError *err) {
        NSLog(@">>>>>>>>>>>>>>>>开关json：%@",json);
        if (err == nil) {
            NSDictionary *jsonDict = json;
            completionBlock(jsonDict, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } refresh:NO useCacheIfNetworkFail:NO];
}

@end
