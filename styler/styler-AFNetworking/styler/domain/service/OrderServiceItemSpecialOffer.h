//
//  OrderServiceItemSpecialOffer.h
//  styler
//
//  Created by System Administrator on 14-4-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "JSONModel.h"

@protocol OrderServiceItemSpecialOffer
@end

@interface OrderServiceItemSpecialOffer : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property int originSpecialOfferType;

@end
