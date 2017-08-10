//
//  RedEnvelope.h
//  styler
//
//  Created by System Administrator on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define red_envelope_status_bind 2
#define red_envelope_status_locked 3
#define red_envelope_status_used 4
#define red_envelope_status_expired 5

#import "RedEnvelopeUseConstraint.h"

@protocol RedEnvelope
@end

@interface RedEnvelope : JSONModel

@property int id;
@property int amount;
@property int status;
@property (nonatomic, strong) NSNumber<Optional> *bindingTime;
@property (nonatomic, strong) NSNumber<Optional> *useTime;
@property (nonatomic, strong) NSNumber<Optional> *expiredTime;
@property (copy, nonatomic) NSString *redEnvelopeNo;
@property (nonatomic, strong) RedEnvelopeUseConstraint *useConstraint;

-(NSString *) getStatusTxt;
-(NSString *) getTimeNoteTxt;

@end
