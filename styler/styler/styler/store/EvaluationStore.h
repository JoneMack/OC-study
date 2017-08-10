//
//  EvaluationStore.h
//  styler
//
//  Created by aypc on 13-12-7.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Evaluation.h"
#import "Page.h"


@interface EvaluationStore : NSObject

+(EvaluationStore*)shareInstance;
-(void) getEvaluationList:(void (^)(Page *page, NSError *err))completionBlock
                 stylistId:(int)stylistId
                   pageNo:(int)pageNo
                 pageSize:(int)pageSize
                  refresh:(BOOL)refresh;

-(void) submitEvaluation:(void(^)(NSError *err))completionBlock
              evaluation:(NewEvaluation *) evaluation
        evaluationImages:(NSArray *)imageArray;

-(void)getUserEvaluations:(void(^)(Page *page,NSError * err))completeBlock
                   pageNo:(int)pageNo
                 pageSize:(int)pageSize
                  refresh:(BOOL)refresh;

-(void)getOrganizationEvaluations:(void(^)(Page *page,NSError * err))completeBlock
                   organizationId:(int)organizationId
                           pageNo:(int)pageNo
                         pageSize:(int)pageSize
                          refresh:(BOOL)refresh;

+(void) checkEvaluationStatus:(void(^)(NSError *error))completeBlock;

@end
