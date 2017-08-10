//
//  UploadImageResponseEntity.m
//  DrAssistant
//
//  Created by taller on 15/9/25.
//  Copyright © 2015年 Doctor. All rights reserved.
//
#import "UploadImageResponseEntity.h"
@interface UploadImageResponseEntity ()
@property (nonatomic,assign,readwrite) NSInteger timestmp;
@end

@implementation UploadImageResponseEntity
@synthesize dataDic;
+ (UploadImageResponseEntity *)entityOfDic:(NSDictionary *)dic
{
    UploadImageResponseEntity *entity = [[UploadImageResponseEntity alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    entity.timestmp = [dic intValueForKey:@"timestmp"];
    entity.dataDic = [dic stringValueForKey:@"data"];
    return entity;
}

@end
