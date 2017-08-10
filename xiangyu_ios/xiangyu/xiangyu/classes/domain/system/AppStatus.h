//
//  AppStatus.h
//  styler
//
//  Created by System Administrator on 13-5-13.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "User.h"
#import <Foundation/Foundation.h>
#import "AppActiveScene.h"
#import "Reachability.h"
@interface AppStatus : NSObject<NSCoding>

@property (nonatomic, strong) NSString *currentLocation;
@property NetworkStatus networkStatus;
@property (nonatomic, strong) NSString *deviceToken;
@property double lastLat;//纬度
@property double lastLng;//经度
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, retain) NSString *env;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *appVersion;


@property (nonatomic ,assign) BOOL noRemind;
@property (nonatomic ,assign) BOOL isComplete;

@property (nonatomic, strong) NSString *umengAppKey;
@property (nonatomic, strong) NSString *paymentUrl;
@property (nonatomic, strong) NSString *umengPushAppKey;

@property (nonatomic, strong) NSDate *saveDate;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSMutableArray *searchConditions;


-(BOOL) isConnetInternet;
-(float) iosVersion;
-(NSString *) appVersion;
-(BOOL) logined;

+(void) saveAppStatus;


+ (AppStatus *) sharedInstance;

+ (NSString *) savedPath;


-(void) initBaseData;

-(float) getLastLat;
-(float) getLastLng;

-(void) addSearchCondition:(NSString *)condition;

-(void) clearSearchConditions;


@end
