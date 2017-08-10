//
//  AddCaseEntity.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface AddCaseEntity : BaseEntity

@property (nonatomic,strong)UserContext *userEntity;

- (NSDictionary *)dictionaryOfEntity;

+ (AddCaseEntity *)entityOfDic:(NSDictionary *)dic;
@end
