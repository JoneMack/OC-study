//
//  Message.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/19.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "Message.h"
#import <WCDB/WCDB.h>
@implementation Message

WCDB_IMPLEMENTATION(Message)
WCDB_SYNTHESIZE(Message, localID)
WCDB_SYNTHESIZE(Message, content)
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)

WCDB_PRIMARY(Message, localID)

WCDB_INDEX(Message, "_index", createTime)

@end
