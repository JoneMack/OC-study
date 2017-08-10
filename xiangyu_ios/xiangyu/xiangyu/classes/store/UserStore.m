    //
//  UserStore.m
//  Golf
//
//  Created by xubojoy on 15/3/30.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//

#import "UserStore.h"
#import "JSONKit.h"
#import "User.h"
#import "MD5Utils.h"


@implementation UserStore
+ (UserStore *) sharedStore{
    static UserStore *userStore = nil;
    if(!userStore){
        userStore = [[super allocWithZone:nil] init];
    }
    
    return userStore;
}

+(id) allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

-(void) requestTempPwd:(void (^)(NSError *err))completionBlock mobileNo:(NSString *)mobileNo{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:mobileNo forKey:@"mobile"];
    
    NSString *url = [NSString stringWithFormat:@"/regist/verificationCode"];
    
    [requestFacade get:url completionBlock:^(id json, NSError *err) {
        
        if(err == nil){
            
            
            
            completionBlock(nil);
        }else{
            completionBlock(err);
        }
        
    } params:params refresh:NO useCacheIfNetworkFail:NO];
}


-(void) login:(void (^)(User *user, NSError *err))completionBlock mobileNo:(NSString *) mobileNo pwd:(NSString *)pwd{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"" forKey:@"password"];
    [params setObject:mobileNo forKey:@"mobile"];
    [params setObject:pwd forKey:@"verifycode"];
    
    NSString *signStr = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@",@"ios" ,@"9205faaa171002410180c680c004a5152bf657af" , [[AppStatus sharedInstance] appVersion] , mobileNo , @"" , pwd ];
    
    NSString *newSign = [MD5Utils md5:[NSString stringWithFormat:@"%@&5i5jApp" ,  [MD5Utils md5:signStr]]];
    [params setObject:newSign forKey:@"sign"];
    
    
    [requestFacade postForData:[NSString stringWithFormat:@"%@/login",[AppStatus sharedInstance].apiUrl]  completionBlock:^(id json, NSError *err) {
        if(json != nil){
            NSDictionary *dic = json;
            
            NSDictionary *userDict = [dic valueForKey:@"userInfo"];
            
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:userDict];
            
            AppStatus *as = [AppStatus sharedInstance];
            as.token = [dic valueForKey:@"token"];
            as.user = user;
            
            [AppStatus saveAppStatus];
            
            
            completionBlock(user, err);
            
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } commonParams:params];
}

-(void) removeSession:(void (^)(NSError *err))completionBlock accessToken:(NSString *)accessToken{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([NSStringUtils isNotBlank:accessToken]) {
        [params setObject:accessToken forKey:@"accessToken"];
    }
    [requestFacade delete:@"/mySession" completionBlock:^(id json, NSError *err) {
        AppStatus *as = [AppStatus sharedInstance];
        as.user = nil;
        [AppStatus saveAppStatus];
        completionBlock(err);
    } param:params];
}

-(void) upLoadImg:(void(^)(NSString *imgUrl, NSError *err))completionBlock tongueImage:(UIImage *)image{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:image forKey:@"image"];
    [requestFacade post:[NSString stringWithFormat:@"%@/images/upload",[AppStatus sharedInstance].apiUrl] completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSString *imgUrl = json;
            completionBlock(imgUrl,nil);
        }else{
            completionBlock(nil,err);
        }
    } params:params];
}


