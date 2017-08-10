//
//  UserStore.h
//  Golf
//
//  Created by xubojoy on 15/3/30.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//
#import "JSONKit.h"
#import "UserStore.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@implementation HttpRequestFacade

-(void)get:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock
    params:(NSMutableDictionary *)params
   refresh:(BOOL)refresh
useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppStatus sharedInstance].apiUrl, urlStr]];
    NSLog(@">>>>>>>>>>请求的URL>-------%@>>>>>%@",[AppStatus sharedInstance].apiUrl,url);
    [self doGet:url completionBlock:^(id json, NSError *err) {
        completionBlock(json , err);
    } params:(NSMutableDictionary *)params refresh:refresh useCacheIfNetworkFail:useCacheIfNetworkFail];
}

-(void)doGet:(NSURL *)url completionBlock:(void (^)(id json, NSError *err))completionBlock params:(NSMutableDictionary *)params refresh:(BOOL)refresh useCacheIfNetworkFail:(BOOL)useCacheIfNetworkFail{
    NSString *urlstr=[NSString stringWithFormat:@"%@",url];
    NSLog(@">>>>>>>>>>请求的URL>>>>>>%@",urlstr);
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    
    if(params == nil){
        params = [NSMutableDictionary new];
    }
    [params setObject:@"ios" forKey:@"deviceType"];
    [params setObject:@"9205faaa171002410180c680c004a5152bf657af" forKey:@"deviceID"];
    [params setObject:[[AppStatus sharedInstance] appVersion] forKey:@"version"];
    
    
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        [params setObject:as.token forKey:@"token"];
    }else{
        [params setObject:@"" forKey:@"token"];
    }
    
    
    NSLog(@"get params :%@" , params);
    
    if (refresh) {
        [operation.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData | NSURLRequestReturnCacheDataDontLoad];
    }
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencoded",@"text/html;charset=utf-8", nil];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    NSLog(@"请求网址  %@",urlstr);
    [operation.reachabilityManager isReachable];
    [operation GET:urlstr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值——————————  %ld",(long)response.statusCode);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            if([responseObject valueForKey:@"success"]){
                completionBlock(responseObject, nil);
            }else{
                
                ExceptionMsg *exception = [[ExceptionMsg alloc] init];
                [exception setMessage:[responseObject valueForKey:@"errorMsg"]];
                [exception setStatus:500];
                if ([[responseObject valueForKey:@"errorType"] isEqualToString:request_exception_api_token_expired]) {
                    [exception setCode:request_exception_app_token_expired];
                }else{
                    [exception setCode:500];
                }
                
                NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
                [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
                NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
                completionBlock(nil, err);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"xiangyu exception:%@---------------%d----%d", errorResponse,statusCode,(int)error.code);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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

-(void)post:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock commonParams:(NSMutableDictionary *)params{
    //组装url
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",params);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    
    
    if(params == nil){
        params = [NSMutableDictionary new];
    }
    [params setObject:@"ios" forKey:@"deviceType"];
    [params setObject:@"9205faaa171002410180c680c004a5152bf657af" forKey:@"deviceID"];
    [params setObject:[[AppStatus sharedInstance] appVersion] forKey:@"version"];
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        [params setObject:as.token forKey:@"token"];
    }

    
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"multipart/form-data",@"Content-Type",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html" , @"application/pdf", nil];
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
            Boolean flag= [[responseObject valueForKey:@"success"] boolValue];
            if(flag){
                completionBlock(responseObject, nil);
            }else{
                
                ExceptionMsg *exception = [[ExceptionMsg alloc] init];
                [exception setMessage:[responseObject valueForKey:@"errorMsg"]];
                [exception setStatus:500];
                [exception setCode:500];
                NSLog(@" error msg:%@" , [responseObject valueForKey:@"errorMsg"]);
                
                NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
                [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
                NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
                completionBlock(nil, err);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
         NSLog(@"xiangyu exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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


-(void)   postForData:(NSString *)urlStr
      completionBlock:(void (^)(id json, NSError *err))completionBlock
         commonParams:(NSMutableDictionary *)params{
    
    //组装url
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    
    
    if(params == nil){
        params = [NSMutableDictionary new];
    }
    [params setObject:@"ios" forKey:@"deviceType"];
    [params setObject:@"9205faaa171002410180c680c004a5152bf657af" forKey:@"deviceID"];
    [params setObject:[[AppStatus sharedInstance] appVersion] forKey:@"version"];
    [params setObject:@"" forKey:@"vcode"];
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        [params setObject:as.token forKey:@"token"];
    }else{
        [params setObject:@"" forKey:@"token"];
    }
    
    NSMutableDictionary *dataParams = [NSMutableDictionary new];
    [dataParams setObject:[NSStringUtils string2JsonString:params] forKey:@"data"];

    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",dataParams);
    
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"multipart/form-data",@"Content-Type",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation POST:urlStr parameters:dataParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求成功：%ld---%@",(long)response.statusCode,responseObject);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            Boolean flag= [[responseObject valueForKey:@"success"] boolValue];
            if(flag){
                completionBlock(responseObject, nil);
            }else{
                
                ExceptionMsg *exception = [[ExceptionMsg alloc] init];
                [exception setMessage:[responseObject valueForKey:@"errorMsg"]];
                [exception setStatus:500];
                [exception setCode:500];
                NSLog(@" error msg:%@" , [responseObject valueForKey:@"errorMsg"]);
                
                NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
                [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
                NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
                completionBlock(nil, err);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"xiangyu exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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




-(void) postForDataWithoutDeviceType:(NSString *)urlStr
      completionBlock:(void (^)(id json, NSError *err))completionBlock
         commonParams:(NSMutableDictionary *)params{
    
    //组装url
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    
    
    if(params == nil){
        params = [NSMutableDictionary new];
    }
//    [params setObject:@"ios" forKey:@"deviceType"];
    [params setObject:@"9205faaa171002410180c680c004a5152bf657af" forKey:@"deviceID"];
//    [params setObject:[[AppStatus sharedInstance] appVersion] forKey:@"version"];
//    [params setObject:@"" forKey:@"vcode"];
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        [params setObject:as.token forKey:@"token"];
    }else{
        [params setObject:@"" forKey:@"token"];
    }
    
    NSMutableDictionary *dataParams = [NSMutableDictionary new];
    [dataParams setObject:[NSStringUtils string2JsonString:params] forKey:@"data"];
    
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",dataParams);
    
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"multipart/form-data",@"Content-Type",@"application/json;charset=UTF-8", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation POST:urlStr parameters:dataParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求成功：%ld---%@",(long)response.statusCode,responseObject);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            Boolean flag= [[responseObject valueForKey:@"success"] boolValue];
            if(flag){
                completionBlock(responseObject, nil);
            }else{
                
                ExceptionMsg *exception = [[ExceptionMsg alloc] init];
                [exception setMessage:[responseObject valueForKey:@"errorMsg"]];
                [exception setStatus:500];
                [exception setCode:500];
                NSLog(@" error msg:%@" , [responseObject valueForKey:@"errorMsg"]);
                
                NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
                [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
                NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
                completionBlock(nil, err);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"xiangyu exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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




-(void)post:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock params:(NSMutableDictionary *)params{
    //组装url
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-quickviewplus, */*", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        urlStr = [NSString stringWithFormat:@"%@?token=%@" , urlStr , as.token];
    }
    
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",params);
    
    
    [operation POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int paramsCount = 0;
            if(params != nil){
                NSArray *keys = [params allKeys];
                paramsCount = (int)[keys count];
                for (int i = 0 ; i < paramsCount; i++) {
                    NSString *key = [keys objectAtIndex:i];
                    if([[params objectForKey:key] class] == [UIImage class]){
                        NSData *imageData = UIImagePNGRepresentation([params objectForKey:key]);
                        [formData appendPartWithFileData:imageData name:key fileName:[NSString stringWithFormat:@"%@.jpg", key] mimeType:@"image/jpeg"];
                    }
                }
            }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求成功：%ld",(long)response.statusCode);
        
        NSLog(@" response :%@" , response);
        NSLog(@">>>>> response object:%@" , responseObject);
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }
        else{
            Boolean flag= [[responseObject valueForKey:@"success"] boolValue];
            if(flag){
                completionBlock(responseObject, nil);
            }else{
                
                ExceptionMsg *exception = [[ExceptionMsg alloc] init];
                [exception setMessage:[responseObject valueForKey:@"errorMsg"]];
                NSLog(@" error msg:%@" , [responseObject valueForKey:@"errorMsg"]);
                [exception setStatus:500];
                [exception setCode:500];
                NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
                [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
                NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
                completionBlock(nil, err);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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

-(void) postImg:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock image:(UIImage *)image
{
    AppStatus *as = [AppStatus sharedInstance];
    
    NSString *str = [NSString stringWithFormat:@"%@?token=%@",urlStr , as.token];
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSData *data = nil;
    if (UIImageJPEGRepresentation(image, 0.5) == nil) {
        data = UIImagePNGRepresentation(image);
    }else{
        data = UIImageJPEGRepresentation(image, 0.5);
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    NSString *fileType = @"image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, application/x-quickviewplus, */*";
    
    [request setValue:fileType forHTTPHeaderField:@"Accept"];
    request.HTTPBody = body;
    
    // 设置请求头
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    // 声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data;   boundary=---------------------------7d318fd100112" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
    
    [body appendData:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (dic[@"success"]) {
                //上传成功
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"dic :%@" , dic);
                NSLog(@"上传成功");
                completionBlock(dic, nil);

            }else{
                //上传失败
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"上传失败");
                ExceptionMsg *exception = [[ExceptionMsg alloc] init];
                [exception setMessage:[dic valueForKey:@"errorMsg"]];
                NSLog(@" error msg:%@" , [dic valueForKey:@"errorMsg"]);
                [exception setStatus:500];
                [exception setCode:500];
                NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
                [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
                NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
                completionBlock(nil, err);
                
            }
            
            
            
        } else {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            
            
        }
    }];
}

-(void)post:(NSString *)urlStr completionBlock:(void (^)(id json, NSError *err))completionBlock jsonString:(NSMutableDictionary *)jsonString {
    
    AFHTTPSessionManager *operation=[AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer = [AFJSONRequestSerializer serializer];
    operation.requestSerializer.timeoutInterval = network_timeout;
    
    if(jsonString == nil){
        jsonString = [NSMutableDictionary new];
    }
    [jsonString setObject:@"ios" forKey:@"deviceType"];
    [jsonString setObject:@"9205faaa171002410180c680c004a5152bf657af" forKey:@"deviceID"];
    [jsonString setObject:[[AppStatus sharedInstance] appVersion] forKey:@"version"];
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        [jsonString setObject:as.token forKey:@"token"];
    }else{
        [jsonString setObject:@"" forKey:@"token"];
    }
    NSLog(@"请求网址________  %@",urlStr);
    NSLog(@"请求参数  %@",jsonString);
    NSLog(@"请求token  %@",[AppStatus sharedInstance].token);
    
    
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
        NSLog(@"xiangyu exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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
    
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation DELETE:urlstr parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值——————————  %ld",(long)response.statusCode);
        
        int statusCode = (int)response.statusCode;
        if([self isRequestFail:statusCode]){
            NSLog(@"xiangyu exception:%@", responseObject);
            [self pwdErrorHandle:statusCode];
            completionBlock(nil, [self getErrorFromResponse:responseObject]);
        }else{
            completionBlock(responseObject, nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"xiangyu exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation PUT:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        int statusCode = (int)response.statusCode;
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"xiangyu exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operation setResponseSerializer:responseSerializer];
    [operation PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"请求返回值—————%@—————  %ld",task.response,(long)response.statusCode);
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
        NSLog(@"xiangyu exception:%@", errorResponse);
        ExceptionMsg *exception = [[ExceptionMsg alloc] init];
        [exception readFromJSONDictionary:[errorResponse objectFromJSONString]];
        NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
        [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
        NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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
    
    NSError *err = [[NSError alloc] initWithDomain:@"crazyxiangyu" code:exception.code userInfo:errUserInfo];
    return err;
}

-(NSError *) buildRequestFailError{
    ExceptionMsg *exception = [[ExceptionMsg alloc] init];
    exception.message = network_request_fail;
    NSMutableDictionary *errUserInfo = [[NSMutableDictionary alloc] init];
    [errUserInfo setObject:exception forKey:@"ExceptionMsg"];
    
    NSError *err = [[NSError alloc] initWithDomain:@"xiangyu" code:exception.code userInfo:errUserInfo];
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
        if ([self isRequestStatusCode:statusCode]){
            [[UserStore sharedStore] removeSession:^(NSError *err) {
                AppStatus *as = [AppStatus sharedInstance];
                [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:as.user.headPic]]];// 清除旧的头像缓存
                [as initBaseData];
                [AppStatus saveAppStatus];
                //返回tabbar第一个view
//                [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar.tabBarController setTabBarHidden:YES animated:NO];
//                [((AppDelegate *)[UIApplication sharedApplication].delegate).tabbar setSelectedIndex:0];
            } accessToken:[AppStatus sharedInstance].token];
        }
    }else{
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
