//
//  User.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "UserAccount.h"

@interface User : NSObject <JSONSerializable, NSCopying, NSCoding>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userCode;
//默认为女的即0 男 1
@property int userGender;

@property (nonatomic, assign) int initPwd;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *loginMobileNo;
@property (nonatomic, copy) NSString *invitationCode;

@property (nonatomic, strong) NSDictionary *userAccount;

-(int) getUserCurrentPoint;

@end
