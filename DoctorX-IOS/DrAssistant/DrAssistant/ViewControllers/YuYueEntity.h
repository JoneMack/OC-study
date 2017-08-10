//
//  YuYueEntity.h
//  DrAssistant
//
//  Created by taller on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface YuYueEntity : BaseEntity
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *u_id;
@property (nonatomic, copy) NSString *note;//备注
@property (nonatomic, copy) NSString *time;//预约的时间时间
@property (nonatomic, copy) NSString *doctor_id;
@property (nonatomic, copy) NSString *operate_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *userName;
@end