//
//  UMengProcessor.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/7.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMengProcessor : NSObject

@property int forcedToUpdate;

-(void) checkUpdate;

+(void) initUMengSDK;

+ (UMengProcessor *) sharedInstance;

@end
