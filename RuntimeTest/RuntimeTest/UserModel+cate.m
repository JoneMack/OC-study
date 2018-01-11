//
//  UserModel+cate.m
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/17.
//  Copyright © 2017年 xubojoy. All rights reserved.
//
#import <objc/runtime.h>
#import "UserModel+cate.h"

@implementation UserModel (cate)
- (NSString *)remark{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setRemark:(NSString *)remark{
    objc_setAssociatedObject(self, @selector(remark), remark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
