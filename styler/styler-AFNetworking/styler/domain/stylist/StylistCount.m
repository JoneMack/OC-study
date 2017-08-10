//
//  ExpertScore.m
//  styler
//
//  Created by aypc on 13-12-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "StylistCount.h"

@implementation StylistCount

-(CGFloat)getAverageScore
{
    if (self.receivedEvaluationCount == 0) {
        return 3.0;
    }
    float averageScore = (self.effectScore + self.promoteReasonableScore + self.attitudeScore ) / (3*self.receivedEvaluationCount);
    if (averageScore >= 4.95) {
        averageScore = 5.0;
    }
    return averageScore;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"effect:%f attitude:%f promote:%f receivedEvaluationCount:%d",self.effectScore,self.attitudeScore,self.promoteReasonableScore,self.receivedEvaluationCount];
}

@end
