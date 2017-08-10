//
//  FeedbackStore.h
//  styler
//
//  Created by System Administrator on 13-6-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

@interface FeedbackStore : NSObject

-(void)sendFeedback:(void (^)(int sessionId, NSError *err))completionBlock msg:(NSString *)msg;
-(void)getLastSessionMsg:(void (^)(NSArray *msgs, NSError *err))completionBlock sessionId:(int)sessionId refresh:(BOOL)refresh;

+(FeedbackStore *) sharedStore;

@end
