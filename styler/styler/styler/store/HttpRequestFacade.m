//
//  HttpRequestFacade.m
//  iUser
//
//  Created by System Administrator on 13-5-3.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "Store.h"

@implementation HttpRequestFacade


-(void)get:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock refresh:(BOOL)refresh useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl, urlStr]];
    [self doGet:url completionBlock:^(NSString *json, NSError *err) {
        completionBlock(json , err);
    } refresh:refresh useCacheIfNetworkFail:useCacheIfNetworkFail];
}

-(void)doGet:(NSURL *)url completionBlock:(void (^)(NSString *json, NSError *err))completionBlock refresh:(BOOL)refresh useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail{
//    NSLog(@"request url:%@", url);
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] ua]];
    [_request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [_request setTimeOutSeconds:network_timeout];
    [_request setNumberOfTimesToRetryOnTimeout:network_retry_count];
    
    if(refresh){
        [_request setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    }
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
//    NSLog(@">>>>> Authorization:%@", [AppStatus sharedInstance].user.accessToken);
    __weak ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^
     {
         int statusCode = [request responseStatusCode];
         NSString *responseString = [request responseString];
         if([self isRequestFail:statusCode]){
             NSLog(@"styler exception:%d, %@， %@", statusCode, url, responseString);
             completionBlock(nil, [self getErrorFromResponse:responseString]);
         }else{
             completionBlock(responseString, nil);
         }
     }];
    
    [request setFailedBlock:^{
        NSError *err = [request error];
        NSLog(@"request faild:%@, %@", err, url);
        //如果设置了当网路失败时使用缓存
        if(useCacheIfNetworkFail){
            ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
            [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] ua]];
            [_request setCachePolicy:ASIDontLoadCachePolicy];
            __weak ASIHTTPRequest *requestCache = _request;
            [requestCache setCompletionBlock:^{
                NSString *responseString = [requestCache responseString];
                if (responseString == nil || [responseString isEqualToString:@""]) {
                    StylerException *exception = [[StylerException alloc] init];
                    exception.message = network_request_fail;
                    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
                    [errUserInfo setObject:exception forKey:@"stylerException"];
                    NSError *err = [[NSError alloc] initWithDomain:@"styler" code:exception.code userInfo:errUserInfo];
                    completionBlock(nil, err);
                }else{
                    completionBlock(responseString, nil);
                }
            }];
            
            [requestCache setFailedBlock:^{
                NSError *err = [self buildRequestFailError];
                completionBlock(nil, err);
            }];
            [requestCache startAsynchronous];
        }else{
            NSError *err = [self buildRequestFailError];
            completionBlock(nil, err);
            NSLog(@"get请求失败:%@,%@", url, err);
        }
        
    }];
    [request startAsynchronous];
}



-(void)post:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock params:(NSDictionary *)params{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl, urlStr]];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
//    [_request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] ua]];
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
    
    [_request setTimeOutSeconds:network_timeout];
    [_request setNumberOfTimesToRetryOnTimeout:network_retry_count];
    int paramsCount = 0;
    if(params != nil){
        NSArray *keys = [params allKeys];
        paramsCount = [keys count];
        for (int i = 0 ; i < paramsCount; i++) {
            NSString *key = [keys objectAtIndex:i];
//            NSLog(@"post %@:%@", key, [params objectForKey:key]);
            if([[params objectForKey:key] class] == [UIImage class]){
                NSData *imageData = UIImagePNGRepresentation([params objectForKey:key]);
                [_request addData:imageData withFileName:[NSString stringWithFormat:@"%@.jpg", key] andContentType:@"image/jpeg" forKey:key];
            }else{
                if([[params objectForKey:key] isKindOfClass:[NSArray class]]){
                    NSArray *multiValues = (NSArray *)[params objectForKey:key];
                    for (NSObject *obj in multiValues) {
                        [_request addPostValue:obj forKey:key];
                    }
                }else{
                    [_request addPostValue:[params objectForKey:key] forKey:key];
                }
            }
        }
    }
    
    
    
    __weak ASIFormDataRequest *request = _request;
    [request setCompletionBlock:^
     {
         int statusCode = [request responseStatusCode];
         NSString *responseString = [request responseString];
         if([self isRequestFail:statusCode]){
             NSLog(@"styler exception:%d, %@", statusCode, responseString);
             completionBlock(nil, [self getErrorFromResponse:responseString]);
         }else{
             completionBlock(responseString, nil);
         }
     }];
    
    [request setFailedBlock:^{
        NSError *err = [self buildRequestFailError];
        completionBlock(nil, err);
        NSLog(@"POST 请求失败:%@,%@", urlStr, err);
    }];
    [request startAsynchronous];
}

