//
//  MapHouseSearchStore.m
//  xiangyu
//
//  Created by xubojoy on 16/6/22.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MapHouseSearchStore.h"

@implementation MapHouseSearchStore

+(void) getHouseMapSearchByprojectnames:(void(^)(NSDictionary *dict, NSError *err))completionBlock projectnames:(NSString *)projectnames{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:projectnames forKey:@"projectnames"];
    
    NSString *url = [NSString stringWithFormat:@"/houseMapSearch"];
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            NSLog(@">>>>>>>>>>>>>>%@",jsonDict);
            NSDictionary *houseDict = [jsonDict valueForKey:@"data"];
            
            if([jsonDict valueForKey:@"success"]){
                completionBlock( houseDict , nil);
            }
        }else{
            completionBlock(nil , err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
}

@end
