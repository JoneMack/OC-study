//
//  MyAssistantEntity.h
//  DrAssistant
//
//  Created by hi on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"
#import "UserEntity.h"

@interface MyAssistantEntity : BaseEntity

@property (nonatomic, strong) UserEntity *data;

@end