-(void)post:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock jsonString:(NSString *)jsonString {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", @"http://123.57.42.110:8081/api",urlStr]];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    //[_request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    
    [_request addRequestHeader:@"User-Agent" value:@"ios,8.1;iPhone Simulator,375*667;golf,1.0;93EC7AD5-63AA-460B-8B66-4B5140D0D96D;unknow"];
//    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:@"MTY6MDIyRDFGOTZBNzREMjNGQTQ5OURDNzBFMDIyNjAxMDE="];
//    }
    
    [_request setTimeOutSeconds:network_timeout];
    [_request setNumberOfTimesToRetryOnTimeout:network_retry_count];
    
    
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    NSMutableData *body = [NSMutableData dataWithData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]];
    [_request setPostBody:body];
    
    __weak ASIFormDataRequest *request = _request;
    [request setCompletionBlock:^
     {
         int statusCode = [request responseStatusCode];
         NSString *responseString = [request responseString];
         if([self isRequestFail:statusCode]){
             NSLog(@"styler exception:%d, %@", statusCode, responseString);
             StylerException *exception = [[StylerException alloc] init];
             [exception readFromJSONDictionary:[responseString objectFromJSONString]];
             NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
             [errUserInfo setObject:exception forKey:@"stylerException"];
             
             NSError *err = [[NSError alloc] initWithDomain:@"styler" code:exception.code userInfo:errUserInfo];
             completionBlock(nil, err);
         }else{
             completionBlock(responseString, nil);
         }
     }];
    
    [request setFailedBlock:^{
        completionBlock(nil, [self buildRequestFailError]);
        
    }];
    [request startAsynchronous];
}

-(void)delete:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl,urlStr]];
    NSLog(@"delete url : %@",url);
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] ua]];
    [_request setRequestMethod:@"DELETE"];
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
    
    [_request setTimeOutSeconds:network_timeout];
    [_request setNumberOfTimesToRetryOnTimeout:network_retry_count];
    
    __weak ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^
     {
         int statusCode = [request responseStatusCode];
         NSString *responseString = [request responseString];
         if([self isRequestFail:statusCode]){
             NSLog(@"styler exception:%@", responseString);
             StylerException *exception = [[StylerException alloc] init];
             [exception readFromJSONDictionary:[responseString objectFromJSONString]];
             NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
             [errUserInfo setObject:exception forKey:@"stylerException"];
             
             NSError *err = [[NSError alloc] initWithDomain:@"styler" code:exception.code userInfo:errUserInfo];
             completionBlock(nil, err);
         }else{
             completionBlock(responseString, nil);
         }
     }];
    
    [request setFailedBlock:^{
        completionBlock(nil, [self buildRequestFailError]);
        
    }];
    [request startAsynchronous];
}

-(void)put:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl, urlStr]];
    //NSLog(@"put url : %@",url);
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] ua]];
    [_request setRequestMethod:@"PUT"];
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
    
    [_request setTimeOutSeconds:network_timeout];
    [_request setNumberOfTimesToRetryOnTimeout:network_retry_count];
    
    __weak ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^
     {
         int statusCode = [request responseStatusCode];
         NSString *responseString = [request responseString];
         if([self isRequestFail:statusCode]){
             completionBlock(nil, [self getErrorFromResponse:responseString]);
         }else{
             completionBlock(responseString, nil);
         }
     }];
    
    [request setFailedBlock:^{
        completionBlock(nil, [self buildRequestFailError]);
        
    }];
    [request startAsynchronous];
}

-(NSError *) getErrorFromResponse:(NSString *)responseString{
    StylerException *exception = [[StylerException alloc] init];
    [exception readFromJSONDictionary:[responseString objectFromJSONString]];
    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
    [errUserInfo setObject:exception forKey:@"stylerException"];
    
    NSError *err = [[NSError alloc] initWithDomain:@"styler" code:exception.code userInfo:errUserInfo];
    return err;
}

-(NSError *) buildRequestFailError{
    StylerException *exception = [[StylerException alloc] init];
    exception.message = network_request_fail;
    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
    [errUserInfo setObject:exception forKey:@"stylerException"];
    
    NSError *err = [[NSError alloc] initWithDomain:@"styler" code:exception.code userInfo:errUserInfo];
    return err;
}

-(BOOL)isRequestFail:(int)statusCode{
    return (statusCode != 200 && statusCode != 201 && statusCode != 204 && statusCode != 304);
}

+(HttpRequestFacade *)sharedInstance{
    static HttpRequestFacade *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[super allocWithZone:nil] init];
    }
    return sharedInstance;
}

+(id) allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}

@end
