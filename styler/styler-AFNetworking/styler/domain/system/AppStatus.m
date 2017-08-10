//
//  AppStatus.m
//  styler
//
//  Created by System Administrator on 13-5-13.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "AppStatus.h"
#import "StylistWork.h"
#import "PushProcessor.h"
#import "EaseMobProcessor.h"

@implementation AppStatus

-(NSString *) ua{
    NSMutableString *ua = [[NSMutableString alloc] init];
    [ua appendFormat:@"ios,%@", [[UIDevice currentDevice] systemVersion]];
    [ua appendFormat:@";%@,%d*%d",[[UIDevice currentDevice] model],  (int)[[UIScreen mainScreen] bounds].size.width,  (int)[[UIScreen mainScreen]bounds].size.height];
    
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    [ua appendFormat:@";%@,%@", [dicInfo objectForKey:@"CFBundleName"], [dicInfo objectForKey:@"CFBundleShortVersionString"]];
    [ua appendFormat:@";%@", [OpenUDID value]];
    [ua appendFormat:@";%@", self.deviceToken==nil?@"unknow":self.deviceToken];
    //[ua appendFormat:@";%f,%f", self.lastLng, self.lastLat];
    return ua;
}

//是否登录
-(BOOL) logined{
    if(self.user != nil && self.user.accessToken != nil && (NSNull *)self.user.accessToken != [NSNull null])
        return YES;
    return NO;
}

-(BOOL)isConnetInternet{
    if (self.networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

-(float)iosVersion{
   return [[[UIDevice currentDevice] systemVersion] floatValue];
}

-(NSString *)appVersion{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    return [dicInfo objectForKey:@"CFBundleShortVersionString"];
}

-(NSDate *) getFirstGetNoticeTime{
    if(self.firstGetNoticeTime == nil){
        self.firstGetNoticeTime = [NSDate date];
        [AppStatus saveAppStatus];
    }
    return self.firstGetNoticeTime;
}

-(void) addEvaluatedOrderId:(int)orderId{
    [self.evaluatedOrderIds addObject:@(orderId)];
}

-(void) updateBadge{
    int totalBadge = [[PushProcessor sharedInstance] unreadPush].count + [EaseMobProcessor unreadSupportMessageCount] + self.hasUnpaymentHdc?1:0 + self.hasNewStylistWorks?1:0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalBadge];
}

-(float) getLastLat{
    if (_lastLat == 0) {
        return 39.974101;
    }
    return _lastLat;
}
-(float) getLastLng{
    if (_lastLng == 0) {
        return 116.348413;
    }
    return _lastLng;
}


-(void) removeStylerUA{
    NSDictionary *registeredDefaults = [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSRegistrationDomain];
    if ([registeredDefaults objectForKey:@"UserAgent"] != nil) {
        //NSLog(@">>>>>>> before remove styler ua:%@", [registeredDefaults objectForKey:@"UserAgent"]);
        NSMutableDictionary *mutableCopy = [NSMutableDictionary dictionaryWithDictionary:registeredDefaults];
        [mutableCopy removeObjectForKey:@"UserAgent"];
        [[NSUserDefaults standardUserDefaults] setVolatileDomain:[mutableCopy copy] forName:NSRegistrationDomain];
    }
}

-(void) setStylerUA{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self ua], @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:self.lastLat forKey:@"lastLat"];
    [aCoder encodeDouble:self.lastLng forKey:@"lastLng"];
    [aCoder encodeObject:self.currentLocation forKey:@"currentLocation"];
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.firstGetNoticeTime forKey:@"firstGetNoticeTime"];
    [aCoder encodeObject:self.latestWorkPublishTime forKey:@"latestWorkPublishTime"];
    [aCoder encodeObject:self.latestWorkCreateTime forKey:@"latestWorkCreateTime"];
    [aCoder encodeInt:self.feedbackSessionId forKey:@"feedbackSessionId"];
    [aCoder encodeBool:self.hasEvaluateShishangmao forKey:@"hasEvaluateShishangmao"];
    [aCoder encodeBool:self.hasInitialPromptHdcOrderPaymentExplain forKey:@"hasInitialPromptHdcOrderPaymentExplain"];
    [aCoder encodeInt:self.launchAPPCount forKey:@"launchAPPCount"];
    [aCoder encodeBool:self.hasActive forKey:@"hasActive"];
    [aCoder encodeBool:self.hasUnevaluationOrder forKey:@"hasUnevaluationOrder"];
    [aCoder encodeBool:self.hasUnpaymentHdc forKey:@"hasUnpaymentHdc"];
    [aCoder encodeBool:self.hasNewStylistWorks forKey:@"hasNewStylistWorks"];
    [aCoder encodeObject:self.evaluatedOrderIds forKey:@"evaluatedOrderIds"];
    [aCoder encodeInt:self.appBecomeActiveScene forKey:@"appBecomeActiveScene"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.lastLat = [aDecoder decodeDoubleForKey:@"lastLat"];
        self.lastLng = [aDecoder decodeDoubleForKey:@"lastLng"];
        self.currentLocation = [aDecoder decodeObjectForKey:@"currentLocation"];
        self.deviceToken = [aDecoder decodeObjectForKey:@"deviceToken"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.firstGetNoticeTime = [aDecoder decodeObjectForKey:@"firstGetNoticeTime"];
        self.latestWorkPublishTime = [aDecoder decodeObjectForKey:@"latestWorkPublishTime"];
        self.latestWorkCreateTime = [aDecoder decodeObjectForKey:@"latestWorkCreateTime"];
        self.feedbackSessionId = [aDecoder decodeIntForKey:@"feedbackSessionId"];
        self.hasEvaluateShishangmao = [aDecoder decodeBoolForKey:@"hasEvaluateShishangmao"];
        self.hasInitialPromptHdcOrderPaymentExplain = [aDecoder decodeBoolForKey:@"hasInitialPromptHdcOrderPaymentExplain"];
        self.launchAPPCount = [aDecoder decodeIntForKey:@"launchAPPCount"];
        self.hasActive = [aDecoder decodeBoolForKey:@"hasActive"];
        self.hasUnevaluationOrder = [aDecoder decodeBoolForKey:@"hasUnevaluationOrder"];
        self.hasUnpaymentHdc = [aDecoder decodeBoolForKey:@"hasUnpaymentHdc"];
        self.hasNewStylistWorks = [aDecoder decodeBoolForKey:@"hasNewStylistWorks"];
        self.evaluatedOrderIds = [aDecoder decodeObjectForKey:@"evaluatedOrderIds"];
        self.appBecomeActiveScene = [aDecoder decodeIntForKey:@"appBecomeActiveScene"];
        if (self.evaluatedOrderIds == nil) {
            self.evaluatedOrderIds = [NSMutableArray new];
        }
    }
    
    return self;
}

