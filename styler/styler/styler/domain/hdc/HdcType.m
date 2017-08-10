//
//  HdcType.m
//  styler
//
//  Created by System Administrator on 14-7-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "HdcType.h"

@implementation HdcType

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.type forKey:@"type"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeObject:self.iconUrl forKey:@"iconUrl"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.type = [aDecoder decodeIntForKey:@"type"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
    }
    return self;
}


@end
