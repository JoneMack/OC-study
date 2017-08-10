//
//  HdcDigest.m
//  styler
//
//  Created by wangwanggy820 on 14-7-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HdcDigest.h"

@implementation HdcDigest

-(id) initWithHdc:(HairDressingCard *)hdc organization:(Organization *)organization{
    self = [super init];
    if (self) {
        self.specialOfferPriceString = [hdc specialOfferPriceTxt];
        self.iconUrl = hdc.iconUrl;
        self.title = hdc.title;
        self.timeNote =  [NSString stringWithFormat:@"%@前可以使用", [hdc expiredTimeString]];
        self.organizationName = organization.name;
    }
    return self;
}

-(id) initWithUserHdc:(UserHdc *)hdc organization:(Organization *)organization{
    self = [super init];
    if (self) {
        self.specialOfferPriceString = [hdc specialOfferPriceTxt];
        self.iconUrl = hdc.iconUrl;
        self.title = hdc.title;
        self.timeNote = [hdc timeNoteString];
        self.organizationName = organization.name;
    }
    return self;
}
@end
