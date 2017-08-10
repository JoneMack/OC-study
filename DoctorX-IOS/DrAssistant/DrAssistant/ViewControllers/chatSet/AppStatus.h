//
//  AppStatus.h
//  styler
//
//  Created by System Administrator on 13-5-13.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AppStatus : NSObject<NSCoding>

@property (nonatomic, assign) BOOL receiveMsgSwitch;
@property (nonatomic, assign) BOOL voiceSwitch;
@property (nonatomic, assign) BOOL shakeSwitch;
@property (nonatomic, assign) BOOL yangShengQiSwitch;


+(void) saveAppStatus;

+ (AppStatus *) sharedInstance;

+ (NSString *) savedPath;


@end
