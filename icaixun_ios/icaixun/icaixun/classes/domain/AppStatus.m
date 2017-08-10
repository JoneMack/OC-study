//
//  AppStatus.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "AppStatus.h"

@implementation AppStatus

+ (AppStatus *)sharedInstance
{
    static AppStatus *sharedInstance = nil;
    if(sharedInstance == nil){
        NSString *path = [AppStatus savedPath];
        sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(sharedInstance == nil){
            sharedInstance = [[AppStatus alloc] init];
        }
        NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
        sharedInstance.apiUrl = [dicInfo objectForKey:@"apiUrl"];
        sharedInstance.umengAppKey = [dicInfo objectForKey:@"umengAppKey"];
        sharedInstance.wxAppId = [dicInfo objectForKey:@"wxAppId"];
        sharedInstance.wxAppSecret = [dicInfo objectForKey:@"wxAppSecret"];
        sharedInstance.paymentUrl = [dicInfo objectForKey:@"paymentUrl"];
        sharedInstance.shareSDKKey = [dicInfo objectForKey:@"shareSDKKey"];
    }
    return sharedInstance;
}

/**
 * 判断用户是否登录
 */
-(BOOL) logined
{
    if(self.user != nil && self.user.accessToken != nil && (NSNull *)self.user.accessToken != [NSNull null])
        return YES;
    return NO;
}

/**
 * 获取 userAgent
 */
- (NSString *)userAgent
{
    NSMutableString *ua = [[NSMutableString alloc] init];
    [ua appendFormat:@"icaixun_ios,%@", [[UIDevice currentDevice] systemVersion]];
    [ua appendFormat:@";%@,%d*%d",[[UIDevice currentDevice] model],  (int)[[UIScreen mainScreen] bounds].size.width,  (int)[[UIScreen mainScreen]bounds].size.height];
    
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    [ua appendFormat:@";%@,%@", @"icaixun_ios",  [dicInfo objectForKey:@"CFBundleShortVersionString"]];
    [ua appendFormat:@";%@", [OpenUDID value]];
    [ua appendFormat:@";%@", self.deviceToken==nil?@"unknow":self.deviceToken];
    
    return ua;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.praisedExpertMessageIds forKey:@"praisedExpertMessageIds"];
    [aCoder encodeInt:self.myAccount forKey:@"myAccount"];
    [aCoder encodeInt:self.orderRecord forKey:@"orderRecord"];
    [aCoder encodeInt:self.recommend forKey:@"recommend"];
    
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.deviceToken = [aDecoder decodeObjectForKey:@"deviceToken"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.praisedExpertMessageIds = [aDecoder decodeObjectForKey:@"praisedExpertMessageIds"];
        self.myAccount = [aDecoder decodeIntForKey:@"myAccount"];
        self.orderRecord = [aDecoder decodeIntForKey:@"orderRecord"];
        self.recommend = [aDecoder decodeIntForKey:@"recommend"];
        NSLog(@">>>>>>praisedExpertMessageIds: %@" , self.praisedExpertMessageIds);
    }
    
    return self;
}


- (void) initBaseData
{
    self.user = nil;
}

+ (NSString *) savedPath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"appStatus.archive"];
    //    NSLog(@"____________________%@",documentDirectory);
    return documentDirectory;

}

+(void) saveAppStatus{
    NSLog(@"AppStatus to be saving:%@", [AppStatus sharedInstance].description);
    [NSKeyedArchiver archiveRootObject:[AppStatus sharedInstance] toFile:[AppStatus savedPath]];
}

-(NSString *)appVersion{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    return [dicInfo objectForKey:@"CFBundleShortVersionString"];
}


-(void) addPraiseId:(NSString *)messasgeId
{
    if (self.praisedExpertMessageIds== nil) {
        self.praisedExpertMessageIds = [NSString new];
    }
    
    self.praisedExpertMessageIds = [NSString stringWithFormat:@"%@,%@" , self.praisedExpertMessageIds , messasgeId];
    
    [AppStatus saveAppStatus];
}

-(NSString *) description{
//    return [NSString stringWithFormat:@"deviceToken:%@, user:%@, lastLat:%f, lastLng:%f", self.deviceToken, self.user
//            .description, self.lastLat, self.lastLng];
    return @"";
}
@end
