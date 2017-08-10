//
//  UserStore.h
//  Golf
//
//  Created by xubojoy on 15/3/30.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//

#import "AFNetworking.h"
@interface HttpRequestFacade : NSObject
//refresh参数用于强制更新，禁用缓存
-(void)             get:(NSString *)urlStr
        completionBlock:(void (^)(id json, NSError *err))completionBlock
                 params:(NSMutableDictionary *)params
                refresh:(BOOL)refresh
  useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail;

-(void)           doGet:(NSURL *)url
        completionBlock:(void (^)(id json, NSError *err))completionBlock
                 params:(NSMutableDictionary *)params
                refresh:(BOOL)refresh
  useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail;

-(void)          post:(NSString *)urlStr
      completionBlock:(void (^)(id json, NSError *err))completionBlock
               commonParams:(NSMutableDictionary *)params;


-(void)   postForData:(NSString *)urlStr
      completionBlock:(void (^)(id json, NSError *err))completionBlock
         commonParams:(NSMutableDictionary *)params;

-(void)   postForDataWithoutDeviceType:(NSString *)urlStr
      completionBlock:(void (^)(id json, NSError *err))completionBlock
         commonParams:(NSMutableDictionary *)params;

-(void)          post:(NSString *)urlStr
      completionBlock:(void (^)(id json, NSError *err))comletionBlock
               params:(NSMutableDictionary *)params;

-(void)          post:(NSString *)urlStr
      completionBlock:(void (^)(id json, NSError *err))completionBlock
           jsonString:(NSMutableDictionary *)jsonString;

-(void)        delete:(NSString *)urlStr
completionBlock:(void (^)(id json, NSError *err))completionBlock
            param:(NSDictionary *)param;

-(void)        put:(NSString *)urlStr
   completionBlock:(void (^)(id json, NSError *err))completionBlock;

-(void)        put:(NSString *)urlStr
   completionBlock:(void (^)(id json, NSError *err))completionBlock
            params:(NSDictionary *)params;


-(void) postImg:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock image:(UIImage *)image;

+(HttpRequestFacade *)sharedInstance;

@end
