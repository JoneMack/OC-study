//
//  UserStore.h
//  Golf
//
//  Created by xubojoy on 15/3/30.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStore : NSObject
+ (UserStore *) sharedStore;

//手机号直接注册新用户                           json 返回值
-(void) regUser:(void (^)(User *user, NSError *err))completionBlock
                           mobileNo:(NSString *)mobileNo;


//初次登录同时完成手机号码的验证逻辑
-(void) firstLogin:(void (^)(User *user, NSError *err))completionBlock userId:(int) userId initPwd:(NSString *)initPwd;

-(void) republishInitPwd:(void (^)(NSError *err))completionBlock userId:(NSString *) userId;
//普通登陆
-(void) login:(void (^)(User *user, NSError *err))completionBlock mobileNo:(NSString *) mobileNo pwd:(NSString *)pwd;
//注册时普通登陆
-(void) loginWithInvitationCode:(void (^)(User *user, NSError *err))completionBlock mobileNo:(NSString *) mobileNo pwd:(NSString *)pwd invitationCode:(NSString *)invitationCode;

// 查询我的信息
-(void) myUserInfo:(void (^)(User *user, NSError *err))completionBlock;


//退出登陆
-(void) removeSession:(void (^)(NSError *err))completionBlock;
//修改用户头像
-(void) updateAvatar:(void (^)(NSError *err))completionBlock userId:(NSString *)userId avatarImage:(UIImage *)avatarImage;
//修改用户信息
-(void) updateUserInfo:(void (^)(NSError *err))completionBlock userId:(NSString *)userId name:(NSString *)name gender:(int)gender;
//修改密码
-(void) updatePwd:(void(^)(NSError *err))completionBlock userId:(NSString *)userId pwd:(NSString *)pwd oldPwd:(NSString *)oldPwd;
//修改密码
-(void) updatePwd:(void(^)(NSError *err))completionBlock mobileNo:(NSString *)mobileNo pwd:(NSString *)pwd oldPwd:(NSString *)oldPwd;

//获取临时密码
-(void) getTempPwd:(void (^)(NSError *err))completionBlock mobileNo:(NSString *)mobileNo;

// 添加关注的专家
-(void) addAttentionExpert:(void (^)(NSError *err))completionBlock expertId:(int)expertId;
// 通过专家邀请码添加关注的专家
-(void) addAttentionExpertByExpertInvitationCode:(void (^)(NSError *err))completionBlock invitationCode:(NSString *)invitationCode;
// 取消关注的专家
-(void) removeAttentionExpert:(void (^)(NSError *err))completionBlock expertId:(int)expertId;


// 订阅专家
-(void) subscribeExpert:(void (^)(NSError *err))completionBlock expertId:(int)expertId subscribePriceType:(NSString *)subscribePriceType;

// 查询订阅记录
-(void) findSubscribeExpertLogs:(void (^)(Page *page , NSError *err))completionBlock
                         userId:(int)userId
                         pageNo:(int)pageNo
                       pageSize:(int)pageSize;
// 查询充值记录
-(void) findUserPointLogs:(void (^)(Page *page , NSError *err))completionBlock
                         userId:(NSString *)userId
                         pageNo:(int)pageNo
                       pageSize:(int)pageSize;

// 更新接收push的设置
-(void) updateReceiveStatus:(void (^)(NSError *))completionBlock
                   expertId:(int)expertId
                     status:(NSString *)status;

@end
