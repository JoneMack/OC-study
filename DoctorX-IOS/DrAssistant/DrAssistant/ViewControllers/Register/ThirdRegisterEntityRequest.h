//
//  ThirdRegisterEntityRequest.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/14.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
@interface ThirdRegisterEntityRequest : BaseEntity
/*request*/
@property (nonatomic, strong) NSString *s_token;
@property (nonatomic,strong) NSString* account;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong,readonly) NSString *sign;
@property (nonatomic,assign) int role; /*0医生 1患者*/
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *birthPlace;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *education;

- (NSDictionary *)dictionaryOfEntity;
@end
