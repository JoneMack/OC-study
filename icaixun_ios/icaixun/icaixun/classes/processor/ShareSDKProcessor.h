//
//  ShareSDKProcessor.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/17.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSDKProcessor : NSObject

+(void) initShareSDK;

+(ShareSDKProcessor *) sharedInstance;

-(void) share:(UIView *)view title:(NSString *)title;

@end
