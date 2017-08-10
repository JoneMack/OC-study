//
//  AppStatus.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AppStatus : NSObject<NSCoding>

@property (nonatomic, strong) NSString *umengAppKey;
@property (nonatomic, strong) NSString *paymentUrl;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *wxAppId;
@property (nonatomic, strong) NSString *wxAppSecret;
@property (nonatomic, strong) NSString *shareSDKKey;
@property (nonatomic, strong) NSString *praisedExpertMessageIds;   // 赞过的文章消息
@property (nonatomic, assign) int myAccount;
@property (nonatomic, assign) int orderRecord;
@property (nonatomic, assign) int recommend;

-(BOOL) logined;

- (NSString *)userAgent;

- (void) initBaseData;

+ (AppStatus *)sharedInstance;

+ (NSString *)savedPath;

+ (void)saveAppStatus;

-(NSString *)appVersion;

-(void) addPraiseId:(NSString *)messasgeId;

@end
