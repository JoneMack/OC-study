//
//  GlobalConst.h
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserContext.h"
#import "NSDate+Format.h"

typedef NS_ENUM(NSInteger, LoginStatus) {
    
    LoginStatus_OffLine,
    LoginStatus_OnLine,
    LoginStatus_OnLine_OnlyHuanXin
};

@interface GlobalConst : NSObject

@property (nonatomic, assign) LoginStatus loginStatus;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) UserContext *loginInfo;
@property (nonatomic, copy) NSString *timeStamp;

+ (instancetype)shareInstance;

+ (void)save:(id)object withKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

@end
