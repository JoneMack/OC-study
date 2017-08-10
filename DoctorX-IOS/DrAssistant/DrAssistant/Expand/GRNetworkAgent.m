

#import "GRNetworkAgent.h"
#import "AFHTTPRequestOperationManager.h"
#import "WSProgressHUD.h"

@implementation GRNetworkAgent {
    AFHTTPRequestOperationManager *_manager;
    NSMutableDictionary * _requestsRecord;
}

+ (GRNetworkAgent *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}
- (void)addRequest:(GRBaseRequest *)request
{
    GRRequestMethod method = request.requestMethod;
    NSString * url = [NSString stringWithFormat:@"%@%@",request.baseUrl,request.requestUrl];
    NSDictionary * param = request.requestParam;
//    FTLOG(@"requestParam%@", param);
//    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",nil];
    
    if (request.requestSerializerType == GRRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if (request.requestSerializerType == GRRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
//    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (method == GRRequestMethodGet) {
        request.requestOperation = [_manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [self handleRequestResult:operation responeObejct:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self handleRequestResult:operation responeObejct:error];
                   }];
    }else if (method == GRRequestMethodPost) {
        request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation responeObejct:responseObject];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation responeObejct:error];
        }];
    }
//    NSLog(@"%@",request);
    [self addOperation:request];
}

//初步处理
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation responeObejct:(id)responeObejct {
    NSString * key = [self requestHashKey:operation];
    GRBaseRequest *request = _requestsRecord[key];
    
    FTLOG(@"responseString%@", operation.responseString);
//    FTLOG(@"statusCode:%zi", operation.response.statusCode);
//    FTLOG(@"%@", operation.error);
//    FTLOG(@"%@", operation.responseObject);
//    NSLog(@"responseString%@", operation.responseString);
//     NSLog(@"%@", operation.error);
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            
            if ([responeObejct isDictionary])
            {
                NSDictionary *dic = (NSDictionary *)responeObejct;
                NSString *msg = [dic safeObjectForKey: @"msg"];
                
                NSString *timestamp = [dic stringValueForKey:@"timestamp"];
                
                if (![Utils isBlankString:timestamp]) {
                    [GlobalConst shareInstance].timeStamp = timestamp;
                }
                
                //BOOL isSuccess = [dic boolValueForKey: @"success"];
                
                if ([Utils isBlankString:msg]) {
                    [Utils dismissStatusToast];
                }
                if (![msg isEqualToString:@"Success"]&&![msg isEqualToString:@"机构列表请求成功"]) {
                  [Utils showString:msg];
                }
            }
            
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request,responeObejct);
            }
        }else {
            
             [Utils showString:@"数据加载失败"];
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request,responeObejct);
            }
        }
    }else{
        [Utils dismissStatusToast];
    }
        
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

////再次处理
//- (void)handleRequest:(GRBaseRequest *)request
//{
//    if (request) {
//        BOOL succeed = [self checkResult:request];
//        if (succeed) {
//            if (request.successCompletionBlock) {
//                request.successCompletionBlock(request);
//            }
//        }else {
//            if (request.failureCompletionBlock) {
//                request.failureCompletionBlock(request);
//            }
//        }
//    }
//}

- (BOOL)checkResult:(GRBaseRequest *)request
{
    BOOL result = [request statusCodeValidator];
    return result;
}

- (void)addOperation:(GRBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString * key = [self requestHashKey:request.requestOperation];
        _requestsRecord[key] = request;
    }
}
- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}
- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString * key = [self requestHashKey:operation];
    [_requestsRecord removeObjectForKey:key];
}

- (void)requestUrl:(NSString *)url param:(NSDictionary *)requestArgument baseUrl:(NSString *)baseUrl withRequestMethod:(GRRequestMethod)requestMethod withCompletionBlockWithSuccess:(void (^)(GRBaseRequest *, id))success failure:(void (^)(GRBaseRequest *, NSError *))failure withTag:(NSInteger)tag

{
//    [Utils showStatusToast:@"请稍后..."];
    
    GRBaseRequest * base = [[GRBaseRequest alloc] init];
    base.baseUrl = baseUrl;
    base.requestUrl = url;
    base.tag = tag;
    base.requestParam = requestArgument;
    base.requestMethod = requestMethod;
    base.successCompletionBlock = success;
    base.failureCompletionBlock = failure;
    base.requestSerializerType = GRRequestSerializerTypeHTTP;
    [self addRequest:base];
    
  
}

- (void)uploadFile:(NSString *)url
           baseUrl:(NSString *)baseUrl
          filePath:(NSString *)filePath
          fileName:(NSString *)fileName
             param:(NSDictionary *)requestArgument
           Success:(void (^)(GRBaseRequest *request, id reponeObject))success
           failure:(void (^)(GRBaseRequest *request, NSError *error))failure withTag:(NSInteger)tag
{
    [Utils showStatusToast:@"请稍后..."];
    
    NSString * requrl = [NSString stringWithFormat:@"%@%@",baseUrl, url];
    
    GRBaseRequest * base = [[GRBaseRequest alloc] init];
    base.baseUrl = baseUrl;
    base.requestUrl = url;
    base.tag = tag;
    base.requestParam = requestArgument;
    base.requestMethod = GRRequestMethodPost;
    base.successCompletionBlock = success;
    base.failureCompletionBlock = failure;
    base.requestSerializerType = GRRequestSerializerTypeHTTP;
    //[self addRequest:base];
    
    base.requestOperation=[_manager POST:requrl parameters:requestArgument constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSURL *fileUrl  = [NSURL fileURLWithPath:filePath];
        [formData appendPartWithFileURL:fileUrl name:fileName error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleRequestResult:operation responeObejct:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleRequestResult:operation responeObejct:error];
    }];
    [self addOperation:base];
}

- (void)cancelRequest:(NSInteger)tag {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        GRBaseRequest *request = copyRecord[key];
        if (request.tag == tag) {
            [request.requestOperation cancel];
            [self removeOperation:request.requestOperation];
            [request clearCompletionBlock];
        }
    }
}
- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        GRBaseRequest *request = copyRecord[key];
        [request stop];
    }
}
@end
