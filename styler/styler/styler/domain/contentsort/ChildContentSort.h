//
//  ContentSort.h
//  styler
//
//  Created by aypc on 13-12-27.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ChildContentSort
@end

@interface ChildContentSort : JSONModel
@property (assign, nonatomic) int id;
@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * contentSortId;
@property (copy, nonatomic) NSString * iconUrl;
@property (copy, nonatomic) NSString<Optional> *extendParam;
@property int contentModeType;

@end
