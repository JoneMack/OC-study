//
//  HdcPaymentItem.h
//  styler
//
//  Created by 冯聪智 on 14-8-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedEnvelope.h"

@protocol HdcPaymentItem

@end

@interface HdcPaymentItem : JSONModel

@property int redEnvelopeId;
@property int paymentItemType;
@property float paymentItemAmount;

@property (nonatomic , strong) RedEnvelope<Optional> *redEnvelope;

@end
