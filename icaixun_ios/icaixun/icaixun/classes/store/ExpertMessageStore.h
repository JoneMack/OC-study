//
//  ExpertMessageStore.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/18.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertMessage.h"


@interface ExpertMessageStore : NSObject


+(ExpertMessageStore *) sharedInstance;


-(void) getExpertMessagesByExpertIds:(void (^)(Page *page , NSError *err))completionBlock expertIds:(NSArray *)expertIds pageNo:(int)pageNo pageSize:(int)pageSize;

-(void) praiseExpertMessage:(void (^)(ExpertMessage *message , NSError *err))completionBlock messageId:(NSString *)messageId;

@end
