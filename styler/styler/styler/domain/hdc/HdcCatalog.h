//
//  HdcCatalog.h
//  styler
//
//  Created by 冯聪智 on 14/11/3.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HdcType.h"

@protocol HdcCatalog
@end

@interface HdcCatalog : JSONModel

@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSArray<HdcType,Optional> *hdcTypes;

@end
