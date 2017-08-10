//
//  MJExtensionConfig.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "AdsEntity.h"
#import "HealthDataEntity.h"
#import "MyDoctorEntity.h"
#import "GroupInfoEntity.h"
#import "GroupListEntity.h"
#import "MyAssistantEntity.h"

@implementation MJExtensionConfig
/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
#pragma mark 如果使用NSObject来调用这些方法，代表所有类都会生效
    

#pragma mark StatusResult类中的ads数组中存放的是Ad模型
    [AdsEntity setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"data" : @"AdsEntity"
                 };
    }];
    
    [HealthDataEntity setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"data" : @"HealthDataEntity"
                 };
    }];
    
    [MyDoctorEntity setupObjectClassInArray:^NSDictionary *{
        return @{@"data" : @"MyDoctorEntity"};
    }];
    
    [UserEntity setupObjectClassInArray:^NSDictionary *{
        return @{@"data" : @"UserEntity"};
    }];
    
    [GroupListEntity setupObjectClassInArray:^NSDictionary *{
        return @{@"data" : @"GroupInfoEntity"};
    }];
    
    [GroupInfoEntity setupObjectClassInArray:^NSDictionary *{
        return @{@"friends" : @"UserEntity"};
    }];
    
}

@end
