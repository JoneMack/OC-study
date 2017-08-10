//
//  UserExpertRelation.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/6.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserExpertRelation

@end

@interface UserExpertRelation : JSONModel


@property (nonatomic, copy) NSString *id;
@property (nonatomic , assign) int userId;
@property (nonatomic , assign) int expertId;
@property (nonatomic , copy) NSString *status;
@property (nonatomic , copy) NSString *massageReceiveStatus;
@property (nonatomic , assign) long long int endTime;


@end
