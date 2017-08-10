//
//  SpecialOfferServiceItem.h
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceCondition.h"
#import "JSONModel.h"

@protocol SpecialOfferServiceItem
@end

@interface SpecialOfferServiceItem : JSONModel
@property(copy, nonatomic) NSString *name;
@property(strong, nonatomic) NSArray<ServiceCondition, Optional> *serviceConditions;

@end
