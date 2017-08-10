//
//  UserAccount.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/9.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

//-(void) encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeInteger:self.point forKey:@"point"];
//}
//
//-(id) initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    
//    if(self){
//        self.point = [aDecoder decodeIntForKey:@"point"];
//    }
//    
//    return self;
//}
//
- (void) readFromJSONDictionary:(NSDictionary *)jsonDict{
    
    [self setPoint:[[jsonDict objectForKey:@"point"] intValue]];
}
//
//-(UserAccount *) copyWithZone:(NSZone *)zone{
//    UserAccount *userAccount = [[UserAccount allocWithZone:zone] init];
//    
//    userAccount.point = self.point;
//    return userAccount;
//}



@end
