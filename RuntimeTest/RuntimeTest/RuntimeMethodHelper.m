//
//  RuntimeMethodHelper.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/13.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "RuntimeMethodHelper.h"

@implementation RuntimeMethodHelper

- (void)hello{
    NSLog(@"%@ , %p",self,_cmd);
}

@end
