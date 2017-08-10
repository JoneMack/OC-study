//
//  StylistServicePackage.h
//  styler
//
//  Created by wangwanggy820 on 14-3-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TargetServiceItems.h"
#import "JSONModel.h"

@protocol StylistServicePackage
@end

@interface StylistServicePackage : JSONModel

@property(copy ,nonatomic) NSString *name;
@property(copy ,nonatomic) NSString *icon;
@property(strong ,nonatomic) TargetServiceItems *targetServiceItemSuite;

@end
