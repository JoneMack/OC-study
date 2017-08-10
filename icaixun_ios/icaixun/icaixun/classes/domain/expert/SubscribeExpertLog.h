//
//  SubscribeExpertLog.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/12.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeExpertLog : JSONModel

@property (nonatomic , assign) int id;
@property (nonatomic , assign) int userId;
@property (nonatomic , assign) int expertId;
@property (nonatomic , copy  ) NSString<Optional> *expertName;
@property (nonatomic , assign) int point;
@property (nonatomic , copy)   NSString *subscribePriceTypeTxt;

@property (nonatomic ,assign) long long int createTime;

-(NSString *) getCostPoint;

@end
