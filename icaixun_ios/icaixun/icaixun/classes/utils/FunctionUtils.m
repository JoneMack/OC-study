//
//  FunctionUtils.m
//  styler
//
//  Created by 冯聪智 on 14-9-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "FunctionUtils.h"

@implementation FunctionUtils


+(void)setTimeout:(void (^)())block delayTime:(float)delayTime{
    [self performSelector:@selector(runBlock:) withObject:block afterDelay:delayTime];
}


+(void) runBlock:(void (^)())block{
    block();
}

@end
