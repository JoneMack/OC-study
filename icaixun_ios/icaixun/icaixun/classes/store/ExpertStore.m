//
//  ExpertStore.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/6.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExpertStore.h"
#import "Expert.h"
#import "Page.h"
#import "UserExpertRelation.h"

@implementation ExpertStore


+(void) getExperts:(void (^)(NSArray *experts, NSError *err))completionBlock query:(ExpertQuery *)query
{
    HttpRequestFacade *requestFacade= [HttpRequestFacade sharedInstance];
    NSString *queryJson = [query toJSONString];
    NSString *url = [NSString stringWithFormat:@"/expert/searcher?expertQueryJson=%@" , queryJson];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *dictArray = [json objectFromJSONString];
            NSArray *expertDictArray = [dictArray objectForKey:@"items"];
            NSMutableArray *experts = [[NSMutableArray alloc] init];
            for (NSDictionary *expertDict in expertDictArray) {
                NSError *err = nil;
                Expert *expert = [[Expert alloc] initWithDictionary:expertDict error:&err];
                if (err != nil) {
                    NSLog(@"反序列化expert错误:  %@", err);
                }
                [experts addObject:expert];
            }
            completionBlock([experts copy], nil);

        }
    } refresh:YES useCacheIfNetworkFail:YES];
}


+(void) getMyAttentionExperts:(void (^)(NSArray *userExpertRelations, NSError *err))completionBlock
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    [requestFacade get:@"/userExpertRelations" completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            
            NSArray *dictArray = [json objectFromJSONString];
            NSArray<UserExpertRelation> *relations  = (NSArray<UserExpertRelation>*)[UserExpertRelation arrayOfModelsFromDictionaries:dictArray];
            
            if (relations.count == 0) {
                completionBlock([NSArray new] , nil);
                return;
            }
            
            NSMutableArray *expertIds = [NSMutableArray new];
            for (UserExpertRelation *relation in relations) {
                [expertIds addObject:[NSString stringWithFormat:@"%d" ,relation.expertId]];
            }
            
            ExpertQuery *query = [[ExpertQuery alloc] initWithExpertIds:expertIds];
            
            [ExpertStore getExperts:^(NSArray *experts, NSError *err) {
                
                NSMutableArray *myExperts = [NSMutableArray new];
                for (Expert *expert in experts) {
                    for (UserExpertRelation *relation in relations) {
                        if (expert.id == relation.expertId) {
                            expert.relationStatus = relation.status;
                            expert.massageReceiveStatus = relation.massageReceiveStatus;
                            expert.userExpertRelation = relation;
                            [myExperts addObject:expert];
                        }
                    }
                }
                completionBlock([myExperts copy] , nil);
            } query:query];
            
        }else{
            completionBlock(nil , err);
        }
        
    } refresh:YES useCacheIfNetworkFail:YES];
}



@end
