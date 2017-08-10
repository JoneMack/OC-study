//
//  ContentSort.h
//  styler
//
//  Created by System Administrator on 14-1-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ChildContentSort.h"

@protocol ContentSort
@end

@interface ContentSort : JSONModel

@property int id;
@property (copy, nonatomic) NSString<Optional> *extendParam;
@property int contentModeType;
@property (copy, nonatomic) NSString *name;

@end
