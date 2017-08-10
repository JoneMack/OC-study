//
//  HairCutPriceInfo.h
//  styler
//
//  Created by wangwanggy820 on 14-5-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "JSONSerializable.h"

@protocol hairCutPriceInfo
@end

@interface HairCutPriceInfo : JSONModel

@property (copy, nonatomic) NSString<Optional> *specialOfferInfo;
@property int price;
@property int specialOfferPrice;

@end
