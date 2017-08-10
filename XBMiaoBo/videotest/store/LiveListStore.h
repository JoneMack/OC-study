//
//  LiveListStore.h
//  videotest
//
//  Created by xubojoy on 16/9/12.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Page.h"
@interface LiveListStore : NSObject
+ (void)getAllLiveList:(void(^)(NSArray *listArray ,NSError *error))completionBlock pageNo:(int)pageNo;
+ (LiveListStore *)sharedInstance;
@end
