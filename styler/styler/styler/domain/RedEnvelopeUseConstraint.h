//
//  RedEnvelopeUseConstraint.h
//  styler
//
//  Created by 冯聪智 on 14-8-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

@protocol RedEnvelopeUseConstraint

@end

@interface RedEnvelopeUseConstraint : JSONModel

@property (nonatomic , retain) NSNumber<Optional> *expiredTime;

@end
