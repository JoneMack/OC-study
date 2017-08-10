//
//  BannerStore.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "BannerStore.h"
#import "Banner.h"

@implementation BannerStore

+ (BannerStore *) sharedStore{
    static BannerStore *bannerStore = nil;
    if(!bannerStore){
        bannerStore = [[super allocWithZone:nil] init];
    }
    
    return bannerStore;
}

-(void) getBanners:(void (^)(NSArray<Banner *> *, NSError *))completionBlock locationStr:(NSString *)locationStr{
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:locationStr forKey:@"locationStr"];
    
    NSString *url = [NSString stringWithFormat:@"/advertMapService/advertMapList"];
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSDictionary *jsonDict = json;
            if([jsonDict valueForKey:@"success"]){
                NSDictionary *data = [jsonDict valueForKey:@"data"];
                NSArray<Banner *> *banners = [data valueForKey:@"banner"];
                completionBlock( banners  , nil);
            }
        }else{
            NSLog(@"调用验证码失败");
            completionBlock(nil , err);
        } 
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];

    
}

@end
