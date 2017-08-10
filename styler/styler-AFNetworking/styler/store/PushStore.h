//
//  PushStore.h
//  styler
//
//  Created by System Administrator on 13-6-20.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@interface PushStore : NSObject

//获取未读PUSH
-(void) getUnreadPush:(void (^)(NSArray *pushRecords, NSError *err))completionBlock;

//确认PUSH已读
-(void) checkPush:(void (^)(NSError *err))completionBlock pushSNArray:(NSArray *)pushSNArray;

+(PushStore *) sharedStore;

@end
