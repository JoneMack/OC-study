//
//  ServiceCondition.h
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ServiceCondition 
@end

@interface ServiceCondition : JSONModel

@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *value;


@end
