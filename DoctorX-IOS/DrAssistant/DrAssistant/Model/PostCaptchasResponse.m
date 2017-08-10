//
//  PostCaptchasResponse.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "PostCaptchasResponse.h"

@interface PostCaptchasResponse ()
@end

@implementation PostCaptchasResponse

+ (PostCaptchasResponse *)entityOfDic:(NSDictionary *)dic
{
    PostCaptchasResponse *entity = [[PostCaptchasResponse alloc] init];
    entity.success = [dic boolValueForKey: @"success"];
    entity.msg = [dic stringValueForKey: @"msg"];
    NSDictionary *dataDic = [dic dictionaryForkey:@"data"];
    entity.code = [dataDic stringValueForKey:@"code"];
    entity.lastTime = [dataDic integerForKey: @"lastTime"];
    entity.account = [dataDic stringValueForKey:@"account"];
    
    return entity;
}

@end
