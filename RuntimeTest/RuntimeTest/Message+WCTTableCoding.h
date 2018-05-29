//
//  Message+WCTTableCoding.h
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/19.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "Message.h"
#import <WCDB/WCDB.h>
@interface Message (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(localID)
WCDB_PROPERTY(content)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)

@end
