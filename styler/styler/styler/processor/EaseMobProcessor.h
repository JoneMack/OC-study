//
//  EaseMobProcessor.h
//  styler
//
//  Created by System Administrator on 14-8-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"

@interface EaseMobProcessor : NSObject<IChatManagerDelegate>

+(void)    init:(UIApplication *)application
  launchOptions:(NSDictionary *)launchOptions;

+(void) login:(BOOL)delay;
+(void) logout;
+(int) unreadSupportMessageCount;
+(void) clearUnreadMessage:(EMConversation *)conversation;

+(void) registeDeviceToken:(UIApplication *)application deviceToken:(NSData *)deviceToken;

+(void) applicationWillResignActive:(UIApplication *)application;

+(void) applicationDidEnterBackground:(UIApplication *)application;

+(void) applicationWillEnterForeground:(UIApplication *)application;

+(void) applicationDidBecomeActive:(UIApplication *)application;

+(void) applicationWillTerminate:(UIApplication *)application;

+ (EaseMobProcessor *) sharedInstance;
@end
