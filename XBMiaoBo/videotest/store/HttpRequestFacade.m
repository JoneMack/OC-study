//
//  UserStore.h
//  Golf
//
//  Created by xubojoy on 15/3/30.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//
#import "JSONKit.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@implementation HttpRequestFacade

-(void)get:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock refresh:(BOOL)refresh useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppStatus sharedInstance].apiUrl, urlStr]];
    NSLog(@">>>>>>>>>>请求的URL>-------%@>>>>>%@",[AppStatus sharedInstance].apiUrl,url);
    [self doGet:url completionBlock:^(id json, NSError *err) {
        completionBlock(json , err);
    } refresh:refresh useCacheIfNetworkFail:useCacheIfNetworkFail];
}

-(void)doGet:(NSURL *)url completionBlock:(void (^)(id json, NSError *err))completionBlock refresh:(BOOL)refresh useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail{
    NSString *urlstr=[NSString stringWithFormat:@"%@",url];
    NSLog(@">>>>>>>>>>请求的URL>>>>>>%@",urlstr);
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.requestSerializer.timeoutInterval = network_timeout;
    if (refresh) {
        [operation.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData | NSURLRequestReturnCacheDataDontLoad];
    }
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    NSLog(@"请求网址  %@",urlstr);
    [operation GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值——————————  %ld",(long)response.statusCode);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            completionBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"doctor exception:%@---------------%d----%d", errorResponse,statusCode,(int)error.code);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(void)           doIOSGet:(NSURL *)url
           completionBlock:(void (^)(id json, NSError *err))completionBlock
                   refresh:(BOOL)refresh
     useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail{
    NSString *urlstr=[NSString stringWithFormat:@"%@",url];
    NSLog(@">>>>>>>>>>请求的URL>>>>>>%@",urlstr);
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
        if (refresh) {
        [operation.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData | NSURLRequestReturnCacheDataDontLoad];
    }
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencoded",@"text/html;charset=utf-8", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    NSLog(@"请求网址  %@",urlstr);
    [operation.reachabilityManager isReachable];
    [operation GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值——————————  %ld",(long)response.statusCode);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            completionBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"doctor exception:%@---------------%d----%d", errorResponse,statusCode,(int)error.code);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(void)post:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock commonParams:(NSDictionary *)params{
    //组装url
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",params);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"multipart/form-data",@"Content-Type",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求成功：%ld---%@",(long)response.statusCode,responseObject);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            completionBlock(responseObject, nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
         NSLog(@"doctor exception:%@---------------%d----%d", errorResponse,statusCode,(int)error.code);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
//        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(void)post:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock params:(NSDictionary *)params{
    //组装url
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",params);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"multipart/form-data",@"Content-Type",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int paramsCount = 0;
            if(params != nil){
                NSArray *keys = [params allKeys];
                paramsCount = (int)[keys count];
                for (int i = 0 ; i < paramsCount; i++) {
                    NSString *key = [keys objectAtIndex:i];
                    NSLog(@"post %@:%@", key, [params objectForKey:key]);
                    if([[params objectForKey:key] class] == [UIImage class]){
                        NSData *imageData = UIImageJPEGRepresentation([params objectForKey:key],0.5);
                        NSLog(@"post %@:%@---%@", key, [params objectForKey:key],imageData);
                        [formData appendPartWithFileData:imageData name:key fileName:[NSString stringWithFormat:@"%@.jpg", key] mimeType:@"image/jpeg"];
                    }
                }
            }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求成功：%ld",(long)response.statusCode);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            [self pwdErrorHandle:statusCode];
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            completionBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"doctor exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(void)post:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock jsonString:(NSDictionary *)jsonString {
    
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer = [AFJSONRequestSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",jsonString);
    NSLog(@"请求token  %@",[AppStatus sharedInstance].user.accessToken);
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"multipart/form-data",@"Content-Type",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation POST:urlStr parameters:jsonString progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值——————————  %ld",(long)response.statusCode);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            [self pwdErrorHandle:statusCode];
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            completionBlock(responseObject, nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"doctor exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(void)delete:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock param:(NSDictionary *)param{
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",[AppStatus sharedInstance].apiUrl,urlStr];
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    NSLog(@"请求网址  %@",urlstr);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation DELETE:urlstr parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值——————————  %ld",(long)response.statusCode);
        
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            NSLog(@"doctor exception:%@", responseObject);
            [self pwdErrorHandle:statusCode];
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }else{
            completionBlock(responseObject, nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"doctor exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(void)put:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock{
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    NSLog(@"请求网址  %@",urlStr);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }
     operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation PUT:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"doctor exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(void)put:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock params:(NSDictionary *)params{
    //组装url
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",params);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值—————%@—————  %ld",task.response,(long)response.statusCode);
            completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"doctor exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"doctor" code:exception.code userInfo:errUserInfo];
        NSLog(@"err--------%d", (int)err.code);
        if ([self isRequestStatusCode:(int)err.code]) {
            [self pwdErrorHandle:(int)err.code];
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else if(![self isRequestStatusCode:(int)err.code] && [self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:errorResponse]);
        }else{
            completionBlock(errorResponse, nil);
        }
    }];
}

-(NSError *) getErrorFromResponse:(NSString *)responseString{
    ExceptionMsg *exception = [[ExceptionMsg alloc] init];
    [exception readFromJSONDictionary:[responseString objectFromJSONString]];
    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
    [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
    
    NSError *err = [[NSError alloc] initWithDomain:@"crazydoctor" code:exception.code userInfo:errUserInfo];
    return err;
}

-(NSError *) buildRequestFailError{
    ExceptionMsg *exception = [[ExceptionMsg alloc] init];
    exception.message = network_request_fail;
    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
    [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
    
    NSError *err = [[NSError alloc] initWithDomain:@"crazydoctor" code:exception.code userInfo:errUserInfo];
    return err;
}

-(BOOL)isRequestFail:(int)statusCode{
    return (statusCode != 200 && statusCode != 201 && statusCode != 204 && statusCode != 304);
}

-(BOOL)isRequestStatusCode:(int)statusCode{
    return (statusCode == 401 || statusCode == 40001);
}
//处理密码错误时，让用户重新登录
-(void)pwdErrorHandle:(int)statusCode{
    NSLog(@">>错误码>>>>>>>>%d",statusCode);
    if ([[AppStatus sharedInstance] logined]) {
        NSLog(@"用户登陆");
        if ([self isRequestStatusCode:statusCode]){
                    }
    }else{
        NSLog(@"用户已退出");
         [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_session_update object:nil];
//        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar.tabBarController setTabBarHidden:YES animated:NO];
//        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar setSelectedIndex:0];
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
