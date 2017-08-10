//
//  PushStore.m
//  styler
//
//  Created by System Administrator on 13-6-20.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "PushStore.h"
#import "PushRecord.h"
#import "PushProcessor.h"

@implementation PushStore

-(void) getUnreadPush:(void (^)(NSArray *pushRecords, NSError *err))completionBlock{
    [[PushProcessor sharedInstance] checkFailureCheckPush:^(){
        NSString *urlStr = @"/push/unread";
        HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
        [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
            if (err == nil) {
                NSArray *dictArray = [json objectFromJSONString];
                NSArray *pushes = [PushRecord readPushRecordsFromJsonDictionayArray:dictArray];
                completionBlock(pushes, nil);
            }else{
                completionBlock(nil, err);
            }
        } refresh:YES useCacheIfNetworkFail:NO];

    }];
}

-(void) checkPush:(void (^)(NSError *err))completionBlock pushSNArray:(NSArray *)pushSNArray{    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:pushSNArray forKey:@"sn"];
    NSLog(@">>>>>>>>>>>>>>>>%@",params);
    [requestFacade post:@"/push/pushStatusUpdater" completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:params];
}

+ (PushStore *) sharedStore{
    static PushStore *sharedInstance = nil;
    if(sharedInstance == nil){
        //NSString *path = [AppStatus savedPath];
        //sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(sharedInstance == nil){
            sharedInstance = [[PushStore alloc] init];
        }
        
        //NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
        //sharedInstance.apiUrl = [dicInfo objectForKey:@"apiUrl"];
    }
    
    return sharedInstance;
}


@end
