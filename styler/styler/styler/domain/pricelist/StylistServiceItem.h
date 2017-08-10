//
//  StylistServiceItem.h
//  styler
//
//  Created by wangwanggy820 on 14-3-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StylistServiceItemPrice.h"
#import "JSONModel.h"
#import "StylistServiceItemPrice.h"

@protocol StylistServiceItem
@end

@interface StylistServiceItem : JSONModel
@property(copy, nonatomic) NSString *name;
@property int serviceTime;
@property BOOL defaultProvide;
@property(strong, nonatomic) NSArray<StylistServiceItemPrice> *serviceItemPrices;

-(int)minPriceIndex;

@end