+(void) saveAppStatus{
    //NSLog(@"AppStatus to be saving:%@", [AppStatus sharedInstance].description);
    [NSKeyedArchiver archiveRootObject:[AppStatus sharedInstance] toFile:[AppStatus savedPath]];
}

+(NSString *) savedPath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"appStatus.archive"];
    return documentDirectory;
}

+(AppStatus *)sharedInstance{
    static AppStatus *sharedInstance = nil;
    if(sharedInstance == nil){
        NSString *path = [AppStatus savedPath];
        sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(sharedInstance == nil){
            sharedInstance = [[AppStatus alloc] init];
            sharedInstance.feedbackSessionId = -1;
            sharedInstance.hasEvaluateShishangmao = NO;
            sharedInstance.hasInitialPromptHdcOrderPaymentExplain = NO;
            sharedInstance.hasUnevaluationOrder = NO;
            sharedInstance.hasUnpaymentHdc = NO;
            sharedInstance.evaluatedOrderIds = [NSMutableArray new];
            sharedInstance.appBecomeActiveScene = fromAppLaunch;
        }
        
        NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
        sharedInstance.apiUrl = [dicInfo objectForKey:@"apiUrl"];
        sharedInstance.searcherUrl = [dicInfo objectForKey:@"searcherUrl"];
        sharedInstance.webPageUrl = [dicInfo objectForKey:@"webPageUrl"];
        sharedInstance.env = [dicInfo objectForKey:@"env"];
        sharedInstance.easemobApnsCertName = [dicInfo objectForKey:@"easemobApnsCertName"];
        sharedInstance.easemobAppKey = [dicInfo objectForKey:@"easemobAppKey"];
        sharedInstance.minimumPaymentAmount = [[dicInfo objectForKey:@"minimumPaymentAmount"] floatValue];
        sharedInstance.umengAppKey = [dicInfo objectForKey:@"umengAppKey"];
        sharedInstance.easeMobLogined = NO;
    }
    
    return sharedInstance;
}

-(NSString *) description{
    return [NSString stringWithFormat:@"deviceToken:%@, user:%@, lastLat:%f, lastLng:%f, latestWorkPublishTime:%@  hasEvaluateShishangmao %d", self.deviceToken, self.user
            .description, self.lastLat, self.lastLng, self.latestWorkPublishTime,self.hasEvaluateShishangmao];
}

@end
