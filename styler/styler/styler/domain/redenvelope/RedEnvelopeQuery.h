//
//  RedEnvelopeQuery.h
//  styler
//
//  Created by System Administrator on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

@protocol RedEnvelopeQuery

@end

@interface RedEnvelopeQuery : JSONModel

@property (strong, nonatomic) NSArray *statues;
@property int userId;
@property int pageNo;
@property int pageSize;

@end
