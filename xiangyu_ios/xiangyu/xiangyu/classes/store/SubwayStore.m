//
//  SubwayStore.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SubwayStore.h"

@implementation SubwayStore


+ (SubwayStore *) sharedStore{
    
    static SubwayStore *subwayStore = nil;
    if(!subwayStore){
        subwayStore = [[super allocWithZone:nil] init];
    }
    return subwayStore;
}

-(void) getSubways:(void(^)(NSArray<SubwayLine *> *subwayLines, NSError *err))completionBlock{

    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"/subway/getSubWayInfo"];
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            NSLog(@" json dict :%@" , jsonDict);
            if([jsonDict valueForKey:@"success"] ){
                
                NSDictionary *data = [jsonDict valueForKey:@"data"];
                NSArray<SubwayLine *> *subwayLines = [SubwayLine arrayOfModelsFromDictionaries:[data valueForKey:@"lineList"]];
                completionBlock( subwayLines , nil);
            }
        }else{
            NSLog(@"调用验证码失败");
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
    
}





@end
