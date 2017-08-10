//
//  RedEnvelopeSeed.m
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "RedEnvelopeSeed.h"

@implementation RedEnvelopeSeed

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeObject:self.distributeStrage forKey:@"distributeStrage"];
    [aCoder encodeBool:self.exhaused forKey:@"exhaused"];
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if(self){
        self.id = [aDecoder decodeIntForKey:@"id"];
        self.distributeStrage = [aDecoder decodeObjectForKey:@"distributeStrage"];
        self.exhaused = [aDecoder decodeBoolForKey:@"exhaused"];
    }
    return self;
}


@end