-(void)updateCustomerInfo:(void (^)(CustomerInfo *customerInfo ,NSError *err ))completionBlock
                   mobile:(NSString *)mobile
                 userName:(NSString *)userName
                 nickName:(NSString *)nickName
                 birthDay:(NSString *)birthDay
                      sex:(NSString *)sex
                  headPic:(NSString *)headPic
                     idNo:(NSString *)idNo
     emergencyContactName:(NSString *)emergencyContactName
    emergencyContactPhone:(NSString *)emergencyContactPhone
          contactRelation:(NSString *)contactRelation
           idCardFrontPic:(NSString *)idCardFrontPic
            idCardBackPic:(NSString *)idCardBackPic
        idCardHandheldPic:(NSString *)idCardHandheldPic
                  signFlg:(NSString *)signFlg
        authenticationFlg:(NSString *)authenticationFlg{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if([NSStringUtils isNotBlank:mobile]){
        [params setObject:mobile forKey:@"mobile"];
    }
    if([NSStringUtils isNotBlank:userName]){
        [params setObject:userName forKey:@"userName"];
    }
    if ([NSStringUtils isNotBlank:nickName]) {
        [params setObject:nickName forKey:@"nickName"];
    }
    if ([NSStringUtils isNotBlank:birthDay]) {
        [params setObject:birthDay forKey:@"birthDay"];
    }
    if([NSStringUtils isNotBlank:sex]){
        [params setObject:sex forKey:@"sex"];
    }
    if([NSStringUtils isNotBlank:headPic]){
        [params setObject:headPic forKey:@"headPic"];
    }
    if ([NSStringUtils isNotBlank:idNo]) {
        [params setObject:idNo forKey:@"idNo"];
    }
    if ([NSStringUtils isNotBlank:emergencyContactName]) {
        [params setObject:emergencyContactName forKey:@"emergencyContactName"];
    }
    if ([NSStringUtils isNotBlank:emergencyContactPhone]) {
        [params setObject:emergencyContactPhone forKey:@"emergencyContactPhone"];
    }
    if ([NSStringUtils isNotBlank:contactRelation]) {
        [params setObject:contactRelation forKey:@"contactRelation"];
    }
    if ([NSStringUtils isNotBlank:idCardFrontPic]) {
        [params setObject:idCardFrontPic forKey:@"idCardFrontPic"];
    }
    if ([NSStringUtils isNotBlank:idCardBackPic]) {
        [params setObject:idCardBackPic forKey:@"idCardBackPic"];
    }
    if ([NSStringUtils isNotBlank:idCardHandheldPic]) {
        [params setObject:idCardHandheldPic forKey:@"idCardHandheldPic"];
    }
    if ([NSStringUtils isNotBlank:signFlg]) {
        [params setObject:signFlg forKey:@"signFlg"];
    }
    if ([NSStringUtils isNotBlank:authenticationFlg]) {
        [params setObject:authenticationFlg forKey:@"authenticationFlg"];    
    }
    
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    
    [dataParams setObject:params forKey:@"data"];
    
    
    [requestFacade postForData:[NSString stringWithFormat:@"%@/my/modifyMyInfo",[AppStatus sharedInstance].apiUrl] completionBlock:^(id json, NSError *err) {
        if (err == nil) {
            NSDictionary *dic = json;
            CustomerInfo *customerInfo = [[CustomerInfo alloc] initWithDictionary:[dic valueForKey:@"data"] error:nil];
            completionBlock(customerInfo, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } commonParams:dataParams];
    
}


-(void) updateAvatar:(void (^)(NSString *imgUrl , NSError *))completionBlock avatarImage:(UIImage *)avatarImage{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:avatarImage forKey:@"request"];
    
    [requestFacade postImg:[NSString stringWithFormat:@"%@/my/changePic",[AppStatus sharedInstance].apiUrl] completionBlock:^(id json, NSError *err) {
        // 上传成功后返回一个url， 然后拿着url更新用户信息
        
        if(json != nil){
            
            completionBlock(json[@"data"] , nil);
            
        }else{
        
        }
        
    } image:avatarImage];
    
}

- (void) getCustomerInfo:(void (^)(CustomerInfo *customerInfo, NSError *err))completionBlock{

    HttpRequestFacade *request = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/my/myInfo",[AppStatus sharedInstance].apiUrl];
    NSURL *urlStr = [NSURL URLWithString:url];
    [request doGet:urlStr completionBlock:^(id json, NSError *err) {
        if (err == nil) {
            NSDictionary *dic = json;
            CustomerInfo *customerInfo = [[CustomerInfo alloc] initWithDictionary:[dic valueForKey:@"data"] error:nil];
            completionBlock(customerInfo, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        } 
    } params:nil refresh:NO useCacheIfNetworkFail:NO];
}
-(void) getUserCfContractList:(void(^)(NSArray<ContractInfoList *> *userCfContractList, NSError *err))completionBlock
                      pageNum:(NSString *)pageNum orderType:(NSString *)orderType{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:pageNum forKey:@"pageNum"];
    [dataParams setObject:orderType forKey:@"orderType"];
    NSString *url = [NSString stringWithFormat:@"%@/userContracts/userCfContractList",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade post:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"-------租客------%@",json);
            NSDictionary *dic = json;
            NSDictionary *dataDict = [dic valueForKey:@"data"];
            NSArray *userCfContractList = dataDict[@"contractInfoList"];
            NSLog(@"-------租客列表------%@",userCfContractList);
            NSArray<ContractInfoList *> *userCfContractListArray = [ContractInfoList arrayOfModelsFromDictionaries:userCfContractList];
            completionBlock(userCfContractListArray,nil);
        }else{
            completionBlock(nil,err);
        }
    } jsonString:dataParams];
}

-(void) getUserSfContractList:(void(^)(NSArray<ContractInfoList *> *userSfContractList, NSError *err))completionBlock
                      pageNum:(NSString *)pageNum orderType:(NSString *)orderType{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *dataParams = [[NSMutableDictionary alloc] init];
    [dataParams setObject:pageNum forKey:@"pageNum"];
    [dataParams setObject:orderType forKey:@"orderType"];
    NSString *url = [NSString stringWithFormat:@"%@/userContracts/userSfContractList",[AppStatus sharedInstance].apiUrl];
    
    [requestFacade post:url completionBlock:^(id json, NSError *err) {
        if(err == nil){
            NSLog(@"-------业主------%@",json);
            NSDictionary *dic = json;
            NSDictionary *dataDict = [dic valueForKey:@"data"];
            NSArray *userCfContractList = dataDict[@"list"];
            NSLog(@"-------业主列表------%@",userCfContractList);
            completionBlock(userCfContractList,nil);
        }else{
            completionBlock(nil,err);
        }
    } jsonString:dataParams];
}

@end
