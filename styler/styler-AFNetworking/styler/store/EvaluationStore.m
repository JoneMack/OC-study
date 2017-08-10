//
//  EvaluationStore.m
//  styler
//
//  Created by aypc on 13-12-7.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "EvaluationStore.h"
#import "OrderStore.h"
#import "AppDelegate.h"
#import "StylerTabbar.h"
#import "MyOrderController.h"

@implementation EvaluationStore
//发型师评价
-(void) getEvaluationList:(void (^)(Page *page, NSError *))completionBlock
                stylistId:(int)stylistId
                   pageNo:(int)pageNo
                 pageSize:(int)pageSize
                  refresh:(BOOL)refresh
{
    NSString *urlStr = [NSString stringWithFormat:@"/evaluations/stylistId,%d?pageSize=%d&pageNo=%d", stylistId, pageSize,pageNo];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *evaluations = [StylistEvaluation arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = evaluations;
            completionBlock(page, nil);
        }else if (err != nil)
        {
            completionBlock(nil,err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
}
//发表评价
-(void) submitEvaluation:(void (^)(NSError *))completionBlock evaluation:(NewEvaluation *)evaluation evaluationImages:(NSArray *)imageArray
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (imageArray && imageArray.count > 0) {
        [params setObject:[evaluation getJsonString] forKey:@"evaluation"];
        for (int i = 0; i < imageArray.count; i++) {
            [params setObject:[imageArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"evaluationPictures%d",i + 1]];
        }
        [requestFacade post:@"/evaluations" completionBlock:^(NSString *json, NSError *err) {
            if(json != nil){
                User *user = [AppStatus sharedInstance].user;
                user.evaluationCount += 1;
                [AppStatus saveAppStatus];
                completionBlock(nil);
            }else if(err != nil){
                completionBlock(err);
            }
        } params:params];
    }else{
        [requestFacade post:@"/evaluations" completionBlock:^(NSString *json, NSError *err) {
            if(json != nil){
                completionBlock(nil);
                User *user = [AppStatus sharedInstance].user;
                user.evaluationCount += 1;
                [AppStatus saveAppStatus];
            }else if(err != nil){
                completionBlock(err);
            }
        } jsonString:[evaluation getJsonString]];
    }
}

//用户评价
-(void)getUserEvaluations:(void(^)(Page *page, NSError * err))completeBlock
                   pageNo:(int)pageNo
                 pageSize:(int)pageSize
                  refresh:(BOOL)refresh
{
    NSString *urlStr = [NSString stringWithFormat:@"/evaluations/mine?pageSize=%d&pageNo=%d",pageSize,pageNo];
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *evaluations = [Evaluation arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = evaluations;
            completeBlock(page, nil);
        }else{
            completeBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
}

//机构评价
-(void)getOrganizationEvaluations:(void (^)(Page *, NSError *))completeBlock
                   organizationId:(int)organizationId
                           pageNo:(int)pageNo
                         pageSize:(int)pageSize
                          refresh:(BOOL)refresh
{
    NSString *urlStr = [NSString stringWithFormat:@"/organizationEvaluations/organizationId,%d?pageSize=%d&pageNo=%d",organizationId,pageSize,pageNo];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *evaluations = [OrganizationEvaluation arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = evaluations;
            completeBlock(page, nil);
        }else{
            completeBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
}

+(void) checkEvaluationStatus:(void (^)(NSError *err))completeBlock{
    
    AppStatus *as = [AppStatus sharedInstance];
    [[OrderStore sharedStore] getMyOrders:^(Page *page, NSError *err) {
        
        if (err==nil) {
            NSMutableArray  *myOrders = [NSMutableArray new];
            [myOrders addObjectsFromArray:page.items];
            BOOL hasUnpost = NO;
            for (ServiceOrder *order in myOrders) {
                if ([order isUnEvaluationOrder]) {
                    BOOL localPost = NO;
                    for (NSNumber *orderId in as.evaluatedOrderIds) {
                        if (orderId.intValue == order.id) {
                            localPost = YES;
                            break;
                        }
                    }
                    if (!localPost) {
                        hasUnpost = YES;
                        break;
                    }
                }else if([order isEvaluatedOrder]){
                    NSMutableArray *evaluatedOrderIds = [NSMutableArray new];
                    for (NSNumber *orderId in as.evaluatedOrderIds) {
                        if (orderId.intValue == order.id) {
                            [evaluatedOrderIds addObject:orderId];
                            break;
                        }
                    }
                    as.evaluatedOrderIds = evaluatedOrderIds;
                    [AppStatus saveAppStatus];
                }
            }
            
            as.hasUnevaluationOrder = hasUnpost;
            [AppStatus saveAppStatus];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_has_unevaluate_order object:nil];
            completeBlock(err);
        }
    }];
}

+(EvaluationStore*)shareInstance
{
    static EvaluationStore *evaluation = nil;
    if (!evaluation) {
        evaluation = [[EvaluationStore alloc]init];
    }
    return evaluation;
}

@end
