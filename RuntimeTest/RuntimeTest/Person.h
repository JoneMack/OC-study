//
//  Person.h
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
@interface Person : NSObject

@property (nonatomic) Address *address;
@property (nonatomic, assign) int sex;
@property (nonatomic, assign) int gender;

@end
