//
//  ColumnStore.m
//  styler
//
//  Created by aypc on 13-10-2.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "ContentSortStore.h"
@implementation ContentSortStore

-(void) getColumn:(void (^)(NSArray *column, NSError *err))completionBlock
     targetPageId:(int)targetPageId
          refresh:(BOOL)refresh
{
    NSString *urlStr = [NSString stringWithFormat:@"/contentSorts/targetPage,%d", targetPageId];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:
              NSUTF8StringEncoding];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSArray *array = [json objectFromJSONString];
            completionBlock(array, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
}

-(void) getContentSort:(void (^)(NSArray *contentSort, NSError *err))completionBlock
     targetPageId:(int)targetPageId
          refresh:(BOOL)refresh
{
    NSString *urlStr = [NSString stringWithFormat:@"/contentSorts/targetPage,%d", targetPageId];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:
              NSUTF8StringEncoding];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSArray *array = [ContentSort arrayOfModelsFromDictionaries:[json objectFromJSONString]];
            completionBlock(array, nil);
        }else{
            completionBlock(nil, err);
        }
    }refresh:refresh useCacheIfNetworkFail:YES];
}


-(void)getContentSortInfo:(void(^)(ContentSort * contentSort,NSError * err)) completeBlock contentSortId:(NSString *)contentSortId
                  refresh:(BOOL)refresh
{
    NSString * urlString = [NSString  stringWithFormat:@"/contentSorts/%@",contentSortId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HttpRequestFacade * requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlString completionBlock:^(NSString *json, NSError *err)
     {
         if (json != nil) {
             NSDictionary *dic = [json objectFromJSONString];
             NSError *err;
             ContentSort * cs = [[ContentSort alloc] initWithDictionary:dic error:&err];
             if (err == nil) {
                 NSLog(@">> 解析错误:%@", err);
             }
             completeBlock(cs, nil);
         }else{
             completeBlock(nil, err);
         }
     }refresh:refresh useCacheIfNetworkFail:YES];
}

+(ContentSortStore *)sharedStore
{
    static ContentSortStore * column = nil;
    if(column == nil)
    {
        column = [[ContentSortStore alloc]init];
    }
    return column;
}
@end
