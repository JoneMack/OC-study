//
//  TargetServiceItems.m
//  styler
//
//  Created by wangwanggy820 on 14-3-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "TargetServiceItems.h"
#import "TargetServiceItem.h"
#import "OptionValueDescription.h"

@implementation TargetServiceItems

-(NSString *)serviceDescriptionsString{
    return [self.serviceDescriptions componentsJoinedByString:@"\n"];
}

-(NSString *)specialOfferDescriptionsString{
    return [self.specialOfferDescriptions componentsJoinedByString:@"\n"];
}

@end
