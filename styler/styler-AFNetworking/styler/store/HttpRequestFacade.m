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
    NSString *urlstr=[NSString stringWithFormat:@"%@",url];
    AFHTTPRequestOperationManager *operation=[AFHTTPRequestOperationManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }

    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"请求网址  %@",urlstr);
    [operation.reachabilityManager isReachable];
    [operation GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            NSString *urlstr=[NSString stringWithFormat:@"%@%@",[AppStatus sharedInstance].apiUrl,url];
            AFHTTPRequestOperationManager *operation=[AFHTTPRequestOperationManager manager];
            operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            [operation GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completionBlock(operation.responseString, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completionBlock(nil, [self getErrorFromResponse:operation.responseString]);
            }];
        }else{
//             NSLog(@"请求返回值  %@",operation.responseString);
            completionBlock(operation.responseString,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求错误返回值——————————  %@",operation.responseString);
        completionBlock(nil,error);
        [SVProgressHUD showErrorWithStatus:@"网络数据异常,请重试..." duration:1.0];
        
    }];
}

-(void)post:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock params:(NSDictionary *)params{
    //组装url
    NSString *url = [NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].apiUrl, urlStr];
    AFHTTPRequestOperationManager *operation=[AFHTTPRequestOperationManager manager];
    NSLog(@"请求网址________  %@",url);
    NSLog(@"请求参数  %@",params);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [operation POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回值  %@",operation.responseString);
        if (responseObject == nil) {
            completionBlock(nil,[self getErrorFromResponse:operation.responseString]);
        }else{
            completionBlock(operation.responseString,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误返回值  %@",operation.responseString);
         completionBlock(nil,error);
        [SVProgressHUD showErrorWithStatus:@"网络数据异常,请重试..." duration:1.0];
        
    }];
}

-(void)post:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock jsonString:(NSString *)jsonString {
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",[AppStatus sharedInstance].apiUrl,urlStr];
    AFHTTPRequestOperationManager *operation=[AFHTTPRequestOperationManager manager];
    NSLog(@"请求网址  %@",urlstr);
    NSLog(@"请求参数  %@",jsonString);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }

    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [operation POST:urlstr parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回值  %@",responseObject);
        if (responseObject == nil) {
            completionBlock(nil,[self getErrorFromResponse:operation.responseString]);
        }
        completionBlock(operation.responseString,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil,error);
        [SVProgressHUD showErrorWithStatus:@"网络数据异常,请重试..." duration:1.0];
        
    }];
}

-(void)delete:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock{
    NSString *urlstr=[NSString stringWithFormat:@"%@%@",[AppStatus sharedInstance].apiUrl,urlStr];
    AFHTTPRequestOperationManager *operation=[AFHTTPRequestOperationManager manager];
    NSLog(@"请求网址  %@",urlstr);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }

    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [operation DELETE:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回值  %@",responseObject);
        if (responseObject == nil) {
            completionBlock(nil,[self getErrorFromResponse:operation.responseString]);
        }
        completionBlock(operation.responseString,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil,error);
    }];
}

-(void)put:(NSString *)urlStr completionBlock:(void (^)(NSString *json, NSError *err))completionBlock{

    NSString *urlstr=[NSString stringWithFormat:@"%@%@",[AppStatus sharedInstance].apiUrl,urlStr];
    AFHTTPRequestOperationManager *operation=[AFHTTPRequestOperationManager manager];
    NSLog(@"请求网址  %@",urlstr);
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation.requestSerializer setValue:[[AppStatus sharedInstance] ua] forHTTPHeaderField:@"User-Agent"];
    if([[AppStatus sharedInstance] logined]){
        [operation.requestSerializer setValue:[NSString stringWithFormat:@"%@",[AppStatus sharedInstance].user.accessToken] forHTTPHeaderField:@"Authorization"];
    }

    operation.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"multipart/form-data",@"Content-Type",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [operation PUT:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回值  %@",operation.responseString);
        if (responseObject == nil) {
            completionBlock(nil,[self getErrorFromResponse:operation.responseString]);
        }
        completionBlock(operation.responseString,nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil,error);
    }];
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
