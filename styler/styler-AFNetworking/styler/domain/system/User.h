//
//  User.h
//  styler
//
//  Created by System Administrator on 13-5-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define gender_female 0
#define gender_male 1

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"


@interface User : NSObject<JSONSerializable, NSCopying, NSCoding>

@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userCode;
//默认为女的即0 男 1
@property int gender;

@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *loginMobileNo;
@property (nonatomic, copy) NSString *easemobUserUuid;
@property (nonatomic, retain)NSMutableSet *favStylistIds;
@property (nonatomic, retain)NSMutableSet *favWorksIds;
@property (nonatomic, retain)NSMutableSet *userHdcs;
@property int evaluationCount;
@property int unevaluateCount;

-(NSString *)genderTxt;
-(void) addFavStylist:(int)stylistId;
-(void) removeFavStylist:(int)stylistId;
-(BOOL) hasAddFavStylist:(int)stylistId;
-(void) addFavWork:(int)workId;
-(void) removeFavWork:(int)workId;
-(BOOL) hasAddFavWork:(int)workId;


@end
