//
//  RedEnvelopeStore.m
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "Store.h"
#import "RedEnvelopeStore.h"
#import "NSString+stringPlus.h"


@implementation RedEnvelopeStore

+(void) getMyRedEnvelopes:(void (^)(Page *, NSError *))completionBlock redEnvelopeQuery:(RedEnvelopeQuery *)redEnvelopeQuery
            hairDressingCardId:(int)hairDressingCardId{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *url;
    if (redEnvelopeQuery != nil) {
        NSString *redEnvelopeQueryJson = [redEnvelopeQuery toJSONString];
        url = [NSString stringWithFormat:@"/redEnvelopes?redEnvelopeQueryJson=%@" , [redEnvelopeQueryJson urlEncode]];
    }else if (hairDressingCardId != 0){
        url = [NSString stringWithFormat:@"/redEnvelopes/userAble?hairDressingCardId=%d&pageNo=1&pageSize=100&cacheFlag=false",hairDressingCardId];
    }
    
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *jsonDictArray = [jsonDict objectForKey:@"items"];
            NSArray *redEnvelopes = [RedEnvelope arrayOfModelsFromDictionaries:jsonDictArray];
            page.items = redEnvelopes;
            completionBlock(page , nil);
        }else{
            completionBlock(nil , err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void) getRedEnvelopesByIds:(void(^)(NSArray *json ,NSError *error))completionBlock
              redEnvelopeIds:(NSArray *)redenvelopeIds{
    
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *idsStr = [redenvelopeIds componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:@"/redEnvelopes/redEnvelopeIds,%@" , idsStr];
//    NSLog(@"获取红包url:%@" , url);

    [request get:url completionBlock:^(NSString *json, NSError *err) {
        
        if (json != nil) {
            NSArray *redEnvelopes = [RedEnvelope arrayOfModelsFromDictionaries:[json objectFromJSONString]];
            completionBlock(redEnvelopes , nil);
        }
        
    } refresh:YES useCacheIfNetworkFail:NO];
}

+(void) getRedEnvelopeSeedById:(void(^)(RedEnvelopeSeed *redEnvelopeSeed ,NSError *error))completionBlock
             redEnvelopeSeedId:(int)redEnvelopeSeedId{

    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/redEnvelopeSeeds/redEnvelopeSeedId,%d" , redEnvelopeSeedId];
//    NSLog(@"获取红包种子url:%@" , url);
    
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            RedEnvelopeSeed *redEnvelopeSeed = [[RedEnvelopeSeed alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(redEnvelopeSeed , nil);
        }else{
            completionBlock(nil , err);
        }
        
    } refresh:YES useCacheIfNetworkFail:NO];


}

@end
