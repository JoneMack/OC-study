//
//  PPerfectHandler.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/11.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface PPerfectEntity : BaseEntity

@property (nonatomic,strong)UserContext *userEntity;

- (NSDictionary *)dictionaryOfEntity;

+ (PPerfectEntity *)entityOfDic:(NSDictionary *)dic;

@end
