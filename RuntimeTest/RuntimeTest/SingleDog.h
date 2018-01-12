//
//  SingleDog.h
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleDog : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *gender;

+ (void) printDZ;

+ (instancetype)zg_modelFromDic:(NSDictionary *)dataDic;

@end
