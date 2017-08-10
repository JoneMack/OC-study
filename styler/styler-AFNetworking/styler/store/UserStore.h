//
//  UserStore.h
//  styler
//
//  Created by System Administrator on 13-5-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
@class User;

@interface UserStore : NSObject

+ (UserStore *) sharedStore;

//手机号直接注册新用户                           json 返回值
-(void) createNewUserWithCompletion:(void (^)(User *user, NSError *err))completionBlock
                               name:(NSString *)name
                             gender:(int)gender
                           mobileNo:(NSString *)mobileNo;
//第三方平台绑定之后注册新用户
-(void) createNewUserWithCompletion:(void (^)(User *user, NSError *err))completionBlock
                               name:(NSString *)name
                             gender:(int)gender
                           mobileNo:(NSString *)mobileNo
                        avatarImage:(UIImage *)image;


+(void) getMyUserInfo:(void (^)(User *user, NSError *err))completionBlock;

//初次登录同时完成手机号码的验证逻辑
-(void) firstLogin:(void (^)(User *user, NSError *err))completionBlock userId:(int) userId initPwd:(NSString *)initPwd;

-(void) republishInitPwd:(void (^)(NSError *err))completionBlock userId:(int) userId;

-(void) removeSession:(void (^)(NSError *err))completionBlock;

-(void) login:(void (^)(User *user, NSError *err))completionBlock mobileNo:(NSString *) mobileNo pwd:(NSString *)pwd;

-(void)updateUserInfo:(void (^)( NSError *err))completionBlock;

-(void) addFavStylist:(void (^)(NSError *err))completionBlock userId:(int)userId stylistId:(int)stylistId;

-(void) removeFavstylist:(void (^)(NSError *err))completionBlock userId:(int)userId stylistId:(int)stylistId;

-(void) favStylists:(void (^)(NSArray *stylists, NSError *err))completionBlock userId:(NSString *)idStr refresh:(BOOL)refresh;

-(void) addFavWork:(void (^)(NSError *err))completionBlock userId:(NSString *)userId workId:(int)workId;
-(void) removeFavWork:(void (^)(NSError *err))completionBlock userId:(NSString *)userId workId:(int)workId;
-(void) favWorks:(void (^)(NSArray *works, NSError *err))completionBlock userId:(NSString *)userId refresh:(BOOL)refresh;

-(void) updateName:(void (^)(NSError *err))completionBlock userId:(NSString *)userId name:(NSString *)name;

-(void) updatePwd:(void(^)(NSError *err))completionBlock userId:(NSString *)userId pwd:(NSString *)pwd oldPwd:(NSString *)oldPwd;

-(void)updateGender:(void (^)(NSError *err))completionBlock userId:(NSString *)userId
             gender:(int)gender;

-(void) requestTempPwd:(void (^)(NSError *err))completionBlock mobileNo:(NSString *)mobileNo;
-(void) updateAvatar:(void (^)(NSError *err))completionBlock userId:(NSString *)userId avatarImage:(UIImage *)avatarImage;

+(NSString *)getUriForUserFavStylists:(NSString *)userId;
//+(NSString *)getUriForUserFavWorks:(NSString *)userId;
//+(NSString *)getUriForUserFavWorks:(NSString *)userId pageNo:(int)pageNo;

@end
