//
//  ExpertScore.h
//  styler
//
//  Created by aypc on 13-12-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol StylistCount
@end

@interface StylistCount : JSONModel

@property int receivedEvaluationCount;
@property int deviceSingleUserOrderCount;
@property float effectScore;
@property float attitudeScore;
@property float promoteReasonableScore;
@property int worksCount;
@property int orderCount;

-(CGFloat)getAverageScore;

@end
