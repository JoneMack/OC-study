//
//  RedEnvelopeStore.h
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "RedEnvelopeQuery.h"
#import "Page.h"
#import "RedEnvelope.h"
#import "RedEnvelopeSeed.h"

@interface RedEnvelopeStore : NSObject

+(void) getMyRedEnvelopes:(void(^)(Page *page ,NSError *error))completionBlock
            redEnvelopeQuery:(RedEnvelopeQuery *)redEnvelopeQuery
            hairDressingCardId:(int)hairDressingCardId;

+(void) getRedEnvelopesByIds:(void(^)(NSArray *items ,NSError *error))completionBlock
            redEnvelopeIds:(NSArray *)redenvelopeIds;


+(void) getRedEnvelopeSeedById:(void(^)(RedEnvelopeSeed *redEnvelopeSeed ,NSError *error))completionBlock
                 redEnvelopeSeedId:(int)redEnvelopeSeedId;

@end
