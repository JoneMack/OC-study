//
//  ExpertQuery.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/6.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExpertQuery

@end

@interface ExpertQuery : JSONModel

@property (nonatomic , strong) NSArray *expertIds;
@property (nonatomic , assign) BOOL cacheFlag;
@property (nonatomic , assign) int pageNo;
@property (nonatomic , assign) int pageSize;


-(id) initWithPageSize:(int)pageSize;

-(id) initWithExpertIds:(NSArray *)expertIds;


@end
