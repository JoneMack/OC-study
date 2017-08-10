//
//  DistributeStrage.m
//  styler
//
//  Created by 冯聪智 on 14-9-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "DistributeStrage.h"

@implementation DistributeStrage

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.amountType forKey:@"amountType"];
    [aCoder encodeBool:self.differentiateUser forKey:@"differentiateUser"];
//    [aCoder encodeInt:self.perAmount forKey:@"perAmount"];
     [aCoder encodeObject:self.perAmount forKey:@"perAmount"];
    [aCoder encodeObject:self.oldUserPerAmount forKey:@"oldUserPerAmount"];
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if(self){
        self.amountType = [aDecoder decodeIntForKey:@"amountType"];
        self.differentiateUser = [aDecoder decodeBoolForKey:@"differentiateUser"];
//        self.perAmount = [aDecoder decodeIntForKey:@"perAmount"];
        self.perAmount = [aDecoder decodeObjectForKey:@"perAmount"];
        self.oldUserPerAmount = [aDecoder decodeObjectForKey:@"oldUserPerAmount"];
    }
    return self;
}


@end
