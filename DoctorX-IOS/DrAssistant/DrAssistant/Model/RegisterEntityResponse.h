//
//  RegisterEntityResponse.h
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface RegisterEntityResponse : BaseEntity

@property (nonatomic,assign,readwrite) NSInteger timestmp;
@property (nonatomic,strong,readwrite) NSDictionary *dataDic;

+ (RegisterEntityResponse *)entityOfDic:(NSDictionary *)dic;

@end
