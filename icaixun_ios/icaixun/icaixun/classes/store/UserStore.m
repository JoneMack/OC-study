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
#import "Expert.h"
#import "SubscribeExpertLog.h"
#import "pointOrder.h"
#import "ExpertStore.h"

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

-(void)regUser:(void (^)(User *, NSError *))completionBlock mobileNo:(NSString *)mobileNo{

    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:mobileNo forKey:@"mobileNo"];
    
    [requestFacade post:@"/customers" completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSLog(@"create user result:%@", json);
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            [[AppStatus sharedInstance] setUser:user];
            completionBlock(user, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}

-(void) firstLogin:(void (^)(User *user, NSError *err))completionBlock userId:(int) userId initPwd:(NSString *)initPwd{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:initPwd forKey:@"initPwd"];
    [requestFacade post:[NSString stringWithFormat: @"%@/users/%d/firstLogin",[AppStatus sharedInstance].apiUrl, userId] completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
//            NSLog(@"create user result:%@", json);
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            completionBlock(user, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}

-(void) republishInitPwd:(void (^)(NSError *err))completionBlock userId:(NSString *) userId{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade post:[NSString stringWithFormat: @"%@/users/%@/republishInitPwd", [AppStatus sharedInstance].apiUrl,userId] completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:nil];
}

-(void) login:(void (^)(User *user, NSError *err))completionBlock mobileNo:(NSString *) mobileNo pwd:(NSString *)pwd{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:pwd forKey:@"pwd"];
    [params setObject:mobileNo forKey:@"mobileNo"];
    [SVProgressHUD showWithStatus:@"正在登录..."];
    
    [requestFacade post:@"/userSessions"  completionBlock:^(NSString *json, NSError *err) {
        [SVProgressHUD dismiss];
        if(json != nil){
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            
            AppStatus *as = [AppStatus sharedInstance];
            as.user = user;
            [AppStatus saveAppStatus];
            completionBlock(user, nil);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}

#pragma mark 注册时登录
-(void) loginWithInvitationCode:(void (^)(User *, NSError *))completionBlock mobileNo:(NSString *)mobileNo pwd:(NSString *)pwd invitationCode:(NSString *)invitationCode
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:pwd forKey:@"pwd"];
    [params setObject:mobileNo forKey:@"mobileNo"];
    [params setObject:invitationCode forKey:@"invitationCode"];
    [requestFacade post:@"/userSessions"  completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            
            AppStatus *as = [AppStatus sharedInstance];
            as.user = user;
            [AppStatus saveAppStatus];
            
            completionBlock(user, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];

}

// 查询我的信息
-(void) myUserInfo:(void (^)(User *user, NSError *err))completionBlock
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:@"/myUserInfo" completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            
            AppStatus *as = [AppStatus sharedInstance];
            as.user = user;
            [AppStatus saveAppStatus];
            
            completionBlock(user, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}


-(void) removeSession:(void (^)(NSError *err))completionBlock{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade delete:@"/mySession" completionBlock:^(NSString *json, NSError *err) {
        AppStatus *as = [AppStatus sharedInstance];
        as.user = nil;
        [AppStatus saveAppStatus];
        completionBlock(err);
    }];
}

-(void) updateAvatar:(void (^)(NSError *))completionBlock userId:(NSString *)userId avatarImage:(UIImage *)avatarImage{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:avatarImage forKey:@"avatar"];
    [requestFacade post:[NSString stringWithFormat:@"/users/%@/avatar", userId] completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            
            AppStatus *as = [AppStatus sharedInstance];
            as.user.avatarUrl = user.avatarUrl;
            [AppStatus saveAppStatus];
            completionBlock(nil);
        }
        completionBlock(err);
    } params:params];
}


-(void)updateUserInfo:(void (^)(NSError *))completionBlock
               userId:(NSString *)userId
                 name:(NSString *)name
               gender:(int)gender{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
    [params setObject:[NSString stringWithFormat:@"%d",gender] forKey:@"gender"];
    [requestFacade put:[NSString stringWithFormat:@"/users/%@/info", userId] completionBlock:^(NSString *json, NSError *err) {

        if(err == nil){
            NSLog(@"更新成功");
            AppStatus *as = [AppStatus sharedInstance];
            as.user.name = name;
            as.user.userGender = gender;
            [AppStatus saveAppStatus];
        }else{
            NSLog(@"更新失败");
        }
        completionBlock(err);
    } params:params];
}

/**
 * 根据用户id修改密码
 */
-(void) updatePwd:(void(^)(NSError *err))completionBlock userId:(NSString *)userId pwd:(NSString *)pwd oldPwd:(NSString *)oldPwd{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:pwd forKey:@"pwd"];
    [params setObject:oldPwd forKey:@"oldPwd"];
    [requestFacade put:[NSString stringWithFormat:@"/users/%@/info", userId] completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            NSDictionary *dic = [json objectFromJSONString];
            AppStatus *as = [AppStatus sharedInstance];
            as.user.accessToken = [dic objectForKey:@"accessToken"];
            [AppStatus saveAppStatus];
        }
        completionBlock(err);
    } params:params];
}

/*
 * 根据手机号修改密码
 */
