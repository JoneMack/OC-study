//
//  HealthDataEntity.h
//  DrAssistant
//
//  Created by hi on 15/9/9.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface HealthDataEntity : BaseEntity

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *USER_ID;
@property (nonatomic, copy) NSString *RECORD;
@property (nonatomic, copy) NSString *RECORD_IMG;
@property (nonatomic, copy) NSString *RECORD_REC;
@property (nonatomic, copy) NSString *RECORD_TIME;
@property (nonatomic, copy) NSString *SZY;
@property (nonatomic, copy) NSString *SSY;
@property (nonatomic, copy) NSString *XL;
@property (nonatomic, copy) NSString *KFXT;
@property (nonatomic, copy) NSString *CHXT;
@property (nonatomic, copy) NSString *XYBHD;
@property (nonatomic, assign) NSInteger TYPE;
@property  (nonatomic, copy)NSString *CLUB_ID;
@end
