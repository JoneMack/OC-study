//
//  HdcType.h
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HdcType
@end

@interface HdcType : JSONModel

@property int type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic , copy) NSString *color;
@end
