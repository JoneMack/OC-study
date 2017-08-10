//
//  UserStore.m
//  styler
//
//  Created by System Administrator on 13-5-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "UserStore.h"
#import "User.h"
#import "Stylist.h"
#import "StylistWork.h"
#import "EvaluationStore.h"

@implementation UserStore

-(void) createNewUserWithCompletion:(void (^)(User *, NSError *))completionBlock name:(NSString *)name gender:(int)gender mobileNo:(NSString *)mobileNo{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
    [params setObject:mobileNo forKey:@"mobileNo"];
    [params setObject:[NSString stringWithFormat:@"%d", gender] forKey:@"gender"];
    
    [requestFacade post:@"/customers" completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSLog(@"create user result:%@", json);
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            completionBlock(user, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}

-(void) createNewUserWithCompletion:(void (^)(User *user, NSError *err))completionBlock
                               name:(NSString *)name
                             gender:(int)gender
                           mobileNo:(NSString *)mobileNo
                        avatarImage:(UIImage *)image
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
    [params setObject:mobileNo forKey:@"mobileNo"];
    [params setObject:[NSString stringWithFormat:@"%d", gender] forKey:@"gender"];
    if (image) {
        [params setObject:image forKey:@"avatar"];
    }
    [requestFacade post:@"/customers" completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSLog(@"create user result:%@", json);
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            
            [[AppStatus sharedInstance] setUser:user];
            completionBlock(user, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}


+(void) getMyUserInfo:(void (^)(User *user, NSError *err))completionBlock{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:@"/myUserInfo" completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            //NSLog(@"get user result:%@", json);

            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            
            [[AppStatus sharedInstance] setUser:user];
            completionBlock(user, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    }refresh:YES useCacheIfNetworkFail:NO];
}

-(void) firstLogin:(void (^)(User *user, NSError *err))completionBlock userId:(int) userId initPwd:(NSString *)initPwd{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:initPwd forKey:@"initPwd"];
    
    [requestFacade post:[NSString stringWithFormat: @"/users/%d/firstLogin", userId] completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            NSLog(@"create user result:%@", json);
            NSDictionary *dic = [json objectFromJSONString];
            User *user = [[User alloc] init];
            [user readFromJSONDictionary:dic];
            completionBlock(user, err);
        }else if(err != nil){
            completionBlock(nil, err);
        }
    } params:params];
}

-(void) republishInitPwd:(void (^)(NSError *err))completionBlock userId:(int) userId{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    [requestFacade post:[NSString stringWithFormat: @"/users/%d/republishInitPwd", userId] completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:nil];
}

-(void) removeSession:(void (^)(NSError *err))completionBlock{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    [requestFacade delete:@"/mySession" completionBlock:^(NSString *json, NSError *err) {
        AppStatus *as = [AppStatus sharedInstance];
        as.user = nil;
        [AppStatus saveAppStatus];
//        [EvaluationStore checkEvaluationStatus:^(NSError *error) {
//        }];
        completionBlock(err);
    }];
}

-(void) login:(void (^)(User *user, NSError *err))completionBlock mobileNo:(NSString *) mobileNo pwd:(NSString *)pwd{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:pwd forKey:@"pwd"];
    [params setObject:mobileNo forKey:@"mobileNo"];
    [requestFacade post:@"/userSessions" completionBlock:^(NSString *json, NSError *err) {
        if(json != nil){
            //NSLog(@"user login result:%@", json);
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
-(void)updateUserInfo:(void (^)(NSError *err))completionBlock
{
    if (![[AppStatus sharedInstance] logined]) {
        return ;
    }
    HttpRequestFacade * requestFacade = [HttpRequestFacade sharedInstance];
    NSString * url = @"/myUserInfo";
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err)
     {
         if(json != nil){
             //NSLog(@"user info:%@", json);
             NSDictionary *dic = [json objectFromJSONString];
             User *user = [[User alloc] init];
             [user readFromJSONDictionary:dic];
             
             AppStatus *as = [AppStatus sharedInstance];
             as.user = user;
             [AppStatus saveAppStatus];
             completionBlock(nil);
         }else if(err != nil){
             completionBlock( err);
         }
     }refresh:YES useCacheIfNetworkFail:YES];
}

-(void) addFavStylist:(void (^)(NSError *err))completionBlock userId:(int)userId stylistId:(int)stylistId{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(stylistId) forKey:@"stylistId"];
    
    [requestFacade post:[NSString stringWithFormat:@"/users/%d/stylistCollections", userId] completionBlock:^(NSString *json, NSError *err) {
        [[AppStatus sharedInstance].user addFavStylist:stylistId];
        [AppStatus saveAppStatus];
        completionBlock(err);
    } params:params];
}

-(void) removeFavstylist:(void (^)(NSError *))completionBlock userId:(int)userId stylistId:(int)stylistId{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade delete:[NSString stringWithFormat:@"/users/%d/stylistCollections/%d", userId, stylistId]
          completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            [[AppStatus sharedInstance].user removeFavStylist:stylistId];
            [AppStatus saveAppStatus];
        }
        completionBlock(err);
    }];
}

