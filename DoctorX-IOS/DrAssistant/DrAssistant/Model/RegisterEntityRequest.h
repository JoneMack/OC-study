//
//  RegisterEntity.h
//  DrAssistant
//
//  Created by 刘亮 on 15/8/30.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface RegisterEntityRequest : BaseEntity
/*request*/
@property (nonatomic,strong) NSString* account;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong,readonly) NSString *sign;
@property (nonatomic,assign) int role; /*0医生 1患者*/

- (NSDictionary *)dictionaryOfEntity;

@end
