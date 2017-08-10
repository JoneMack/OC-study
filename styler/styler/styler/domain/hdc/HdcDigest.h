//
//  HdcDigest.h
//  styler
//
//  Created by wangwanggy820 on 14-7-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HairDressingCard.h"
#import "UserHdc.h"
#import "Organization.h"

@interface HdcDigest : NSObject

@property (nonatomic, copy) NSString *specialOfferPriceString;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *timeNote;
@property (nonatomic, copy) NSString *organizationName;

-(id) initWithHdc:(HairDressingCard *)hdc organization:(Organization *)organization;
-(id) initWithUserHdc:(UserHdc *)hdc organization:(Organization *)organization;

@end
