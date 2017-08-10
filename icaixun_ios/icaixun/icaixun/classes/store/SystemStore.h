//
//  SystemStore.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/21.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"

@interface SystemStore : NSObject

+(SystemStore *) sharedInstance;

-(void) getAppInfo:(void (^)(AppInfo *appInfo , NSError *err))complectionBlock;

@end
