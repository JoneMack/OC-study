//
//  ExpertMessageStore.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/18.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertMessageStore.h"
#import "ExpertMessageQuery.h"
#import "ExpertMessage.h"

@implementation ExpertMessageStore


+(ExpertMessageStore *) sharedInstance
{
    static ExpertMessageStore *instance = nil;
    if(instance == nil){
        instance = [ExpertMessageStore new];
    }
    return instance;
}

-(void) getExpertMessagesByExpertIds:(void (^)(Page *page , NSError *err))completionBlock expertIds:(NSArray *)expertIds
                              pageNo:(int)pageNo
                            pageSize:(int)pageSize
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    ExpertMessageQuery *query = [[ExpertMessageQuery alloc] initWithExpertIds:expertIds];
    query.pageSize = pageSize;
    query.pageNo = pageNo;
    
    NSString *queryStr = [query toJSONString];
    
    NSString *url = [NSString stringWithFormat:@"/massages?expertMassageQuery=%@" , queryStr];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        
        if ( json != nil){
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *jsonDictArray = [jsonDict objectForKey:@"items"];
            NSArray *messages = [ExpertMessage arrayOfModelsFromDictionaries:jsonDictArray];
            
            for (ExpertMessage *message in messages) {
                [message fillPics];
                [message fillPraiseStatus];
            }
            page.items = messages;
            completionBlock(page, nil);
        }else{
            completionBlock(nil , err);
        }
        
        
        
    } refresh:YES useCacheIfNetworkFail:YES];
}

-(void) praiseExpertMessage:(void (^)(ExpertMessage *message , NSError *))completionBlock messageId:(NSString *)messageId
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"/massages/massageId,%@/praise" , messageId];
    
    [requestFacade post:url completionBlock:^(NSString *json, NSError *err) {
        
        if (json != nil) {
            NSDictionary *dict = [json objectFromJSONString];
            ExpertMessage *message = [[ExpertMessage alloc] initWithDictionary:dict error:nil];
            completionBlock(message , err);
        }else{
            completionBlock(nil , err);
        }
        
    } params:nil];
}

@end
