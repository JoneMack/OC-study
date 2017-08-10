//
//  ExceptionMsg.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ExceptionMsg.h"

@implementation ExceptionMsg

-(void) readFromJSONDictionary:(NSDictionary *)jsonDict{
    [self setStatus:[[jsonDict objectForKey:@"status"] intValue]];
    [self setCode:[[jsonDict objectForKey:@"code"] intValue]];
    [self setMessage:[jsonDict objectForKey:@"message"]];
}

@end
