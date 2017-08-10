//
//  FeedbackStore.m
//  styler
//
//  Created by System Administrator on 13-6-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "FeedbackStore.h"
#import "SessionMsg.h"

@implementation FeedbackStore
 
-(void)sendFeedback:(void (^)(int sessionId, NSError *err))completionBlock msg:(NSString *)msg{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    AppStatus *as = [AppStatus sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:as.user.idStr forKey:@"senderId"];
    [params setObject:msg forKey:@"txt"];
    
    [requestFacade post:@"/feedbackMsgs" completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSDictionary *jsonDict = [json objectFromJSONString];
            completionBlock([[jsonDict objectForKey:@"sessionId"] intValue], err);
        }
    } params:params];
}

-(void)getLastSessionMsg:(void (^)(NSArray *msgs, NSError *err))completionBlock sessionId:(int)sessionId refresh:(BOOL)refresh{
    NSString *urlStr = [NSString stringWithFormat:@"/my/feedback/lastMsgs?timePoint=0&pageSize=50&pageNo=1"];
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        NSArray *dictArray = [[json objectFromJSONString] objectForKey:@"items"];
        NSArray *msgs = [SessionMsg readMsgsFromJsonDictionayArray:dictArray];
        completionBlock(msgs, nil);
    } refresh:refresh useCacheIfNetworkFail:YES];
}

+ (FeedbackStore *) sharedStore{
    static FeedbackStore *feedbackStore = nil;
    if(!feedbackStore){
        feedbackStore = [[super allocWithZone:nil] init];
    }
    
    return feedbackStore;
}

+(id) allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

@end
