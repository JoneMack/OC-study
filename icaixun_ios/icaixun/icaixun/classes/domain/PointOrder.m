//
//  PointOrder.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/13.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "PointOrder.h"

@implementation PointOrder


-(NSString *) getPoint
{
    if ([self.status isEqualToString:@"subscribe"]) {
        return [NSString stringWithFormat:@"- %d" , self.point];
    }
    
    return [NSString stringWithFormat:@"+ %d" , self.point];
}



@end
