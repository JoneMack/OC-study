//
//  PostCaptchasResponse.h
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface PostCaptchasResponse : BaseEntity

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger lastTime;
@property (nonatomic,strong,readonly) NSDictionary *dataDic;

+ (PostCaptchasResponse *)entityOfDic:(NSDictionary *)dic;

@end
