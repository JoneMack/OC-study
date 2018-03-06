//
//  User.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/6.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "User.h"

@implementation User
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.userId = [value integerValue];
    }else if ([key isEqualToString:@"username"]){
        self.name = value;
    }
}
@end
