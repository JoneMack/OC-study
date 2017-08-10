//
//  FunctionUtils.h
//  styler
//
//  Created by 冯聪智 on 14-9-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionUtils : NSObject

+(void)setTimeout:(void (^)())block delayTime:(float)delayTime;

@end
