//
//  OptionValueDescriptions.h
//  styler
//
//  Created by wangwanggy820 on 14-4-2.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol OptionValueDescription
@end

@interface OptionValueDescription : JSONModel

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *value;
@property (copy, nonatomic) NSString *description;
@property int stylistId;

@end
