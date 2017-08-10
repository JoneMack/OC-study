//
//  AppStatus.m
//  styler
//
//  Created by System Administrator on 13-5-13.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "AppStatus.h"

@implementation AppStatus

//是否登录
-(BOOL) logined{
    
    if(self.user != nil && self.token != nil && (NSNull *)self.token != [NSNull null])
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

-(float) getLastLat{
    if (_lastLat == 0) {
        return 39.921787;
    }
    return _lastLat;
}

-(float) getLastLng{
    if (_lastLng == 0) {
        return 116.487922;
    }
    return _lastLng;
}



-(void) encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeDouble:self.lastLat forKey:@"lastLat"];
    [aCoder encodeDouble:self.lastLng forKey:@"lastLng"];
//    [aCoder encodeObject:self.cityName forKey:@"City"];
//    [aCoder encodeObject:self.currentLocation forKey:@"currentLocation"];
    [aCoder encodeObject:self.user forKey:@"user"];
//    [aCoder encodeBool:self.isComplete forKey:@"isComplete"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.searchConditions forKey:@"searchConditions"];
    
}



-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.lastLat = [aDecoder decodeDoubleForKey:@"lastLat"];
        self.lastLng = [aDecoder decodeDoubleForKey:@"lastLng"];
//        self.cityName = [aDecoder decodeObjectForKey:@"City"];
//        self.currentLocation = [aDecoder decodeObjectForKey:@"currentLocation"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
//        self.saveDate = [aDecoder decodeObjectForKey:@"saveDate"];
//        self.isComplete = [aDecoder decodeBoolForKey:@"isComplete"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.searchConditions = [aDecoder decodeObjectForKey:@"searchConditions"];
    }
    return self;
}


-(void) addSearchCondition:(NSString *)condition
{
    if([NSStringUtils isBlank:condition]){
        return ;
    }
    
    if( [self.searchConditions containsObject:condition]){
        return ;
    }
    
    if(self.searchConditions == nil){
        self.searchConditions = [[NSMutableArray alloc] init];
    }
    [self.searchConditions addObject:condition];
    [AppStatus saveAppStatus];
}


-(void) clearSearchConditions
{
    self.searchConditions = nil;
    [AppStatus saveAppStatus];
}


+(void) saveAppStatus{
    
    NSLog(@"AppStatus to be saving:%@", [AppStatus sharedInstance].description);
    
    BOOL saveFlag = [NSKeyedArchiver archiveRootObject:[AppStatus sharedInstance] toFile:[AppStatus savedPath]];
    if(saveFlag){
        NSLog(@"保存成功");
        
    }else{
        NSLog(@"保存失败");
    }
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
        }
        NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
        sharedInstance.apiUrl = [dicInfo objectForKey:@"apiUrl"];
        sharedInstance.env = [dicInfo objectForKey:@"env"];
        sharedInstance.umengAppKey = [dicInfo objectForKey:@"umengAppKey"];
        
        sharedInstance.umengPushAppKey = [dicInfo objectForKey:@"umengPushAppKey"];
    }
    return sharedInstance;
}


/**
 *  初始化AppStatus 基本数据。
 */
-(void) initBaseData{
    self.user = nil;
    self.token = @"";
}


-(NSString *) description{
    return [NSString stringWithFormat:@"deviceToken:%@, user:%@, ", self.token, self.user.description];
}

@end
