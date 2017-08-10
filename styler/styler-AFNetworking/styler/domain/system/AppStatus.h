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

@interface AppStatus : NSObject<NSCoding>

@property (nonatomic, retain) NSString *currentLocation;
@property NetworkStatus networkStatus;
@property BOOL bmkWorkable;
@property (nonatomic, retain) NSString *deviceToken;
@property double lastLat;//纬度
@property double lastLng;//经度
@property (nonatomic, retain)User *user;
@property (nonatomic, retain)NSString *env;
@property (nonatomic, retain)NSString *apiUrl;
@property (nonatomic, retain)NSString *searcherUrl;
@property (nonatomic, retain)NSString *webPageUrl;
@property (nonatomic, retain)NSString *easemobApnsCertName;
@property (nonatomic, retain)NSString *easemobAppKey;
@property (nonatomic, retain)NSDate *firstGetNoticeTime;
@property (nonatomic, retain)NSDate *latestWorkPublishTime;
@property (nonatomic, retain)NSDate *latestWorkCreateTime;
@property int feedbackSessionId;
@property int launchAPPCount;//启动时尚猫APP的次数
@property BOOL hasEvaluateShishangmao;//是否给了时尚猫APP评价
@property BOOL hasInitialPromptHdcOrderPaymentExplain; // 首次进入支付进行“支付说明”提示
@property BOOL hasActive;//是否激活
@property BOOL hasUnevaluationOrder; // 是否含有未评价预约
@property BOOL hasUnpaymentHdc;
@property BOOL hasNewStylistWorks;  // 后台创建的新的作品
@property (nonatomic, strong) NSMutableArray *evaluatedOrderIds; //已经评价的预约id
@property BOOL easeMobLogined;
@property float minimumPaymentAmount;
@property (nonatomic, retain)NSString *umengAppKey;
@property AppActiveScene appBecomeActiveScene;

-(BOOL) isConnetInternet;
-(float) iosVersion;
-(NSString *) appVersion;
-(BOOL) logined;
-(NSDate *) getFirstGetNoticeTime;
-(void) addEvaluatedOrderId:(int)orderId;

+(void) saveAppStatus;

-(void) removeStylerUA;
-(void) setStylerUA;

+ (AppStatus *) sharedInstance;

+ (NSString *) savedPath;

-(NSString *) ua;

-(void) updateBadge;

-(float) getLastLat;
-(float) getLastLng;

@end
