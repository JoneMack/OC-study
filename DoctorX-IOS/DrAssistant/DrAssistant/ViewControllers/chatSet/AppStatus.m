//
//  AppStatus.m
//  styler
//
//  Created by System Administrator on 13-5-13.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "AppStatus.h"

@implementation AppStatus

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.receiveMsgSwitch forKey:@"receiveMsgSwitch"];
    [aCoder encodeBool:self.voiceSwitch forKey:@"voiceSwitch"];
    [aCoder encodeBool:self.shakeSwitch forKey:@"shakeSwitch"];
    [aCoder encodeBool:self.yangShengQiSwitch forKey:@"yangShengQiSwitch"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.receiveMsgSwitch = [aDecoder decodeBoolForKey:@"receiveMsgSwitch"];
        self.voiceSwitch = [aDecoder decodeBoolForKey:@"voiceSwitch"];
        self.shakeSwitch = [aDecoder decodeBoolForKey:@"shakeSwitch"];
        self.yangShengQiSwitch = [aDecoder decodeBoolForKey:@"yangShengQiSwitch"];
    }
    return self;
}

+(void) saveAppStatus{
    NSLog(@"AppStatus to be saving:%@", [AppStatus sharedInstance].description);
    [NSKeyedArchiver archiveRootObject:[AppStatus sharedInstance] toFile:[AppStatus savedPath]];
}

+(NSString *) savedPath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"switch.plist"];
    NSLog(@"____________________%@",documentDirectory);
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
    }
    return sharedInstance;
}

-(NSString *) description{
    return [NSString stringWithFormat:@"receiveMsgSwitch:%d, voiceSwitch:%d, shakeSwitch:%d, yangShengQiSwitch:%d", self.receiveMsgSwitch, self.voiceSwitch,self.shakeSwitch, self.yangShengQiSwitch];
}

@end
