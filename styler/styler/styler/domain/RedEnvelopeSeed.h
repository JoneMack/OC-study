//
//  RedEnvelopeSeed.h
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistributeStrage.h"

@protocol RedEnvelopeSeed
@end

@interface RedEnvelopeSeed : JSONModel <NSCoding>

@property int id;
@property (nonatomic , strong) DistributeStrage *distributeStrage;
@property BOOL exhaused;


@end
