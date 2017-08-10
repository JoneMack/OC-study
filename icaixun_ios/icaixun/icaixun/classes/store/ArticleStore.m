//
//  ArticleStore.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ArticleStore.h"

@implementation ArticleStore


+(ArticleStore *) sharedInstance
{
    static ArticleStore *instance = nil;
    if (instance == nil) {
        instance = [ArticleStore new];
    }
    return instance;
}

#pragma mark 获取轮播图
-(void) getBannerArticles:(void (^)(Page *page , NSError *err))completionBlock
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSString *url = @"/articles?articleQueryType=banner";
    
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
//            NSLog(@"banner article json:%@" , json);
            NSDictionary *dict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:dict];
            NSArray *articles = [Article arrayOfModelsFromDictionaries:[dict objectForKey:@"items"]];
            page.items = articles;
            completionBlock(page , nil);
        }else{
            completionBlock(nil ,err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}

#pragma mark 获取普通的文章
-(void) getArticles:(void (^)(Page *page , NSError *err))completionBlock pageNo:(int)pageNo pageSize:(int)pageSize
{
    HttpRequestFacade *requestFacade =  [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/articles?articleQueryType=article&pageNo=%d&pageSize=%d" , pageNo, pageSize];
//    NSLog(@"url :%@" , url);
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *dict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:dict];
            NSArray *articles = [Article arrayOfModelsFromDictionaries:[dict objectForKey:@"items"]];
            page.items = articles;
            completionBlock(page , nil);
        }else{
            completionBlock(nil ,err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
    
}

#pragma mark 更新文章阅读数
-(void) postReadCount:(void (^)(Article *article , NSError *err))completionBlock articleId:(int)articleId
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"/articles/articleId,%d/read" , articleId];
    
    [requestFacade post:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *dict = [json objectFromJSONString];
            Article *article = [[Article alloc] initWithDictionary:dict error:nil];
            completionBlock(article , nil);
        }else{
            completionBlock(nil , err);
        }
    } params:nil];
}

@end
