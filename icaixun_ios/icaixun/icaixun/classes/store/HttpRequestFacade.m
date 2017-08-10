//
//  HttpRequestFacade.m
//  iUser
//
//  Created by System Administrator on 13-5-3.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "UserStore.h"

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
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
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
    NSLog(@">>>>> Authorization:%@", [AppStatus sharedInstance].user.accessToken);
    __weak ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^
     {
         int statusCode = [request responseStatusCode];
         NSString *responseString = [request responseString];
//         NSLog(@">>>>response str:%@" , responseString);
         if([self isRequestFail:statusCode]){
             NSLog(@"icaixun exception:%d, %@， %@", statusCode, url, responseString);
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
            [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
            [_request setCachePolicy:ASIDontLoadCachePolicy];
            __weak ASIHTTPRequest *requestCache = _request;
            [requestCache setCompletionBlock:^{
                NSString *responseString = [requestCache responseString];
                if (responseString == nil || [responseString isEqualToString:@""]) {
//                    StylerException *exception = [[StylerException alloc] init];
//                    exception.message = network_request_fail;
//                    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
//                    [errUserInfo setObject:exception forKey:@"stylerException"];
//                    NSError *err = [[NSError alloc] initWithDomain:@"styler" code:exception.code userInfo:errUserInfo];
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
    NSLog(@">>>>>url:%@" , url);
    [self doPost:url completionBlock:^(NSString *json, NSError *err) {
        completionBlock(json , err);
    } params:params];
}



-(void)doPost:(NSURL *)url completionBlock:(void (^)(NSString *json, NSError *err))completionBlock params:(NSDictionary *)params
{
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    //    [_request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
    
    [_request setTimeOutSeconds:network_timeout];
    [_request setNumberOfTimesToRetryOnTimeout:network_retry_count];
    int paramsCount = 0;
    if(params != nil){
        NSArray *keys = [params allKeys];
        paramsCount = (int)[keys count];
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
             NSLog(@"icaixun exception:%d, %@", statusCode, responseString);
             completionBlock(nil, [self getErrorFromResponse:responseString]);
         }else{
             completionBlock(responseString, nil);
         }
     }];
    
    [request setFailedBlock:^{
        NSError *err = [self buildRequestFailError];
        completionBlock(nil, err);
    }];
    [request startAsynchronous];

}


-(void)post:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock jsonString:(NSString *)jsonString {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl,urlStr]];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    //[_request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
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
         
//         NSLog(@">>>>response str:%@" , responseString);
         
         if([self isRequestFail:statusCode]){
             
             ExceptionMsg *exception = [[ExceptionMsg alloc] init];
             [exception readFromJSONDictionary:[responseString objectFromJSONString]];
             
             
             NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
             [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
             NSError *err = [[NSError alloc] initWithDomain:@"icaixun" code:exception.code userInfo:errUserInfo];
             
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
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
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
             ExceptionMsg *exception = [[ExceptionMsg alloc] init];
             [exception readFromJSONDictionary:[responseString objectFromJSONString]];
             NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
             [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
             NSError *err = [[NSError alloc] initWithDomain:@"icaixun" code:exception.code userInfo:errUserInfo];
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
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
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


-(void)put:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock params:(NSDictionary *)params{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl, urlStr]];
    NSLog(@"put url : %@",urlStr);
//    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    [_request setRequestMethod:@"PUT"];
    
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
    
    [_request setTimeOutSeconds:network_timeout];
    [_request setNumberOfTimesToRetryOnTimeout:network_retry_count];
    int paramsCount = 0;
    if(params != nil){
        NSArray *keys = [params allKeys];
        paramsCount = (int)[keys count];
        for (int i = 0 ; i < paramsCount; i++) {
            NSString *key = [keys objectAtIndex:i];
            if([[params objectForKey:key] isKindOfClass:[NSArray class]]){
                NSArray *multiValues = (NSArray *)[params objectForKey:key];
                for (NSObject *obj in multiValues) {
                    [_request addPostValue:obj forKey:key];
                }
            }else{
                [_request setPostValue:[params objectForKey:key] forKey:key];
            }
        }
    }
    __weak ASIFormDataRequest *request = _request;
    [request setCompletionBlock:^
     {
         int statusCode = [request responseStatusCode];
         NSLog(@"statusCode:%d" , statusCode);
         NSString *responseString = [request responseString];
         if([self isRequestFail:statusCode]){
             [self pwdErrorHandle:statusCode];
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

-(void) put:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock jsonString:(NSString *)jsonString{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl,urlStr]];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    [_request setRequestMethod:@"PUT"];
    [_request addRequestHeader:@"User-Agent" value:[[AppStatus sharedInstance] userAgent]];
    if([[AppStatus sharedInstance] logined]){
        [_request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken]];
    }
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
             NSLog(@"icaixun exception:%d, %@", statusCode, responseString);
             [self pwdErrorHandle:statusCode];
             ExceptionMsg *exception = [[ExceptionMsg alloc] init];
             [exception readFromJSONDictionary:[responseString objectFromJSONString]];
             NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
             [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
//             
             NSError *err = [[NSError alloc] initWithDomain:@"icaixun" code:exception.code userInfo:errUserInfo];
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


-(NSError *) getErrorFromResponse:(NSString *)responseString{
    ExceptionMsg *exception = [[ExceptionMsg alloc] init];
    [exception readFromJSONDictionary:[responseString objectFromJSONString]];
    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
    [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
    //
    NSError *err = [[NSError alloc] initWithDomain:@"icaixun" code:exception.code userInfo:errUserInfo];
    return err;
}

-(NSError *) buildRequestFailError{
    ExceptionMsg *exception = [[ExceptionMsg alloc] init];
    exception.message = network_request_fail;
    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
    [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
    
    NSError *err = [[NSError alloc] initWithDomain:@"icaixun" code:exception.code userInfo:errUserInfo];
    return err;
}

-(BOOL)isRequestFail:(int)statusCode{
    return (statusCode != 200 && statusCode != 201 && statusCode != 204 && statusCode != 304);
}
-(BOOL)isRequestStatusCode:(int)statusCode{
    return (statusCode == 400 || statusCode == 401 || statusCode == 4001);
}


-(void)pwdErrorHandle:(int)statusCode{
    if ([self isRequestStatusCode:statusCode]){
//        [[UserStore sharedStore] removeSession:^(NSError *err) {
//           
//        }];
    }
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