-(void) updatePwd:(void(^)(NSError *err))completionBlock mobileNo:(NSString *)mobileNo pwd:(NSString *)pwd oldPwd:(NSString *)oldPwd
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:pwd forKey:@"pwd"];
    [params setObject:oldPwd forKey:@"oldPwd"];
    
    [requestFacade put:[NSString stringWithFormat:@"/users/%@/pwd" , mobileNo] completionBlock:^(NSString *json, NSError *err) {
        
        if(err == nil){
            NSDictionary *dic = [json objectFromJSONString];
            AppStatus *as = [AppStatus sharedInstance];
            as.user.accessToken = [dic objectForKey:@"accessToken"];
            [AppStatus saveAppStatus];
        }
        completionBlock(err);
    } params:params];
}



/**
 * 注册时 获取验证码
 */
-(void) getTempPwd:(void (^)(NSError *))completionBlock mobileNo:(NSString *)mobileNo
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];

    NSString *url = @"/tempPwds";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:mobileNo forKey:@"mobileNo"];
    [requestFacade post:url completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:params];
}

/**
 *  添加关注用户
 */
-(void) addAttentionExpert:(void (^)(NSError *))completionBlock expertId:(int)expertId
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userExpertRelations/expertId,%d/follow" , expertId];
    [requestFacade post:url completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } jsonString:@""];
}


// 通过专家邀请码添加关注的专家
-(void) addAttentionExpertByExpertInvitationCode:(void (^)(NSError *err))completionBlock invitationCode:(NSString *)invitationCode
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:invitationCode forKey:@"invitationCode"];
    [requestFacade post:@"/userExpertRelations/follow" completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:params];
}

/**
 *  删除关注用户
 */
-(void) removeAttentionExpert:(void (^)(NSError *))completionBlock expertId:(int)expertId
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userExpertRelations/expertId,%d" , expertId];
    
    [requestFacade delete:url completionBlock:^(NSString *json, NSError *err) {
        
        if (err == nil) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");
        }
        
        NSLog(@"error:%@" , err);
        completionBlock(err);
    }];
}


// 订阅专家
-(void) subscribeExpert:(void (^)(NSError *err))completionBlock expertId:(int)expertId subscribePriceType:(NSString *)subscribePriceType
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userExpertRelations/expertId,%d/subscribe" , expertId];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:subscribePriceType forKey:@"subscribePriceType"];
    [requestFacade post:url completionBlock:^(NSString *json, NSError *err) {
        
        completionBlock(err);
        
    } params:params];
}


// 查询订阅记录
-(void) findSubscribeExpertLogs:(void (^)(Page *page , NSError *err))completionBlock
                         userId:(int)userId
                         pageNo:(int)pageNo
                       pageSize:(int)pageSize
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userSubscribeExpertItem?userId=%d&pageNo=%d&pageSize=%d" , userId , pageNo , pageSize];
    
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *jsonDictArray = [jsonDict objectForKey:@"items"];
            NSArray *logs = [SubscribeExpertLog arrayOfModelsFromDictionaries:jsonDictArray];
            page.items = logs;
            
            NSMutableArray *expertIds = [NSMutableArray new];
            for (SubscribeExpertLog *log in logs) {
                [expertIds addObject:[NSString stringWithFormat:@"%d" ,log.expertId]];
            }
            
            [self fillExperts:^(NSArray *experts, NSError *error) {
                if (error == nil) {
                    for (Expert *expert in experts) {
                        for (SubscribeExpertLog *log in logs) {
                            log.expertName = expert.name;
                        }
                    }
                    completionBlock(page, nil);
                }else{
                    completionBlock(nil , error);
                }
            } expertIds:[expertIds copy]];
            
        }else {
            completionBlock(nil , err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}


// 查询充值记录
-(void) findUserPointLogs:(void (^)(Page *page , NSError *err))completionBlock
                   userId:(NSString *)userId
                   pageNo:(int)pageNo
                 pageSize:(int)pageSize
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userPointItem?userId=%@&pageNo=%d&pageSize=%d" , userId , pageNo , pageSize];
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>url:%@" , url);
    
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        
        NSLog(@"------------------------------------------------------------------------------------");
        NSLog(@"%@" , json);
        NSLog(@"------------------------------------------------------------------------------------");
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *jsonDictArray = [jsonDict objectForKey:@"items"];
            NSArray *logs = [PointOrder arrayOfModelsFromDictionaries:jsonDictArray];
            page.items = logs;
            completionBlock(page, nil);
        }else {
            completionBlock(nil , err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}



/**
 * 渲染发型师
 */
-(void) fillExperts:(void (^)(NSArray *experts , NSError *error))completionBlock expertIds:(NSArray *)expertIds
{
    ExpertQuery *query = [[ExpertQuery alloc] initWithExpertIds:expertIds];
    [ExpertStore getExperts:^(NSArray *experts, NSError *err) {
        completionBlock(experts , err);
    } query:query];
}

/*
 *更新接收push的设置
 */
-(void) updateReceiveStatus:(void (^)(NSError *))completionBlock
                   expertId:(int)expertId
                     status:(NSString *)status
{
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/userExpertRelations/expertId,%d/massageReceiveStatus" , expertId];
    
    NSDictionary *params = @{@"massageReceiveStatus":status} ;
    
    [requestFacade put:url completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:params];
}



@end
