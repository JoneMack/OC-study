//
//  XMLDocument.m
//  styler
//
//  Created by 冯聪智 on 14-10-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "XMLDocument.h"

@implementation XMLDocument

-(id) init{
    self = [super init];
    self.keys = [[NSMutableArray alloc] init];
    self.values = [[NSMutableArray alloc] init];
    return self;
}

@end
