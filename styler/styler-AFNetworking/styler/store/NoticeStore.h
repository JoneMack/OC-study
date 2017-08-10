//
//  NoticeStore.h
//  styler
//
//  Created by System Administrator on 13-6-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@interface NoticeStore : NSObject

-(void) getNotices:(void (^)(NSArray *notices, NSError *err))completionBlock refresh:(BOOL)refresh;

+(NoticeStore *) sharedStore;

@end
