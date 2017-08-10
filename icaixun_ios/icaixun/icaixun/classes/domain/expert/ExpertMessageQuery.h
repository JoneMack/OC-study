//
//  ExpertMessageQuery.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/18.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertMessageQuery : JSONModel

@property (nonatomic , strong) NSArray *expertIds;
@property (nonatomic , assign) BOOL includeDeleted;
@property (nonatomic , assign) BOOL cacheFlag;
@property (nonatomic , assign) int pageNo;
@property (nonatomic , assign) int pageSize;


-(ExpertMessageQuery *) initWithExpertIds:(NSArray *)expertIds;

@end
