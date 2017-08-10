//
//  CircleStore.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "CircleStore.h"

@implementation CircleStore


+ (CircleStore *) sharedStore{
    static CircleStore *circleStore = nil;
    if(!circleStore){
        circleStore = [[super allocWithZone:nil] init];
    }
    
    return circleStore;
}

-(void) getCircles:(void (^)(Circle *, NSError *))completionBlock
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *url = [NSString stringWithFormat:@"/getCircle"];
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            NSDictionary *circleDict = [jsonDict valueForKey:@"data"];
            Circle *circle = [[Circle alloc] initWithDictionary:circleDict error:nil];
            if([jsonDict valueForKey:@"success"]){
                completionBlock( circle , nil);
            }
        }else{
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
}


-(void) getHotCircles:(void(^)(NSArray<HotCircle *> *hotCircles , NSError *err))completionBlock
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *url = [NSString stringWithFormat:@"/getHotCircle"];
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            NSArray<HotCircle *> *hotCircles = [HotCircle arrayOfModelsFromDictionaries:[jsonDict valueForKey:@"data"]];
            completionBlock(hotCircles , err);
        }else{
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
}



@end
