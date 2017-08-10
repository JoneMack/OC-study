//
//  PointOrder.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/13.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointOrder : JSONModel

@property (nonatomic , assign) int userId;
@property (nonatomic , assign) int point;
@property (nonatomic , copy) NSString *orderNo;
@property (nonatomic , assign) float amount;
@property (nonatomic , copy) NSString *addPointTypeTxt;
@property (nonatomic , copy) NSString *status;

@property (nonatomic , assign) long long int createTime;

-(NSString *) getPoint;

@end

