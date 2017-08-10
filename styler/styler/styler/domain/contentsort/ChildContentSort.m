//
//  ContentSort.m
//  styler
//
//  Created by aypc on 13-12-27.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "ChildContentSort.h"

@implementation ChildContentSort


-(NSString *)description
{
    return [NSString stringWithFormat:@"name:%@, id:%@, contentType:%d, ",self.name,self.contentSortId,self.contentModeType];
}
@end
