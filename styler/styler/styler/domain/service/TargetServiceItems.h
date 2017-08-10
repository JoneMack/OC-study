//
//  TargetServiceItems.h
//  styler
//
//  Created by wangwanggy820 on 14-3-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "TargetServiceItem.h"
#import "OptionValueDescription.h"

@protocol TargetServiceItems
@end

@interface TargetServiceItems : JSONModel

@property int serviceTime;
@property(copy, nonatomic) NSArray<OptionValueDescription, Optional> *optionValueDescriptions;
@property int price;
@property int specialOfferPrice;
@property(strong, nonatomic) NSArray<TargetServiceItem> *targetServiceItems;
@property(copy, nonatomic) NSArray<Optional> *specialOfferDescriptions;
@property(copy, nonatomic) NSArray<Optional> *serviceDescriptions;

-(NSString *) specialOfferDescriptionsString;
-(NSString *) serviceDescriptionsString;

@end
