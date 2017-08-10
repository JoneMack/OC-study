//
//  HealthDetailDataEntity.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/28.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
@interface HealthDetailDataEntity : BaseEntity
//@property (nonatomic, strong) NSArray *data;
//@property (nonatomic, strong) NSString *ID;
//@property (nonatomic, strong) NSString *RECORD;
//@property (nonatomic, strong) NSString *RECORD_IMG;
//@property (nonatomic, strong) NSString *RECORD_TIME;
//@property (nonatomic, strong) NSString *TYPE;
@property (nonatomic, strong) NSString *USER_ID;
//@property (nonatomic, strong) NSString *CLUB_ID;
//@property (nonatomic, strong) NSString *SSY;
//@property (nonatomic, strong) NSString *SZY;
//@property (nonatomic, strong) NSString *XL;

+ (HealthDetailDataEntity *)entityOfDic:(NSDictionary *)dic;

@end
