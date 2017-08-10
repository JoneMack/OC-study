//
//  BusinessCircles.h
//  iUser
//
//  Created by System Administrator on 13-4-8.
//  Copyright (c) 2013年 珠元玉睿ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "JSONModel.h"

@protocol BusinessCircles
@end

@interface BusinessCircles : JSONModel

@property int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) int expertCount;

@end
