//
//  RewardActivityStore.m
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "Store.h"
#import "RewardActivityStore.h"


@implementation RewardActivityStore

+(void) getRewardActivity:(void(^)(RewardActivity *rewardActivity ,NSError *error))completionBlock
               actionType:(int)actionType
                startTime:(NSNumber *)startTime{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"/rewardActivitys/actionType,%d?startTime=%lld" , actionType,[startTime longLongValue]];
    NSLog(@">>>>>>>>> 获取奖励活动url:%@" , url);
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
//             NSLog(@"》》》》获取奖励活动json:%@" , json);
            NSDictionary *jsonDict = [json objectFromJSONString];
            RewardActivity *rewardActivity = [[RewardActivity alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(rewardActivity , nil);
        }else{
            completionBlock(nil , err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

+(void) getUserAction:(void(^)(UserAction *userAction, NSError *error))completionBlock userActionId:(int)userActionId{
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"/userActions/actionId,%d" , userActionId];
    NSLog(@">>>>>>>>> 获取用户事件信息url:%@" , url);
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            UserAction *userAction = [[UserAction alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(userAction,nil);
        }else{
            completionBlock(nil , err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}


+(void) postUserAction:(void(^)(UserAction *userAction, NSError *error))completionBlock
        shareSceneType:(ShareSceneType *)shareSceneType{
    
    UserAction *newUserAction = [[UserAction alloc] initWithActionType:shareSceneType];
    newUserAction.actionType = shareSceneType.sharedContentType;
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"/userActions"];
    
    [request post:url completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSDictionary *jsonDict = [json objectFromJSONString];
            UserAction *userAction = [[UserAction alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(userAction,nil);
        }else if(err != nil){
            completionBlock(nil,err);
        }
    } jsonString:[newUserAction getJsonString]];

}

+(void)getRewardObjectByActionId:(void (^)(RewardObject *, NSError *))completionBlock ActionId:(int)actionId{

    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *url = [NSString stringWithFormat:@"/rewardObjects/actionId,%d" , actionId];
    [request get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            RewardObject *rewardObject = [[RewardObject alloc] initWithDictionary:jsonDict error:nil];
            completionBlock(rewardObject,nil);
        }else{
            completionBlock(nil , err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

+(void)postNewCustomer:(void (^)(NSError *))completionBlock mobileNo:(NSString *)mobileNo actionId:(int)actionId{
    
    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    
    NSString *url = @"/customers";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:mobileNo forKey:@"mobileNo"];
    [params setObject:@(actionId) forKey:@"actionId"];
    [request post:url completionBlock:^(NSString *json, NSError *err) {
        completionBlock(nil);
    } params:params];
    
}





 
@end