-(void) favStylists:(void (^)(NSArray *stylists, NSError *err))completionBlock userId:(NSString *)idStr refresh:(BOOL)refresh{
    NSString *urlStr = [NSString stringWithFormat:@"/users/%@/stylistCollections/page", idStr];
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSArray *dictArray = [[json objectFromJSONString] objectForKey:@"items"];
            NSArray *stylists = [Stylist arrayOfModelsFromDictionaries:dictArray];
            completionBlock(stylists, nil);
        }
    } refresh:refresh useCacheIfNetworkFail:NO];
}

-(void) addFavWork:(void (^)(NSError *err))completionBlock userId:(NSString *)userId workId:(int)workId{
        HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@(workId) forKey:@"workId"];
        
        [requestFacade post:[NSString stringWithFormat:@"/users/%@/favWorks", userId] completionBlock:^(NSString *json, NSError *err) {
            //NSLog(@"收藏成功");
            if (err == nil) {
                [[AppStatus sharedInstance].user addFavWork:workId];
                [AppStatus saveAppStatus];
            }
            completionBlock(err);
        } params:params];
}

-(void) removeFavWork:(void (^)(NSError *))completionBlock userId:(NSString *)userId workId:(int)workId{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade delete:[NSString stringWithFormat:@"/users/%@/favWorks/%d", userId, workId] completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            [[AppStatus sharedInstance].user removeFavWork:workId];
            [AppStatus saveAppStatus];
        }
        completionBlock(err);
    }];
}

-(void) favWorks:(void (^)(NSArray *works, NSError *err))completionBlock userId:(NSString *)userId refresh:(BOOL)refresh{
    NSString *urlStr = [NSString stringWithFormat:@"/users/%@/favWorks?pageSize=100", userId];
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        NSLog(@"get fav works:%@", json);
        NSArray *worksJsonArray = [json objectFromJSONString];
        if(worksJsonArray == nil || (NSNull *)worksJsonArray == [NSNull null] || [worksJsonArray count] == 0){
            completionBlock(nil, nil);
            return ;
        }
        
        NSArray *worksArray = [StylistWork arrayOfModelsFromDictionaries:worksJsonArray];
        completionBlock(worksArray, nil);
        
    } refresh:refresh useCacheIfNetworkFail:NO];
}

-(void) requestTempPwd:(void (^)(NSError *err))completionBlock mobileNo:(NSString *)mobileNo{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:mobileNo forKey:@"mobileNo"];
    
    [requestFacade post:@"/tempPwds" completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:params];
}

-(void) updateName:(void (^)(NSError *err))completionBlock userId:(NSString *)userId name:(NSString *)name{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
    
    [requestFacade post:[NSString stringWithFormat:@"/users/%@/name", userId] completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            AppStatus *as = [AppStatus sharedInstance];
            as.user.name = name;
            [AppStatus saveAppStatus];
        }
        completionBlock(err);
    } params:params];
}

-(void)updateGender:(void (^)(NSError *))completionBlock userId:(NSString *)userId gender:(int)gender
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%d",gender] forKey:@"gender"];
    
    [requestFacade post:[NSString stringWithFormat:@"/users/%@/gender", userId] completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            AppStatus *as = [AppStatus sharedInstance];
            as.user.gender = gender;
            [AppStatus saveAppStatus];
        }else{
            NSLog(@"set sex failed:%@", json);
        }
        completionBlock(err);
    } params:params];
}

-(void) updatePwd:(void(^)(NSError *err))completionBlock userId:(NSString *)userId pwd:(NSString *)pwd oldPwd:(NSString *)oldPwd{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:pwd forKey:@"pwd"];
    [params setObject:oldPwd forKey:@"oldPwd"];
    
    [requestFacade post:[NSString stringWithFormat:@"/users/%@/pwd", userId] completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            NSDictionary *dic = [json objectFromJSONString];
            AppStatus *as = [AppStatus sharedInstance];
            as.user.accessToken = [dic objectForKey:@"accessToken"];
            [AppStatus saveAppStatus];
        }
        completionBlock(err);
    } params:params];
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
            NSLog(@"更新成功");
        }
        completionBlock(err);
    } params:params];
}

+(NSString *)getUriForUserFavStylists:(NSString *)userId
{
    NSString *urlStr = [NSString stringWithFormat:@"/users/%@/stylistCollections/page?pageSize=%d", userId,stylist_list_page_size];
    return urlStr;
}

//+(NSString *)getUriForUserFavWorks:(NSString *)userId
//{
//    NSString *urlStr = [NSString stringWithFormat:@"/users/%@/favWorks?pageSize=%d", userId,work_list_page_size];
//    return urlStr;
//}
//
//+(NSString *)getUriForUserFavWorks:(NSString *)userId pageNo:(int)pageNo
//{
//    NSString *urlStr = [NSString stringWithFormat:@"/users/%@/favWorks?pageSize=%d&pageNo=%d", userId, work_list_page_size, pageNo];
//    return urlStr;
//}


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

@end
