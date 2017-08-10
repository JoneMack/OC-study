//
//  UserStore.h
//  Golf
//
//  Created by fengcongzhi on 16/6/07.
//  Copyright (c) 2015年 fengcongzhi. All rights reserved.

#define gender_female 0
#define gender_male 1

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"


@interface User : NSObject<JSONSerializable, NSCopying, NSCoding>


@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *userId;
@property (nonatomic ,strong) NSString *userName;
@property (nonatomic ,strong) NSString *password;
@property (nonatomic ,strong) NSString *communityId;   // 小区ID
@property (nonatomic ,strong) NSString *communityName; // 小区名
@property (nonatomic ,strong) NSString *buildingNo;// 楼号
@property (nonatomic ,strong) NSString *unitNo;// 单元
@property (nonatomic ,strong) NSString *houseNo;// 房屋
@property (nonatomic ,strong) NSString *gender;// 性别
@property (nonatomic ,strong) NSString *email;// 邮箱
@property (nonatomic ,strong) NSString *age;// 年龄
@property (nonatomic ,strong) NSString *address;// 地址
@property (nonatomic ,strong) NSString *status;// 状态：1000500020002 锁定 1000500020003 注销 "1000500010002" 已注册 "1000500010001" 已认证 "1000500010003"游客 "1000500030001"待认证 "1000500030002"认证通过 "1000500030003"认证不通过
@property (nonatomic ,strong) NSString *weibo;
@property (nonatomic ,strong) NSString *houseCode;
@property (nonatomic ,strong) NSString *houseId;
@property (nonatomic ,strong) NSString *headPic;
@property (nonatomic ,strong) NSString *cityId;
@property (nonatomic ,strong) NSString *cityName;
@property (nonatomic ,strong) NSString *idNo;
@property (nonatomic ,strong) NSString *headPicMidium;
@property (nonatomic ,strong) NSString *currentCommunityId;
@property (nonatomic ,strong) NSString *headPicPrimary;
@property (nonatomic ,strong) NSString *projectName;
@property (nonatomic ,strong) NSString *birthday;
@property (nonatomic ,strong) NSString *mobile;
@property (nonatomic ,strong) NSString *token;
@property (nonatomic ,strong) NSString *verifycode;
@property (nonatomic ,strong) NSString *projectNames;
@property (nonatomic ,strong) NSString *userPwd;
@property (nonatomic ,strong) NSString *photo;
@property (nonatomic ,strong) NSString *mobileFirstLogin;
@property (nonatomic ,strong) NSString *mobileFirstDate;



@end
